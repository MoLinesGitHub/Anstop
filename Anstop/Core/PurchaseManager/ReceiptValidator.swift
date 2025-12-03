//
//  ReceiptValidator.swift
//  Anstop
//
//  Created on 2025-12-03.
//

import StoreKit
import OSLog

enum ReceiptError: Error {
    case transactionRevoked
    case verificationFailed
    case invalidTransaction
}

/// Validates StoreKit 2 transactions to ensure they are legitimate and active.
@MainActor
final class ReceiptValidator {
    static let shared = ReceiptValidator()
    
    private init() {}
    
    /// Validates a verification result and returns the verified transaction if valid.
    /// - Parameter result: The verification result from StoreKit
    /// - Returns: The verified transaction
    /// - Throws: `ReceiptError.verificationFailed` if the transaction is not verified
    func validateTransaction<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let transaction):
            Logger.purchases.info("Transaction verification successful")
            return transaction
        case .unverified:
            Logger.purchases.error("Transaction verification failed")
            throw ReceiptError.verificationFailed
        }
    }
    
    /// Checks if a transaction is still valid (not revoked, not expired for subscriptions).
    /// - Parameter transaction: The transaction to validate
    /// - Returns: `true` if the transaction is valid and active
    func isTransactionValid(_ transaction: Transaction) -> Bool {
        // Check if transaction was revoked
        if transaction.revocationDate != nil {
            Logger.purchases.warning("Transaction has been revoked for product: \(transaction.productID)")
            return false
        }
        
        // For subscriptions, check if expired
        if let expirationDate = transaction.expirationDate,
           expirationDate < Date() {
            Logger.purchases.info("Subscription has expired for product: \(transaction.productID)")
            return false
        }
        
        return true
    }
}
