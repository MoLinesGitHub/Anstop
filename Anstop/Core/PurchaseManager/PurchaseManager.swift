import Observation
import StoreKit
import OSLog

@MainActor
@Observable
final class PurchaseManager {
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
        transactionUpdatesTask = Task {
            await listenForTransactionUpdates()
        }
        
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        transactionUpdatesTask?.cancel()
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
        case .success(let verificationResult):
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
            if case .verified(let transaction) = result {
                purchasedIDs.insert(transaction.productID)
            }
        }

        purchasedProductIDs = purchasedIDs
    }
    
    private func listenForTransactionUpdates() async {
        for await result in Transaction.updates {
            guard case .verified(let transaction) = result else {
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
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
