# 🔐 App Store Connect - Guía de Configuración

## Credenciales Configuradas

### ✅ In-App Purchase Key

- **Key ID**: `32U569DVAD`
- **Issuer ID**: `c4fe5a62-60af-43b1-af9b-369dad9f52a0`
- **Fecha de creación**: 2 de diciembre de 2025
- **Propósito**: Autenticación y validación de compras in-app

### 📁 Ubicación en el Proyecto

```
Anstop/Core/Secrets/
├── AppStoreSecrets.swift     # Credenciales (protegido por .gitignore)
├── ReceiptValidator.swift    # Validador de recibos
└── README.md                 # Documentación de seguridad
```

---

## 🚀 Cómo Usar las Credenciales

### 1. Acceso Básico

```swift
import Foundation

// Obtener las credenciales
let keyID = AppStoreSecrets.keyID         // "32U569DVAD"
let issuerID = AppStoreSecrets.issuerID   // "c4fe5a62-60af-43b1-af9b-369dad9f52a0"
let environment = AppStoreSecrets.environment  // .sandbox o .production
```

### 2. Validación de Transacciones (StoreKit 2)

```swift
// En tu PurchaseManager o similar
func validatePurchase(_ transaction: Transaction) async throws -> Bool {
    let validator = ReceiptValidator.shared
    return try await validator.validateReceipt(for: transaction)
}
```

### 3. URLs de Validación

```swift
// URL de verificación según el entorno
let verificationURL = AppStoreSecrets.environment.verificationURL

// Sandbox: https://sandbox.itunes.apple.com/verifyReceipt
// Production: https://buy.itunes.apple.com/verifyReceipt
```

---

## 🛡️ Seguridad

### ✅ Configuración Actual

- [x] Credenciales almacenadas en archivo separado
- [x] `.gitignore` configurado para excluir secrets
- [x] Documentación de mejores prácticas
- [x] Separación de entornos (Debug/Release)

### ⚠️ IMPORTANTE - NO HACER

❌ **NUNCA** subir credenciales a repositorios públicos  
❌ **NUNCA** compartir el Key ID o Issuer ID en público  
❌ **NUNCA** incluir la clave privada .p8 en el app bundle  
❌ **NUNCA** hacer validación sensible solo en el cliente

### ✅ Mejores Prácticas

✓ Usar **StoreKit 2** que valida automáticamente  
✓ Implementar **validación server-side** para mayor seguridad  
✓ Rotar claves periódicamente en App Store Connect  
✓ Monitorear transacciones sospechosas  
✓ Usar **App Store Server Notifications V2**

---

## 🔄 Validación de Compras

### Opción 1: StoreKit 2 (Recomendado)

StoreKit 2 valida automáticamente las transacciones con Apple:

```swift
for await result in Transaction.updates {
    switch result {
    case .verified(let transaction):
        // Transacción válida y verificada por Apple
        await transaction.finish()
        
    case .unverified(_, let error):
        // Transacción no válida
        print("Error de verificación: \(error)")
    }
}
```

### Opción 2: Validación Manual (Opcional)

Para validación adicional (generalmente en servidor):

```swift
let validator = ReceiptValidator.shared
let isValid = try await validator.validateReceiptWithServer(receiptData: data)
```

⚠️ **Nota**: La validación con servidor debería hacerse en tu **backend**, no en la app del cliente.

---

## 📊 App Store Server API

### Endpoints Disponibles

Con tus credenciales puedes acceder a:

1. **Get Transaction History**
   - `GET /inApps/v1/history/{originalTransactionId}`

2. **Get All Subscription Statuses**
   - `GET /inApps/v1/subscriptions/{originalTransactionId}`

3. **Look Up Order ID**
   - `GET /inApps/v1/lookup/{orderId}`

4. **Get Refund History**
   - `GET /inApps/v2/refund/lookup/{originalTransactionId}`

### Autenticación JWT

Para usar la API, necesitas generar un JWT token:

```
Header:
{
  "alg": "ES256",
  "kid": "32U569DVAD",
  "typ": "JWT"
}

Payload:
{
  "iss": "c4fe5a62-60af-43b1-af9b-369dad9f52a0",
  "iat": <timestamp>,
  "exp": <timestamp + 60 minutes>,
  "aud": "appstoreconnect-v1",
  "bid": "com.molinesdesigns.Anstop"
}
```

⚠️ **Esto debe hacerse en tu servidor backend**, no en la app.

---

## 🔧 Configuración en App Store Connect

### Pasos Completados

1. ✅ Cuenta de App Store Connect creada
2. ✅ In-App Purchase Key generada
3. ✅ Key ID y Issuer ID obtenidos

### Próximos Pasos (Antes de TestFlight)

1. **Crear App en App Store Connect**
   - Bundle ID: `com.molinesdesigns.Anstop`
   - Nombre: Anstop
   - Idiomas: Español, Inglés

2. **Configurar Productos In-App**
   - Tipo: Auto-Renewable Subscription
   - Product IDs según tu Configuration.storekit
   - Precios por región

3. **Configurar Server Notifications V2**
   - URL de tu servidor para recibir notificaciones
   - Webhooks de cambios de estado de suscripción

4. **Acuerdos Fiscales**
   - Completar información bancaria
   - Aceptar acuerdos requeridos

5. **Usuarios Sandbox**
   - Crear cuentas de prueba
   - Probar flujos de compra

---

## 🧪 Testing

### Durante Desarrollo

```swift
// Usar Configuration.storekit para testing offline
// Configurado en: Edit Scheme → Run → Options → StoreKit Configuration
```

### Sandbox Testing

```swift
// Cuando tengas productos en App Store Connect
#if DEBUG
let environment = AppStoreSecrets.Environment.sandbox
#endif
```

### Production

```swift
// Solo después de aprobar revisión de Apple
#if !DEBUG
let environment = AppStoreSecrets.Environment.production
#endif
```

---

## 📚 Referencias

- [App Store Server API Documentation](https://developer.apple.com/documentation/appstoreserverapi)
- [StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)
- [In-App Purchase Best Practices](https://developer.apple.com/in-app-purchase/)
- [Receipt Validation Guide](https://developer.apple.com/documentation/appstorereceipts)

---

## 🆘 Soporte

Si necesitas regenerar las claves:

1. Ve a [App Store Connect](https://appstoreconnect.apple.com)
2. **Users and Access** → **Keys** → **In-App Purchase**
3. Click en **Generate New Key**
4. Descarga el archivo .p8
5. Actualiza `AppStoreSecrets.swift`

⚠️ La clave anterior quedará revocada.

---

**Última actualización**: 2 de diciembre de 2025  
**Versión del proyecto**: 1.0.0
