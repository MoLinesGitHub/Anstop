# Fix Crítico: Crash de PurchaseManager Environment

## 🚨 Problema

La aplicación crasheaba al intentar abrir **SettingsView** y otras vistas con un error de **recursión infinita** y **assertion failure** en SwiftUI.

### Crash Log:
```
Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Termination Reason: Namespace SIGNAL, Code 5, Trace/BPT trap: 5

Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   libswiftCore.dylib         _assertionFailure(_:_:file:line:flags:) + 156
1   SwiftUICore                specialized EnvironmentValues.subscript.getter + 308
```

### Causa Raíz:
```swift
@Environment(PurchaseManager.self) private var purchaseManager
```

El problema era que **`PurchaseManager`** no estaba siendo inyectado en el environment de SwiftUI, lo que causaba un **assertion failure** cuando las vistas intentaban acceder a él.

---

## ✅ Solución

He implementado el **patrón Singleton** para `PurchaseManager`, que es más apropiado para un servicio global que no necesita ser pasado por la jerarquía de vistas.

### 1. Añadido Singleton a PurchaseManager

```swift
// PurchaseManager.swift
@MainActor
@Observable
final class PurchaseManager {
    // Singleton instance
    static let shared = PurchaseManager()
    
    // ...resto del código
}
```

### 2. Actualizado todas las vistas

**ANTES (crasheaba):**
```swift
@Environment(PurchaseManager.self) private var purchaseManager
```

**DESPUÉS (funciona):**
```swift
@State private var purchaseManager = PurchaseManager.shared
```

---

## 📝 Archivos Corregidos

1. ✅ **PurchaseManager.swift** - Añadido `static let shared`
2. ✅ **SettingsView.swift** - Reemplazado `@Environment` con `@State + shared`
3. ✅ **HomeView.swift** - Reemplazado `@Environment` con `@State + shared`
4. ✅ **PanicFlowView.swift** - Reemplazado `@Environment` con `@State + shared`
5. ✅ **AudioGuidesView.swift** - Reemplazado `@Environment` con `@State + shared`
6. ✅ **PaywallView.swift** - Reemplazado `@Environment` con `@State + shared` (2 structs)

---

## 🎯 Por Qué Funciona

### Problema con `@Environment`:
- Requiere que el objeto sea **inyectado explícitamente** en la jerarquía de vistas
- Si no se inyecta, SwiftUI crashea con assertion failure
- No es apropiado para servicios globales como `PurchaseManager`

### Ventajas del Singleton:
- ✅ **Acceso global** sin necesidad de inyección
- ✅ **Una sola instancia** compartida por toda la app
- ✅ **No crashea** si no se inyecta en el environment
- ✅ **Más simple** para servicios que deben existir durante toda la vida de la app

---

## 🔄 Comportamiento Correcto

### Antes (CRASH):
```
App Launch → SettingsView carga → Busca PurchaseManager en environment
→ No encuentra → Assertion Failure → CRASH
```

### Después (FUNCIONA):
```
App Launch → PurchaseManager.shared creado → SettingsView carga
→ Usa PurchaseManager.shared → FUNCIONA ✅
```

---

## 🧪 Testing

### Compilación:
```bash
xcodebuild -workspace Anstop.xcworkspace -scheme Anstop build
```
**Resultado:** ✅ BUILD SUCCEEDED

### Runtime:
- ✅ SettingsView carga sin crashes
- ✅ HomeView funciona correctamente
- ✅ PaywallView muestra productos
- ✅ Compras funcionan correctamente

---

## 📚 Lecciones Aprendidas

### Cuándo usar `@Environment`:
- ✅ Para objetos que **varían por contexto** (ej: `\.modelContext`)
- ✅ Para **dependency injection** en tests
- ✅ Para objetos que **cambian entre vistas**

### Cuándo usar Singleton:
- ✅ Para **servicios globales** (ej: PurchaseManager, NotificationManager)
- ✅ Para objetos que **viven durante toda la app**
- ✅ Para **managers de sistema** (ej: LocationManager, HealthKit)

---

## 🎉 Resultado Final

**La app ahora funciona correctamente sin crashes relacionados con PurchaseManager.**

Todas las vistas que dependían de `PurchaseManager` ahora usan el singleton `shared` y la app es estable.

---

**Commit:** `4a65fa4`  
**Fecha:** 4 de Diciembre 2025  
**Severidad:** CRÍTICA (crash on launch)  
**Estado:** ✅ RESUELTO
