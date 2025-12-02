# 🔑 App Store Connect - Resumen de Credenciales

**Última actualización**: 2 de diciembre de 2025, 05:46 UTC

---

## 📋 Credenciales Completas

### 1. App Store Connect API Key

```
Key ID:     Y7F67CN793
Issuer ID:  c4fe5a62-60af-43b1-af9b-369dad9f52a0
Uso:        Autenticación con App Store Server API
```

**⚠️ Clave privada .p8**: 
- Archivo: `AuthKey_Y7F67CN793.p8`
- **NO incluir en el repositorio**
- Guardar en lugar seguro (1Password, LastPass, etc.)

### 2. In-App Purchase Key (Anterior)

```
Key ID:     32U569DVAD
Issuer ID:  c4fe5a62-60af-43b1-af9b-369dad9f52a0
Estado:     Puede ser revocada si no la usas
```

### 3. Shared Secret (Suscripciones)

```
Shared Secret:  15afc8166469465fb4c2216ff81c28e8
Uso:            Validación de recibos de auto-renewable subscriptions
API:            verifyReceipt endpoint
```

---

## 📁 Ubicación en el Proyecto

```
Anstop/Core/Secrets/
├── AppStoreSecrets.swift          # ✅ Actualizado con todas las credenciales
├── ReceiptValidator.swift         # ✅ Usa el shared secret
└── README.md                      # ✅ Documentación de seguridad

Raíz del Proyecto/
├── APPSTORE_CONNECT_SETUP.md      # Guía de configuración completa
├── WEBHOOKS_GUIDE.md              # Guía de webhooks (NUEVO)
└── .gitignore                     # ✅ Protege credenciales
```

---

## 🎯 Estado Actual de Configuración

### ✅ Completado

- [x] Credenciales almacenadas en `AppStoreSecrets.swift`
- [x] Shared secret integrado
- [x] API Key configurada
- [x] Validador de recibos implementado
- [x] `.gitignore` actualizado
- [x] Documentación completa

### ❓ Pendiente (Solo Cuando Necesites)

- [ ] Configurar webhooks en App Store Connect → **NO necesario ahora**
- [ ] Crear endpoint backend para webhooks → **Solo para producción**
- [ ] Subir app a TestFlight → **Cuando termines desarrollo**
- [ ] Configurar productos in-app reales → **Después de crear app en ASC**

---

## 🚀 Uso en el Código

### Acceso a Credenciales

```swift
import Foundation

// API Key
let apiKey = AppStoreSecrets.keyID           // "Y7F67CN793"
let issuerID = AppStoreSecrets.issuerID      // "c4fe5a62-60af-43b1-af9b-369dad9f52a0"

// Shared Secret
let secret = AppStoreSecrets.sharedSecret    // "15afc8166469465fb4c2216ff81c28e8"

// Entorno
let env = AppStoreSecrets.environment        // .sandbox o .production
```

### Validación de Transacciones

```swift
// StoreKit 2 - Validación automática
for await result in Transaction.updates {
    switch result {
    case .verified(let transaction):
        // Transacción válida
        await unlockPremiumFeatures()
        await transaction.finish()
        
    case .unverified(_, let error):
        // Error de validación
        print("Transacción no válida: \(error)")
    }
}

// Validación adicional con servidor (opcional)
let validator = ReceiptValidator.shared
let isValid = try await validator.validateReceipt(for: transaction)
```

### Validación de Recibos con Shared Secret

```swift
// Usar shared secret en validación manual
let receiptData = // ... obtener del bundle
let response = try await validator.validateReceiptWithServer(receiptData: receiptData)

if response.isValid {
    // Recibo válido
    print("Suscripción activa")
}
```

---

## 🔐 Seguridad

### ✅ Protecciones Implementadas

1. **Git Protection**
   ```
   .gitignore incluye:
   - Secrets.swift
   - *.p8
   - **/Secrets/
   ```

2. **Archivo Separado**
   - Credenciales en `AppStoreSecrets.swift`
   - NO en código fuente principal
   - Comentarios de advertencia

3. **Documentación**
   - Mejores prácticas documentadas
   - Warnings en todos los archivos
   - README de seguridad

### ⚠️ Recordatorios Críticos

❌ **NUNCA**:
- Subir credenciales a Git público
- Compartir en emails o chats
- Incluir en screenshots
- Hard-codear en otros archivos

✅ **SIEMPRE**:
- Usar variables de entorno en CI/CD
- Rotar claves periódicamente
- Monitorear uso sospechoso
- Validar en backend cuando sea posible

---

## 🔄 Webhooks - ¿Los Necesitas?

### ❌ NO AHORA (Desarrollo Local)

Mientras uses `Configuration.storekit`:
- Los webhooks **no funcionarán**
- Todo se simula localmente
- No necesitas configurar nada

### ✅ SÍ DESPUÉS (TestFlight/Producción)

Cuando tengas la app en TestFlight:
1. Crear endpoint backend
2. Configurar URL en App Store Connect
3. Activar notificaciones V2

**📖 Lee `WEBHOOKS_GUIDE.md` para detalles completos**

---

## 📊 Timeline Sugerido

### Diciembre 2025 (HOY)
```
✅ Credenciales configuradas
✅ Development con Configuration.storekit
✅ Implementar features
```

### Enero 2026
```
→ Finalizar desarrollo
→ Testing exhaustivo local
→ Preparar assets para App Store
```

### Febrero 2026
```
→ Crear app en App Store Connect
→ Configurar productos in-app reales
→ Subir primera build a TestFlight
→ (Opcional) Configurar webhooks
```

### Marzo 2026
```
→ Beta testing
→ Ajustes finales
→ Enviar a revisión de Apple
→ Lanzamiento 🚀
```

---

## 📚 Documentación Disponible

1. **APPSTORE_CONNECT_SETUP.md**
   - Configuración completa de credenciales
   - Ejemplos de código
   - Referencias de APIs

2. **WEBHOOKS_GUIDE.md** (NUEVO)
   - Todo sobre webhooks
   - Cuándo configurarlos
   - Ejemplos de implementación

3. **Anstop/Core/Secrets/README.md**
   - Seguridad de credenciales
   - Mejores prácticas
   - Uso básico

---

## 🆘 FAQ

### ¿Puedo usar estas credenciales ahora?

✅ Sí, en tu código Swift para acceder a las APIs de Apple cuando las necesites.

### ¿Necesito configurar webhooks ya?

❌ No, solo cuando subas a TestFlight o producción.

### ¿Qué hago con el archivo .p8?

🔐 Guárdalo en lugar seguro (password manager) y **NUNCA** lo subas a Git.

### ¿Cuándo uso el shared secret?

📝 Se usa automáticamente en `ReceiptValidator` para validar suscripciones.

### ¿Las credenciales están seguras?

✅ Sí, están en archivo protegido por `.gitignore` y con documentación de seguridad.

---

## 🎉 ¡Todo Listo!

Tu proyecto tiene todas las credenciales necesarias configuradas de forma segura.

**Próximo paso**: Continuar desarrollando con `Configuration.storekit` y preocuparte de webhooks más adelante cuando realmente los necesites.

---

**Mantenido por**: Tu equipo de desarrollo  
**Contacto de emergencia**: Tu email  
**Backup de credenciales**: Tu password manager
