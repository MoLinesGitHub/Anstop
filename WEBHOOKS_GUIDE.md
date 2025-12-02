# 🔔 App Store Server Notifications - Guía de Webhooks

## ¿Necesitas configurar webhooks AHORA?

### ❌ NO - Para Desarrollo Local

Si estás en fase de desarrollo y usando `Configuration.storekit`:
- **NO necesitas webhooks todavía**
- Los webhooks solo funcionan con productos reales en App Store Connect
- Configuration.storekit simula todo localmente

### ✅ SÍ - Para Producción/TestFlight

Los webhooks son **necesarios cuando**:
- Tienes la app en TestFlight
- Tienes suscripciones auto-renovables en producción
- Necesitas sincronizar estados de suscripción en tiempo real
- Quieres recibir notificaciones de cambios de estado

---

## 📊 ¿Qué son los App Store Server Notifications?

Son notificaciones que Apple envía a tu servidor cuando:
- Un usuario **compra** una suscripción
- Una suscripción se **renueva** automáticamente
- Un usuario **cancela** una suscripción
- Una suscripción **expira**
- Se emite un **reembolso**
- Cambia el **estado de renovación automática**
- Un usuario **actualiza o degrada** su plan

**Versión actual recomendada**: V2 (más detallada y segura)

---

## 🎯 TIMELINE: Cuándo Configurar Webhooks

### Fase 1: Desarrollo (AHORA) ✅
```
[ Usar Configuration.storekit ]
→ No necesitas webhooks
→ Todo se simula localmente
→ Enfócate en implementar la UI/UX
```

### Fase 2: Pre-TestFlight (1-2 semanas antes)
```
[ Preparar Backend ]
→ Crear endpoint para recibir webhooks
→ Implementar validación de notificaciones
→ Probar con datos de ejemplo
```

### Fase 3: TestFlight (Cuando subas a testing)
```
[ Configurar en App Store Connect ]
→ Agregar URL de tu servidor
→ Activar notificaciones V2
→ Probar con usuarios beta
```

### Fase 4: Producción
```
[ Monitoreo en vivo ]
→ Logs de webhooks
→ Alertas de fallos
→ Métricas de suscripciones
```

---

## 🛠️ Cómo Configurar Webhooks (Cuando Sea Necesario)

### Prerequisitos

1. ✅ **Backend/Servidor funcionando**
   - Necesitas un servidor que pueda recibir requests POST
   - URL pública accesible (HTTPS obligatorio)
   - Ejemplos: AWS Lambda, Google Cloud Functions, Heroku, etc.

2. ✅ **App en App Store Connect**
   - La app debe estar creada
   - Productos in-app configurados
   - Acuerdos completados

3. ✅ **Endpoint implementado**
   - Capaz de recibir JSON POST
   - Validación de la firma de Apple
   - Procesamiento de notificaciones

### Pasos en App Store Connect

1. **Ir a App Store Connect**
   ```
   https://appstoreconnect.apple.com
   ```

2. **Navegar a tu App**
   ```
   My Apps → Anstop → App Store → App Information
   ```

3. **Scroll hasta "App Store Server Notifications"**
   ```
   Encontrarás la sección al final de la página
   ```

4. **Configurar URL del Webhook**
   ```
   Production Server URL:     https://tu-servidor.com/webhooks/appstore
   Sandbox Server URL:        https://tu-servidor.com/webhooks/appstore-sandbox
   ```

5. **Seleccionar Versión**
   ```
   ✅ Version 2 (Recomendado)
   ❌ Version 1 (Deprecated)
   ```

6. **Guardar Cambios**
   ```
   Click en "Save"
   ```

---

## 📝 Estructura de tu Endpoint

### Ejemplo de Endpoint (Backend)

```python
# Ejemplo en Python/Flask
from flask import Flask, request, jsonify
import jwt
from cryptography.hazmat.primitives import serialization
import json

app = Flask(__name__)

@app.route('/webhooks/appstore', methods=['POST'])
def handle_appstore_webhook():
    # 1. Obtener el payload
    data = request.get_json()
    
    # 2. Verificar la firma JWT de Apple
    signed_payload = data.get('signedPayload')
    if not verify_apple_signature(signed_payload):
        return jsonify({'error': 'Invalid signature'}), 403
    
    # 3. Decodificar el payload
    decoded = jwt.decode(signed_payload, options={"verify_signature": False})
    
    # 4. Procesar según el tipo de notificación
    notification_type = decoded['notificationType']
    
    if notification_type == 'SUBSCRIBED':
        handle_new_subscription(decoded)
    elif notification_type == 'DID_RENEW':
        handle_renewal(decoded)
    elif notification_type == 'EXPIRED':
        handle_expiration(decoded)
    elif notification_type == 'REFUND':
        handle_refund(decoded)
    # ... más tipos
    
    return jsonify({'status': 'received'}), 200

def verify_apple_signature(signed_payload):
    # Verificar con certificados de Apple
    # Implementación completa en documentación
    pass

def handle_new_subscription(data):
    # Tu lógica para nuevas suscripciones
    user_id = data['transactionInfo']['originalTransactionId']
    # Actualizar base de datos, desbloquear features, etc.
    pass
```

### Tipos de Notificaciones V2

```swift
// Eventos que recibirás
enum NotificationType: String {
    case subscribed = "SUBSCRIBED"
    case didRenew = "DID_RENEW"
    case didFailToRenew = "DID_FAIL_TO_RENEW"
    case didChangeRenewalStatus = "DID_CHANGE_RENEWAL_STATUS"
    case expired = "EXPIRED"
    case gracePeriodExpired = "GRACE_PERIOD_EXPIRED"
    case offerRedeemed = "OFFER_REDEEMED"
    case priceIncrease = "PRICE_INCREASE"
    case refund = "REFUND"
    case refundDeclined = "REFUND_DECLINED"
    case renewalExtended = "RENEWAL_EXTENDED"
    case revoke = "REVOKE"
    case test = "TEST"
}
```

---

## 🔐 Validación de Webhooks

### Verificar que el Webhook viene de Apple

Apple firma cada notificación con JWT. Debes verificar:

1. **Descargar certificados root de Apple**
   ```bash
   curl -O https://www.apple.com/certificateauthority/AppleRootCA-G3.cer
   ```

2. **Verificar la firma del JWT**
   ```python
   import jwt
   from cryptography.x509 import load_der_x509_certificate
   
   def verify_notification(signed_payload):
       # Extraer header
       header = jwt.get_unverified_header(signed_payload)
       
       # Obtener certificados de Apple
       x5c = header['x5c']
       
       # Verificar cadena de certificados
       # Decodificar payload si es válido
       decoded = jwt.decode(
           signed_payload,
           key=public_key,
           algorithms=['ES256']
       )
       
       return decoded
   ```

---

## 🧪 Testing de Webhooks

### Opción 1: Test en App Store Connect

```
1. App Store Connect → Tu App → App Information
2. Scroll a "App Store Server Notifications"
3. Click en "Send Test Notification"
4. Selecciona tipo de evento
5. Verifica que tu servidor lo recibe
```

### Opción 2: ngrok para Testing Local

```bash
# 1. Instalar ngrok
brew install ngrok

# 2. Exponer tu servidor local
ngrok http 3000

# 3. Usar la URL de ngrok en App Store Connect
https://abc123.ngrok.io/webhooks/appstore

# 4. Ver logs en tiempo real
ngrok http 3000 --log=stdout
```

### Opción 3: Webhooks de Prueba

Apple envía notificaciones de prueba con este formato:

```json
{
  "notificationType": "TEST",
  "subtype": null,
  "notificationUUID": "test-notification-uuid",
  "data": {
    "environment": "Sandbox",
    "bundleId": "com.molinesdesigns.Anstop"
  }
}
```

---

## 🎯 Tu Implementación Específica

### Para Anstop

```swift
// En tu backend, procesar estos eventos:

1. SUBSCRIBED
   → Usuario compra premium
   → Actualizar base de datos
   → Desbloquear features premium
   → Enviar email de bienvenida

2. DID_RENEW
   → Suscripción renovada exitosamente
   → Extender acceso premium
   → Registrar renovación

3. EXPIRED
   → Suscripción expiró
   → Revertir a plan gratuito
   → Mostrar prompt de renovación

4. REFUND
   → Usuario recibió reembolso
   → Revocar acceso premium
   → Registrar incidente
```

### Endpoint Recomendado

```
Producción:  https://api.anstop.com/webhooks/appstore
Sandbox:     https://api-sandbox.anstop.com/webhooks/appstore
```

---

## 📊 Monitoreo y Logs

### Qué Registrar

```javascript
// En tu base de datos
{
  "webhook_id": "uuid",
  "timestamp": "2025-12-02T05:45:00Z",
  "notification_type": "SUBSCRIBED",
  "transaction_id": "original_transaction_id",
  "user_id": "user_identifier",
  "product_id": "premium.yearly",
  "environment": "Production",
  "processed": true,
  "processing_time_ms": 45
}
```

### Métricas Importantes

- ✅ Webhooks recibidos vs esperados
- ⚠️ Webhooks fallidos
- 📊 Tiempo de procesamiento
- 🔄 Reintentos necesarios
- ❌ Errores de validación

---

## ⚠️ Consideraciones Importantes

### Idempotencia

Apple puede enviar el mismo webhook múltiples veces:

```python
def handle_webhook(data):
    notification_uuid = data['notificationUUID']
    
    # Verificar si ya procesamos este webhook
    if already_processed(notification_uuid):
        return {'status': 'already_processed'}, 200
    
    # Procesar webhook
    process_notification(data)
    
    # Marcar como procesado
    mark_as_processed(notification_uuid)
    
    return {'status': 'success'}, 200
```

### Timeouts

- Responder en **< 5 segundos**
- Procesar de forma asíncrona si es necesario
- Retornar 200 OK rápidamente

### Seguridad

- ✅ Validar TODAS las firmas
- ✅ Usar HTTPS obligatoriamente
- ✅ Verificar certificados de Apple
- ✅ Rate limiting en tu endpoint
- ✅ Logs detallados de seguridad

---

## 🚀 RESUMEN: ¿Qué Hacer Ahora?

### Para TU caso (Desarrollo):

```
AHORA (Diciembre 2025):
❌ NO configurar webhooks todavía
✅ Usar Configuration.storekit
✅ Desarrollar features
✅ Testing local

PRÓXIMO MES (Enero 2026):
✅ Crear backend/endpoint
✅ Implementar validación de webhooks
✅ Testing con ngrok

ANTES DE TESTFLIGHT (Febrero 2026):
✅ Configurar webhooks en App Store Connect
✅ Probar con usuarios beta
✅ Monitoreo activo

PRODUCCIÓN (Marzo 2026):
✅ Webhooks en producción
✅ Monitoring 24/7
✅ Alertas configuradas
```

---

## 📚 Referencias

- [App Store Server Notifications V2](https://developer.apple.com/documentation/appstoreservernotifications)
- [Responding to App Store Server Notifications](https://developer.apple.com/documentation/appstoreservernotifications/responding_to_app_store_server_notifications)
- [Testing Server Notifications](https://developer.apple.com/documentation/appstoreservernotifications/testing_server_notifications_for_in-app_purchases)

---

**Última actualización**: 2 de diciembre de 2025  
**Tu situación**: Desarrollo local - Webhooks NO necesarios todavía
