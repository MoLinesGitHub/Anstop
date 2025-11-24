//
//  PurchaseManager.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import Observation
import StoreKit

@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isLoading: Bool = false

    private let productIdentifiers: Set<String> = [
        "premium.monthly",
        "premium.yearly",
    ]

    var isPremium: Bool {
        !purchasedProductIDs.isEmpty
    }

    init() {
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    @MainActor
    func loadProducts() async {
        isLoading = true
        do {
            products = try await Product.products(for: productIdentifiers)
            products.sort { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
        isLoading = false
    }

    @MainActor
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updatePurchasedProducts()
            return true

        case .userCancelled:
            return false

        case .pending:
            return false

        @unknown default:
            return false
        }
    }

    @MainActor
    func restorePurchases() async {
        await updatePurchasedProducts()
    }

    @MainActor
    private func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedIDs.insert(transaction.productID)
            }
        }

        purchasedProductIDs = purchasedIDs
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
