//
//  StoreKitUsageExample.swift
//  Anstop
//
//  Created on 2025-12-02.
//  EJEMPLO: Cómo usar ReceiptValidator con StoreKit 2
//

import Foundation
import StoreKit

// MARK: - Ejemplo de Uso Correcto con StoreKit 2

/// Este archivo muestra cómo usar ReceiptValidator correctamente
/// NO es código de producción, solo ejemplos de referencia

class StoreKitUsageExamples {
    let validator = ReceiptValidator.shared

    // MARK: - Ejemplo 1: Validar transacción al comprar

    func purchaseProduct(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(verificationResult):
            // Validar la transacción
            let transaction = try validator.validateTransaction(verificationResult)

            // Verificar que esté activa
            guard validator.isTransactionValid(transaction) else {
                throw ReceiptError.transactionRevoked
            }

            // Desbloquear contenido premium
            await unlockPremiumFeatures()

            // IMPORTANTE: Marcar como completada
            await transaction.finish()

        case .userCancelled:
            print("Usuario canceló la compra")

        case .pending:
            print("Compra pendiente (requiere aprobación)")

        @unknown default:
            print("Estado desconocido")
        }
    }

    // MARK: - Ejemplo 2: Escuchar actualizaciones de transacciones

    func listenForTransactionUpdates() {
        Task {
            for await verificationResult in Transaction.updates {
                do {
                    let transaction = try validator.validateTransaction(verificationResult)

                    // Procesar según el tipo
                    switch transaction.productType {
                    case .autoRenewable:
                        await handleSubscription(transaction)
                    case .nonRenewable:
                        await handleNonRenewable(transaction)
                    case .nonConsumable:
                        await handleNonConsumable(transaction)
                    case .consumable:
                        await handleConsumable(transaction)
                    default:
                        print("Tipo de producto desconocido")
                    }

                    await transaction.finish()

                } catch {
                    print("Error validando transacción: \(error)")
                }
            }
        }
    }

    // MARK: - Ejemplo 3: Verificar suscripciones activas

    func checkActiveSubscriptions() async throws -> Bool {
        // Obtener todas las transacciones actuales
        for await verificationResult in Transaction.currentEntitlements {
            do {
                let transaction = try validator.validateTransaction(verificationResult)

                // Verificar si es válida
                if validator.isTransactionValid(transaction) {
                    return true
                }
            } catch {
                continue
            }
        }

        return false
    }

    // MARK: - Ejemplo 4: Obtener historial de compras

    func loadPurchaseHistory() async throws -> [Transaction] {
        var validTransactions: [Transaction] = []

        for await verificationResult in Transaction.all {
            do {
                let transaction = try validator.validateTransaction(verificationResult)
                validTransactions.append(transaction)
            } catch {
                print("Transacción inválida ignorada: \(error)")
            }
        }

        return validTransactions
    }

    // MARK: - Ejemplo 5: Restaurar compras

    func restorePurchases() async throws {
        // StoreKit 2 sincroniza automáticamente
        try await AppStore.sync()

        // Verificar transacciones actuales
        let hasPremium = try await checkActiveSubscriptions()

        if hasPremium {
            await unlockPremiumFeatures()
        }
    }

    // MARK: - Helper Methods (Ejemplo)

    private func handleSubscription(_ transaction: Transaction) async {
        print("Procesando suscripción: \(transaction.productID)")

        if validator.isTransactionValid(transaction) {
            await unlockPremiumFeatures()
        } else {
            await lockPremiumFeatures()
        }
    }

    private func handleNonRenewable(_ transaction: Transaction) async {
        print("Procesando no-renovable: \(transaction.productID)")
    }

    private func handleNonConsumable(_ transaction: Transaction) async {
        print("Procesando no-consumible: \(transaction.productID)")
    }

    private func handleConsumable(_ transaction: Transaction) async {
        print("Procesando consumible: \(transaction.productID)")
    }

    private func unlockPremiumFeatures() async {
        // Tu lógica para desbloquear premium
        print("✅ Premium desbloqueado")
    }

    private func lockPremiumFeatures() async {
        // Tu lógica para bloquear premium
        print("🔒 Premium bloqueado")
    }
}

// MARK: - Uso en PurchaseManager

extension StoreKitUsageExamples {
    /// Ejemplo de cómo integrar en tu PurchaseManager existente
    func integrateWithPurchaseManager() {}
}
