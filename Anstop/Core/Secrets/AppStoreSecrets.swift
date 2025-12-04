//
//  AppStoreSecrets.swift
//  Anstop
//
//  Created on 2025-12-02.
//  ⚠️ IMPORTANTE: Este archivo NO debe subirse a Git
//

import Foundation

/// Credenciales de App Store Connect para validación de compras
/// ⚠️ NO compartir estas claves públicamente
enum AppStoreSecrets {
    /// App Store Connect API - Key ID
    /// Usado para autenticar solicitudes al servidor de App Store
    static let keyID = "Y7F67CN793"

    /// App Store Connect API - Issuer ID
    /// Identifica tu organización en App Store Connect
    static let issuerID = "c4fe5a62-60af-43b1-af9b-369dad9f52a0"

    /// Shared Secret para validación de recibos de suscripciones
    /// Usado en verifyReceipt API para validar auto-renewable subscriptions
    static let sharedSecret = "15afc8166469465fb4c2216ff81c28e8"

    /// Path relativo a la clave privada .p8 (si la tienes)
    /// La clave .p8 NUNCA debe incluirse en el repositorio
    static let privateKeyFileName = "SubscriptionKey_32U569DVAD.p8"

    // MARK: - Configuración de entorno

    #if DEBUG
    static let environment: Environment = .sandbox
    #else
    static let environment: Environment = .production
    #endif

    enum Environment {
        case sandbox
        case production

        var verificationURL: String {
            switch self {
            case .sandbox:
                return "https://sandbox.itunes.apple.com/verifyReceipt"
            case .production:
                return "https://buy.itunes.apple.com/verifyReceipt"
            }
        }

        var serverNotificationURL: String {
            switch self {
            case .sandbox:
                return "https://api.storekit-sandbox.itunes.apple.com"
            case .production:
                return "https://api.storekit.itunes.apple.com"
            }
        }
    }
}

// MARK: - Helper Extensions

extension AppStoreSecrets {
    /// Lee la clave privada .p8 desde el bundle
    /// ⚠️ Solo usar si tienes el archivo .p8 en el proyecto
    static func loadPrivateKey() -> String? {
        guard let path = Bundle.main.path(forResource: privateKeyFileName.replacingOccurrences(of: ".p8", with: ""), ofType: "p8") else {
            return nil
        }

        return try? String(contentsOfFile: path, encoding: .utf8)
    }
}
