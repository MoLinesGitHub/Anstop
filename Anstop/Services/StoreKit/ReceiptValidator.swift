//
//  ReceiptValidator.swift
//  Anstop
//
//  Created on 2025-12-02.
//

import Foundation
import StoreKit

/// Validador de recibos de compras in-app con el servidor de Apple
/// Usa las credenciales de AppStoreSecrets para autenticación
@MainActor
final class ReceiptValidator {
    static let shared = ReceiptValidator()

    private init() {}

    // MARK: - Validación de Recibos

    /// Valida una transacción verificada de StoreKit 2
    /// - Parameter verificationResult: Resultado de verificación de Transaction
    /// - Returns: true si la transacción es válida
    func validateTransaction(_ verificationResult: VerificationResult<Transaction>) throws -> Transaction {
        // StoreKit 2 valida automáticamente las transacciones
        // Esta función verifica el resultado y extrae la transacción

        switch verificationResult {
        case let .verified(transaction):
            // Transacción verificada por Apple
            return transaction

        case let .unverified(_, error):
            // Transacción no verificada - posible fraude
            throw ReceiptError.verificationFailed(error)
        }
    }

    /// Valida si una transacción es válida y no ha sido revocada
    /// - Parameter transaction: Transacción ya verificada
    /// - Returns: true si está activa
    func isTransactionValid(_ transaction: Transaction) -> Bool {
        // Verificar que no haya sido revocada
        guard transaction.revocationDate == nil else {
            return false
        }

        // Para suscripciones, verificar fecha de expiración
        if let expirationDate = transaction.expirationDate {
            return expirationDate > Date()
        }

        // Para compras únicas, siempre válidas si no están revocadas
        return true
    }

    // MARK: - Validación Server-to-Server (Opcional)

    /// Valida el recibo con el servidor de Apple usando las credenciales de API
    /// ⚠️ Esta validación debería hacerse en tu backend para mayor seguridad
    /// Esta implementación es solo para referencia/desarrollo
    func validateReceiptWithServer(receiptData: Data) async throws -> ReceiptValidationResponse {
        let environment = AppStoreSecrets.environment
        let url = URL(string: environment.verificationURL)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "receipt-data": receiptData.base64EncodedString(),
            "password": AppStoreSecrets.sharedSecret,
            "exclude-old-transactions": true,
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw ReceiptError.invalidResponse
        }

        return try JSONDecoder().decode(ReceiptValidationResponse.self, from: data)
    }

    // MARK: - JWT Token Generation (Para App Store Server API)

    /// Genera un JWT token para autenticación con App Store Server API
    /// ⚠️ Requiere la clave privada .p8 - NO implementado aquí por seguridad
    /// Esta funcionalidad debería estar en tu backend
    func generateJWTToken() -> String? {
        // Esta función requiere la clave privada .p8
        // Por seguridad, esto debería hacerse en un servidor backend
        // NO en la app del cliente

        // Placeholder - implementar en backend
        nil
    }
}

// MARK: - Models

struct ReceiptValidationResponse: Codable {
    let status: Int
    let receipt: Receipt?
    let latestReceiptInfo: [ReceiptInfo]?
    let pendingRenewalInfo: [RenewalInfo]?

    enum CodingKeys: String, CodingKey {
        case status
        case receipt
        case latestReceiptInfo = "latest_receipt_info"
        case pendingRenewalInfo = "pending_renewal_info"
    }

    var isValid: Bool {
        status == 0
    }
}

struct Receipt: Codable {
    let bundleId: String
    let applicationVersion: String
    let inApp: [ReceiptInfo]

    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case applicationVersion = "application_version"
        case inApp = "in_app"
    }
}

struct ReceiptInfo: Codable {
    let productId: String
    let transactionId: String
    let purchaseDate: String
    let expiresDate: String?

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case transactionId = "transaction_id"
        case purchaseDate = "purchase_date"
        case expiresDate = "expires_date"
    }
}

struct RenewalInfo: Codable {
    let productId: String
    let autoRenewStatus: String

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case autoRenewStatus = "auto_renew_status"
    }
}

// MARK: - Errors

enum ReceiptError: LocalizedError {
    case verificationFailed(VerificationResult<Transaction>.VerificationError)
    case invalidResponse
    case networkError
    case invalidReceipt
    case transactionRevoked
    case subscriptionExpired

    var errorDescription: String? {
        switch self {
        case let .verificationFailed(error):
            "Verificación fallida: \(error.localizedDescription)"
        case .invalidResponse:
            "Respuesta inválida del servidor"
        case .networkError:
            "Error de red"
        case .invalidReceipt:
            "Recibo inválido"
        case .transactionRevoked:
            "Transacción revocada"
        case .subscriptionExpired:
            "Suscripción expirada"
        }
    }
}
