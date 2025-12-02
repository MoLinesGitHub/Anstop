# 🛒 Configurar StoreKit en Xcode - Guía Paso a Paso

**Fecha**: 2 de diciembre de 2025  
**Proyecto**: Anstop  
**Objetivo**: Probar compras in-app sin error 404

---

## 🎯 ¿Por qué necesitas esto?

Actualmente ves este error al probar compras:

```
Error enumerating all current transactions: 
Error Domain=ASDErrorDomain Code=500
errorCode = 4040004;
errorMessage = "No se ha encontrado la app. Vuelve a intentarlo.";
```

**Causa**: StoreKit no sabe qué productos usar en desarrollo.

**Solución**: Configurar el archivo `Configuration.storekit` en el scheme.

---

## 📋 PREREQUISITOS

✅ Ya tienes todo listo:
- ✓ Archivo `Configuration.storekit` existe en tu proyecto
- ✓ Productos configurados (premium.monthly, premium.yearly)
- ✓ PurchaseManager implementado

Solo falta **activar** la configuración en Xcode.

---

## 🔧 PASOS PARA CONFIGURAR

### Paso 1: Abrir Scheme Editor

**Opción A - Desde la barra superior:**

```
1. Click en el nombre del scheme (junto al botón Play)
   [Anstop ▼] [iPhone Simulator ▼]
    ^^^^^^
    Click aquí

2. En el menú desplegable, selecciona:
   "Edit Scheme..."
```

**Opción B - Atajo de teclado:**

```
⌘ + <    (Command + Menor que)
```

**Opción C - Desde el menú:**

```
Product → Scheme → Edit Scheme...
```

---

### Paso 2: Navegar a la Sección Run

En la ventana del Scheme Editor:

```
┌─────────────────────────────────────────────────────┐
│ Scheme Editor                                    ✕  │
├─────────────────────────────────────────────────────┤
│ ┌──────────────┐  ┌──────────────────────────────┐ │
│ │ ➤ Build      │  │                              │ │
│ │ ➤ Run        │ ← SELECCIONA ESTE              │ │
│ │   Test       │  │                              │ │
│ │   Profile    │  │                              │ │
│ │   Analyze    │  │                              │ │
│ │   Archive    │  │                              │ │
│ └──────────────┘  └──────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

**Acción**: Click en **"Run"** en la columna izquierda.

---

### Paso 3: Ir a la Pestaña Options

Dentro de la sección "Run", verás varias pestañas en la parte superior:

```
┌─────────────────────────────────────────────────────┐
│ Info | Arguments | Options | Diagnostics           │
│               ^^^^^^^^                               │
│               Click aquí                             │
└─────────────────────────────────────────────────────┘
```

**Acción**: Click en **"Options"**.

---

### Paso 4: Configurar StoreKit

En la pestaña Options, busca la sección **"StoreKit Configuration"**:

```
┌─────────────────────────────────────────────────────┐
│ Options                                              │
├─────────────────────────────────────────────────────┤
│                                                      │
│ 🛒 StoreKit Configuration                           │
│                                                      │
│    ┌─────────────────────────────────────┐          │
│    │ None                            ▼  │          │
│    └─────────────────────────────────────┘          │
│         ^                                            │
│         Click en el dropdown                         │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Estado actual**: Probablemente dice **"None"**

---

### Paso 5: Seleccionar Configuration.storekit

Click en el dropdown y selecciona:

```
┌─────────────────────────────────────────────────────┐
│ 🛒 StoreKit Configuration                           │
│                                                      │
│    ┌─────────────────────────────────────┐          │
│    │ None                                │          │
│    │ Configuration                       │ ← ESTE   │
│    └─────────────────────────────────────┘          │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Acción**: Selecciona **"Configuration"**.

Después de seleccionarlo, debería verse:

```
┌─────────────────────────────────────────────────────┐
│ 🛒 StoreKit Configuration                           │
│                                                      │
│    ┌─────────────────────────────────────┐          │
│    │ Configuration                   ▼  │          │
│    └─────────────────────────────────────┘          │
│                                                      │
└─────────────────────────────────────────────────────┘
```

✅ **Perfecto!**

---

### Paso 6: Cerrar y Confirmar

1. **Click en "Close"** (botón inferior derecho)
2. Los cambios se guardan automáticamente

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│                                    [Close]           │
│                                     ^^^^^            │
│                                     Click            │
└─────────────────────────────────────────────────────┘
```

---

## ✅ VERIFICACIÓN

### Cómo saber si está configurado correctamente:

**Método 1: Visual en Xcode**

```
1. Vuelve a abrir Edit Scheme (⌘ + <)
2. Run → Options
3. Verifica que "StoreKit Configuration" = "Configuration"
```

**Método 2: Compilar y probar**

```
1. Clean Build Folder: Cmd + Shift + K
2. Build: Cmd + B
3. Run: Cmd + R
4. Navega a la pantalla de Paywall
5. Intenta comprar un producto
```

---

## 🎬 QUÉ ESPERAR DESPUÉS

### ✅ Comportamiento Correcto

Cuando funciona:

```
1. Al abrir la app, NO verás error 404
2. En PurchaseManager, verás productos cargados:
   • premium.monthly
   • premium.yearly
3. Al hacer tap en "Comprar":
   • Aparecerá un diálogo de confirmación
   • Simulará el pago
   • Desbloqueará premium
4. Los logs mostrarán:
   ✓ Products loaded: 2
   ✓ Purchase successful
   ✓ Transaction verified
```

### ❌ Si Todavía Falla

Si después de configurar sigues viendo error 404:

**Posibles causas:**

1. **No limpiaste la build**
   ```bash
   Cmd + Shift + K (Clean)
   Cmd + B (Build)
   ```

2. **Configuration.storekit no está en el target**
   ```
   • Click en Configuration.storekit
   • File Inspector (⌘ + Option + 1)
   • Target Membership → ✓ Anstop
   ```

3. **Productos no coinciden con PurchaseManager**
   ```swift
   // En Configuration.storekit debe haber:
   "premium.monthly"
   "premium.yearly"
   
   // Y en PurchaseManager.swift:
   private let productIdentifiers = [
       "premium.monthly",
       "premium.yearly"
   ]
   ```

---

## 🧪 PROBAR COMPRAS EN SIMULADOR

### Flujo Completo de Testing

**1. Abrir la app**
```
Cmd + R (Run)
```

**2. Navegar a Paywall**
```
• Desde onboarding, o
• Desde Settings → "Upgrade to Premium"
```

**3. Ver productos disponibles**
```
Deberías ver:
┌─────────────────────────────────┐
│  Premium Monthly                │
│  $4.99/mes                      │
│  [Suscribirme]                  │
└─────────────────────────────────┘
┌─────────────────────────────────┐
│  Premium Yearly                 │
│  $39.99/año (Ahorra 33%)       │
│  [Suscribirme]                  │
└─────────────────────────────────┘
```

**4. Click en "Suscribirme"**
```
Aparecerá un sheet de confirmación:
┌─────────────────────────────────┐
│  Do you want to buy one        │
│  Premium Monthly for $4.99?    │
│                                 │
│  [Cancel]        [Buy]         │
└─────────────────────────────────┘
```

**5. Click en "Buy"**
```
• La transacción se procesará
• Verás animación de carga
• Se desbloqueará premium
• Volverás a la pantalla principal
```

**6. Verificar en Settings**
```
Settings → debería mostrar:
┌─────────────────────────────────┐
│ 👑 Premium Active               │
│ Subscribed to Premium Monthly   │
│                                 │
│ [Manage Subscription]           │
└─────────────────────────────────┘
```

---

## 🔍 GESTIONAR TRANSACCIONES DE PRUEBA

### Ver Transacciones en Xcode

Durante el desarrollo, puedes gestionar las transacciones:

**1. Abrir StoreKit Transaction Manager**

```
Debug → StoreKit → Manage Transactions
```

O mientras la app está corriendo:

```
Editor → StoreKit → Show StoreKit Testing UI
```

**2. Ventana de Transacciones**

Verás una lista de todas las compras simuladas:

```
┌─────────────────────────────────────────────────────┐
│ StoreKit Transaction Manager                        │
├─────────────────────────────────────────────────────┤
│ Transaction ID    Product           Status          │
├─────────────────────────────────────────────────────┤
│ 1234567890       premium.monthly   ✓ Purchased     │
│ 1234567891       premium.yearly    ✓ Purchased     │
└─────────────────────────────────────────────────────┘

Acciones disponibles:
• Delete Transaction (simular cancelación)
• Refund Transaction (simular reembolso)
• Expire Subscription (simular expiración)
• Clear Transactions (borrar todo)
```

### Simular Escenarios

**Cancelar suscripción:**
```
1. Debug → StoreKit → Manage Transactions
2. Selecciona la transacción
3. Click derecho → "Cancel Subscription"
```

**Reembolso:**
```
1. Selecciona transacción
2. Click derecho → "Refund Purchase"
```

**Expirar suscripción:**
```
1. Selecciona transacción
2. Click derecho → "Expire Subscription"
```

**Limpiar todo:**
```
Debug → StoreKit → Clear Transactions
```

---

## 🎨 PERSONALIZAR Configuration.storekit

Si necesitas cambiar precios o productos:

**1. Abrir el archivo**

```
Project Navigator → Configuration.storekit
(doble click)
```

**2. Verás el editor visual:**

```
┌─────────────────────────────────────────────────────┐
│ Configuration.storekit                              │
├─────────────────────────────────────────────────────┤
│ In-App Purchases                                    │
│ ┌─────────────────────────────────────────────────┐ │
│ │ • premium.monthly    Auto-Renewable   $4.99    │ │
│ │ • premium.yearly     Auto-Renewable   $39.99   │ │
│ └─────────────────────────────────────────────────┘ │
│                                                      │
│ [+ Add Product]                                     │
└─────────────────────────────────────────────────────┘
```

**3. Editar un producto:**

```
• Click en el producto
• Aparecerá el inspector a la derecha
• Puedes cambiar:
  - Product ID
  - Reference Name
  - Price
  - Subscription Duration
  - Free Trial Duration
  - Introductory Offer
```

**4. Guardar cambios:**

```
Cmd + S (automático)
```

---

## 🚨 TROUBLESHOOTING

### Problema 1: "No products found"

**Causa**: StoreKit Configuration no está activado.

**Solución**:
```
1. Edit Scheme → Run → Options
2. StoreKit Configuration = Configuration
3. Clean + Build + Run
```

---

### Problema 2: Error 404 persiste

**Causa**: Build cache corrupta.

**Solución**:
```bash
# En Xcode:
1. Product → Clean Build Folder (Cmd + Shift + K)
2. Cerrar Xcode completamente
3. Borrar DerivedData:
   rm -rf ~/Library/Developer/Xcode/DerivedData/Anstop-*
4. Abrir Xcode
5. Build (Cmd + B)
6. Run (Cmd + R)
```

---

### Problema 3: Productos no cargan

**Causa**: Product IDs no coinciden.

**Solución**:
```swift
// 1. Verificar en Configuration.storekit:
"premium.monthly"
"premium.yearly"

// 2. Verificar en PurchaseManager.swift:
private let productIdentifiers = [
    "premium.monthly",  // Debe coincidir exactamente
    "premium.yearly"    // Debe coincidir exactamente
]

// 3. Deben ser IDÉNTICOS (case-sensitive)
```

---

### Problema 4: Compra no desbloquea premium

**Causa**: Lógica de desbloqueo no implementada.

**Solución**:
```swift
// Verificar que existe en PurchaseManager:
@Published var hasPremium: Bool = false

// Y que se actualiza después de comprar:
func purchase(_ product: Product) async throws {
    // ... compra ...
    await updatePurchasedProducts()  // Esto debe actualizar hasPremium
}
```

---

## 📊 RESUMEN RÁPIDO

```
╔═══════════════════════════════════════════════════════════╗
║  CONFIGURACIÓN STOREKIT - CHECKLIST                       ║
╚═══════════════════════════════════════════════════════════╝

 [ ] 1. Configuration.storekit existe en el proyecto
 [ ] 2. Productos configurados (monthly, yearly)
 [ ] 3. Edit Scheme → Run → Options
 [ ] 4. StoreKit Configuration = "Configuration"
 [ ] 5. Close scheme editor
 [ ] 6. Clean Build Folder (Cmd + Shift + K)
 [ ] 7. Build (Cmd + B)
 [ ] 8. Run (Cmd + R)
 [ ] 9. Probar compra en Paywall
 [ ] 10. Verificar premium activado

╔═══════════════════════════════════════════════════════════╗
║  RESULTADO ESPERADO                                       ║
╚═══════════════════════════════════════════════════════════╝

 ✅ Sin error 404
 ✅ Productos cargan correctamente
 ✅ Diálogo de compra aparece
 ✅ Compra se completa
 ✅ Premium se desbloquea
 ✅ Settings muestra estado premium
```

---

## 🎯 PRÓXIMO PASO

**Después de configurar:**

```
1. Limpia:  Cmd + Shift + K
2. Compila: Cmd + B
3. Ejecuta: Cmd + R
4. Prueba comprar un producto
5. Verifica que funciona
```

Si todo funciona:
```
✅ ¡Listo para desarrollar sin errores de StoreKit!
```

Si hay problemas:
```
📖 Revisa la sección TROUBLESHOOTING arriba
```

---

**Última actualización**: 2 de diciembre de 2025, 06:17 UTC  
**Proyecto**: Anstop  
**Estado**: Listo para testing local
