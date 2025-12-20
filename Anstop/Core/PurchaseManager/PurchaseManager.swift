import Observation
import OSLog
import StoreKit

@MainActor
@Observable
final class PurchaseManager {
    // Logger para contexto estático (nonisolated para evitar actor isolation)
    private nonisolated static let logger = Logger(subsystem: "com.molinesdesigns.Anstop", category: "purchases")

    // Global transaction updates listener to ensure we never miss updates
    private static let globalTransactionUpdatesTask: Task<Void, Never> = Task {
        for await result in Transaction.updates {
            guard case let .verified(transaction) = result else {
                logger.warning("Received unverified transaction update")
                continue
            }
            logger.info("[Global] Transaction update received for product: \(transaction.productID)")
            await handleGlobalTransactionUpdate(transaction)
        }
    }

    private nonisolated static func handleGlobalTransactionUpdate(_ transaction: Transaction) async {
        // Finish the transaction after handling. If you have a shared manager instance,
        // you can also refresh entitlements here.
        await transaction.finish()
    }

    // Singleton instance
    static let shared = PurchaseManager()

    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isLoading: Bool = false

    private let productIdentifiers: Set<String> = [
        "premium.monthly",
        "premium.yearly",
    ]

    private var transactionUpdatesTask: Task<Void, Never>?

    var isPremium: Bool {
        !purchasedProductIDs.isEmpty
    }

    init() {
        // Start listening for transaction updates
        transactionUpdatesTask = Task { @MainActor in
            await listenForTransactionUpdates()
        }

        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    deinit {
        // No necesitamos cancelar aquí, la tarea se cancela automáticamente
        // cuando el objeto es desreferenciado
    }

    func loadProducts() async {
        isLoading = true
        do {
            products = try await Product.products(for: productIdentifiers)
            products.sort { $0.price < $1.price }
            Logger.purchases.info("Successfully loaded \(self.products.count) products")
        } catch {
            Logger.purchases.error("Failed to load products: \(error.localizedDescription)")
        }
        isLoading = false
    }

    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()

        switch result {
        case let .success(verificationResult):
            // Validar con ReceiptValidator
            let transaction = try ReceiptValidator.shared.validateTransaction(verificationResult)

            // Verificar que esté activa
            guard ReceiptValidator.shared.isTransactionValid(transaction) else {
                throw ReceiptError.transactionRevoked
            }

            // Actualizar estado
            await updatePurchasedProducts()

            // Finalizar
            await transaction.finish()

            return true

        case .userCancelled:
            return false

        case .pending:
            return false

        @unknown default:
            return false
        }
    }

    func restorePurchases() async {
        await updatePurchasedProducts()
    }

    private func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []

        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result {
                purchasedIDs.insert(transaction.productID)
            }
        }

        purchasedProductIDs = purchasedIDs
    }

    private func listenForTransactionUpdates() async {
        // Instance-scoped listener (kept for redundancy); global listener above starts at launch.
        for await result in Transaction.updates {
            guard case let .verified(transaction) = result else {
                Logger.purchases.warning("Received unverified transaction update")
                continue
            }

            Logger.purchases.info("Transaction update received for product: \(transaction.productID)")

            // Update purchased products when transaction updates
            await updatePurchasedProducts()

            // Finish the transaction
            await transaction.finish()
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case let .verified(safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
