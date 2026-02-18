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
    private static func readValue(for key: String) -> String {
        if let envValue = ProcessInfo.processInfo.environment[key], !envValue.isEmpty {
            return envValue
        }

        if let plistValue = Bundle.main.object(forInfoDictionaryKey: key) as? String, !plistValue.isEmpty {
            return plistValue
        }

        return ""
    }

    /// App Store Connect API - Key ID
    /// Usado para autenticar solicitudes al servidor de App Store
    static var keyID: String {
        readValue(for: "APPSTORE_KEY_ID")
    }

    /// App Store Connect API - Issuer ID
    /// Identifica tu organización en App Store Connect
    static var issuerID: String {
        readValue(for: "APPSTORE_ISSUER_ID")
    }

    /// Shared Secret para validación de recibos de suscripciones
    /// Usado en verifyReceipt API para validar auto-renewable subscriptions
    static var sharedSecret: String {
        readValue(for: "APPSTORE_SHARED_SECRET")
    }

    /// Path relativo a la clave privada .p8 (si la tienes)
    /// La clave .p8 NUNCA debe incluirse en el repositorio
    static var privateKeyFileName: String {
        readValue(for: "APPSTORE_PRIVATE_KEY_FILENAME")
    }

    static var isConfigured: Bool {
        !keyID.isEmpty && !issuerID.isEmpty && !sharedSecret.isEmpty
    }

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
                "https://sandbox.itunes.apple.com/verifyReceipt"
            case .production:
                "https://buy.itunes.apple.com/verifyReceipt"
            }
        }

        var serverNotificationURL: String {
            switch self {
            case .sandbox:
                "https://api.storekit-sandbox.itunes.apple.com"
            case .production:
                "https://api.storekit.itunes.apple.com"
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
