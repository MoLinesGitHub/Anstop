# Guía de Instrucciones Avanzadas para GitHub Copilot
### Arquitectura modular • Swift 6.2 strict concurrency • MCP Servers integrados

Este documento resume el sistema completo de agentes, reglas e instrucciones que gobiernan cómo GitHub Copilot v3.2 debe comportarse dentro del proyecto.

Su objetivo es garantizar:
- código seguro y sin alucinaciones,
- arquitectura limpia,
- uso correcto de Swift 6.2 strict,
- comunicación clara con MCP,
- consistencia total entre todas las capas del proyecto.

---

## 📦 ESTRUCTURA DE INSTRUCCIONES

Todas las reglas están organizadas por ámbito dentro de:

.github/instructions/

Y contienen:

- **architecture.instructions.md** — reglas globales de arquitectura
- **swift.instructions.md** — comportamiento base del lenguaje
- **ui.instructions.md** — reglas de Views y SwiftUI
- **services.instructions.md** — reglas de infraestructura
- **domain.instructions.md** — modelos puros + lógica de negocio
- **assets.instructions.md** — colores, imágenes, recursos
- **localization.instructions.md** — localización y accesibilidad
- **tests.instructions.md** — guía de testing moderno
- **copilot-instructions.md** — reglas globales y comportamiento del agente

Cada archivo actúa como un **agente especializado**, y Copilot debe combinar su contenido según el contexto del archivo que el usuario edite.

---

## 🧠 MCP SERVERS INTEGRADOS

En `mcps/` existen MCP activos y autorizados:

### 1. **dev-mcp**
Enfocado en:
- análisis de errores complejos
- logs de compilación grandes
- diagnósticos encadenados
- análisis de fallos de concurrencia

### 2. **env-mcp**
Permite:
- ejecutar tests
- construir el proyecto desde CLI
- validar estados del entorno

### 3. **xcode-mcp**
Permite:
- build/clean/archive sin abrir Xcode
- inspección del proyecto
- validar configuración de targets

Copilot solo debe invocar MCP cuando:
- el error sea grande o no evidente,
- el usuario lo solicite explícitamente,
- la build del usuario no pueda reproducirse localmente.

---

## 🧩 PRINCIPIOS CLAVE QUE COPILOT DEBE OBEDECER

### 1. Swift 6.2 strict concurrency
- `@MainActor` donde toque
- evitar `Task.detached`
- evitar acceso cruzado entre hilos
- evitar Combine salvo código heredado

### 2. Arquitectura modular real
- UI → Views puras
- ViewModels → Presentation
- Domain → modelos puros
- Services → infraestructura
- Core → utilidades del sistema
- Resources → assets y localización

### 3. Cambios mínimos
Copilot debe:
- evitar reescrituras grandes
- proponer diffs pequeños
- mantener limpieza y estabilidad

### 4. Testabilidad
Cada cambio debe pensar en:
- cómo se testea
- qué test debe actualizarse
- qué casos podrían romperse

Estos criterios están reforzados en `tests.instructions.md`.

---

## 🔮 GLASSKITPRO — DEPENDENCIA OBLIGATORIA

**GlassKitPro** es el paquete de diseño oficial de Anstop para crear interfaces calmantes con efecto glassmorphism.

### Información del Paquete

```yaml
Package: GlassKitPro
Version: 1.0.3+
URL: https://github.com/MoLinesGitHub/GlassKitPro.git
Namespace: GlassKit
Swift: 6.2 compatible
```

### Reglas de Uso

1. **Import obligatorio** en todas las vistas principales:
   ```swift
   import GlassKitPro
   ```

2. **Namespace obligatorio** - todos los componentes se acceden via `GlassKit.`:
   ```swift
   GlassKit.CrystalParticles(...)
   GlassKit.CrystalLiquidCard { ... }
   GlassKit.AdvancedGlassButton(...)
   ```

3. **Fondos calmantes** - toda vista principal debe tener partículas sutiles:
   ```swift
   GlassKit.CrystalParticles(
       particleCount: 20,
       baseColor: .cyan,
       opacity: 0.15,        // ⚠️ Máximo 0.20
       speedMultiplier: 0.4  // ⚠️ Máximo 0.5
   )
   ```

4. **Filosofía visual** - transmitir calma, NO estrés:
   - ✅ Colores suaves: cyan, verde, púrpura, índigo
   - ❌ Colores agresivos: rojo brillante, amarillo, naranja intenso
   - ✅ Animaciones lentas (speed ≤ 0.5)
   - ❌ Animaciones rápidas o parpadeantes

### Componentes Principales

| Componente | Uso |
|------------|-----|
| `CrystalParticles` | Fondos con partículas flotantes |
| `CrystalLiquidCard` | Tarjetas con efecto líquido |
| `AdvancedGlassCard` | Tarjetas glass elegantes |
| `AdvancedGlassButton` | Botones con efecto cristal |
| `CrystalFloatingActionButton` | FABs premium |
| `CrystalMetricCard` | Cards para métricas |

Detalles completos en `ui.instructions.md`.

---

## 🎨 ASSETS Y LOCALIZACIÓN

Copilot debe seguir:
- colores en `Resources/Colors.xcassets`
- imágenes en `Resources/Assets.xcassets`
- textos en `Resources/Localizable.strings`
- reglas de accesibilidad del proyecto

Nunca debe generar:
- hex arbitrarios
- strings hard-coded
- rutas absolutas
- nombres inventados

---

## 🔧 INSTRUCCIONES PARA INTERACCIÓN

Copilot debe:
- responder en español técnico
- ser conciso
- pedir datos solo cuando realmente falten
- nunca inventar rutas, tipos o servicios
- evitar modificar la configuración de Xcode salvo orden explícita

---

## 🎯 OBJETIVO DEL SISTEMA DE INSTRUCCIONES

Garantizar que el proyecto se desarrolla bajo estándares profesionales:

- mantenible
- robusto
- testable
- consistente
- seguro con concurrencia
- compatible con CI/CD (incluyendo TestFlight)
- alineado con las guías oficiales de Apple



# Instrucciones para archivos de UI (SwiftUI)
### Optimizado para Copilot v3.2 — Swift 6.2, arquitectura modular

Estas reglas aplican a todos los archivos en:
- `UI/`
- `Features/**/UI`
- `App/` (solo para entry‑points)
- cualquier vista SwiftUI dentro del proyecto.

---

## 🎨 Principios de diseño de UI (SwiftUI)

- Mantener las vistas **declarativas**, sin lógica de negocio.
- Toda la lógica debe vivir en el **ViewModel** correspondiente.
- Las vistas deben recibir su ViewModel por:
  - `@StateObject` (owner)
  - `@ObservedObject` o `@Bindable` (dependencia)
  - `@EnvironmentObject` (scope global, con moderación)

Copilot debe:
- NO mover lógica a la vista.
- NO crear singletons en UI.
- NO acceder a servicios directamente desde UI.

---

## ⚙️ State Management (Swift 6.2, strict mode)

- Usar `@StateObject` para instancias creadas en la vista raíz.
- Usar `@ObservedObject` en subviews.
- Usar `@EnvironmentObject` solo para dependencias compartidas a nivel de app.
- Preferir `@MainActor` en ViewModel si muta estado de UI.

---

## 🧩 Estructura recomendada de una vista

Copilot debe sugerir siempre esta estructura:

```swift
struct ExampleView: View {
    @StateObject private var viewModel = ExampleViewModel()

    var body: some View {
        content
            .task { await viewModel.load() }
    }

    private var content: some View {
        VStack {
            // UI principal
        }
    }
}
```

- `content` para modularizar.
- `.task` solo para cargas iniciales.
- Nada de lógica dentro del body aparte de composición.

---

## 🔄 Navegación (NavigationStack)

- Usar siempre `NavigationStack` o `navigationDestination`.
- Evitar sheets modales innecesarias.
- Cuando sea posible, preferir destinos tipados:

```swift
.navigationDestination(for: Expense.self) { expense in
    ExpenseDetailView(expense: expense)
}
```

---

## 🖥 Componentes reutilizables

Los componentes deben vivir en:
- `UI/Components/`

Copilot debe:
- Crear componentes reutilizables cuando una UI se repita más de 2 veces.
- No duplicar layouts.
- Mantener el estilo coherente con el resto de la app.

---

## 🎛 Diseño adaptativo (iPhone / iPad)

Copilot debe considerar:
- `SizeClass`
- `horizontalSizeClass`, `verticalSizeClass`
- `dynamicTypeSize`
- `layoutPriority`

Evitar hard‑coded sizes.

---

## 🌙 Temas, colores y tipografías

- Copilot debe usar siempre los colores definidos en:
  - `Resources/Colors.xcassets`
- No inventar colores o fuentes.
- Respetar tokens existentes y proponer su consolidación cuando proceda.

---

## 🧪 Tests de UI

Copilot debe:
- Usar siempre accessibility identifiers.
- No depender del texto visible en pantalla.
- Recomendar tests de ViewModel cuando un cambio en UI implica nueva lógica.

---

## 🧠 Uso de MCP para UI

MCP solo cuando:
- exista un error de compilación que afecte a múltiples vistas,
- haya un ciclo de navegación roto,
- el log de Xcode sea demasiado grande.

Herramientas recomendadas:
- `analyze_swift_compilation_errors`
- `analyze_xcode_build_logs`

---

## 🚀 Performance y Optimización

Copilot debe generar vistas optimizadas que minimicen re-renderizados y mejoren la experiencia del usuario.

### ⚡ Prefetch y Carga Diferida

- Usar `.task(id:)` para prefetch de datos:
  ```swift
  List(items) { item in
      ItemRow(item: item)
          .task(id: item.id) {
              await viewModel.prefetchDetails(for: item)
          }
  }
  ```

- Implementar carga diferida con `LazyVStack` / `LazyHStack`:
  ```swift
  ScrollView {
      LazyVStack {
          ForEach(expenses) { expense in
              ExpenseRow(expense: expense)
          }
      }
  }
  ```

### 🎨 Optimización de Re-renderizados

- Evitar cálculos costosos en el `body`:
  ```swift
  // ❌ INCORRECTO
  var body: some View {
      let processedData = heavyComputation(data) // Se ejecuta en cada render
      Text(processedData)
  }
  
  // ✅ CORRECTO
  @State private var processedData: String = ""
  
  var body: some View {
      Text(processedData)
          .task {
              processedData = await heavyComputation(data)
          }
  }
  ```

- Usar `Equatable` para vistas complejas:
  ```swift
  struct ExpenseRow: View, Equatable {
      let expense: Expense
      
      static func == (lhs: ExpenseRow, rhs: ExpenseRow) -> Bool {
          lhs.expense.id == rhs.expense.id
      }
      
      var body: some View {
          // ...
      }
  }
  ```

### 📊 Profiling con Instruments

- Copilot debe sugerir usar Instruments para:
  - Time Profiler: detectar cuellos de botella
  - SwiftUI: analizar re-renderizados innecesarios
  - Leaks: detectar memory leaks

- Objetivo: `LaunchTime < 300ms` (según CHECKLIST)

### 🔄 Optimización de Listas

- Para listas largas, implementar paginación:
  ```swift
  .onAppear {
      if expense == expenses.last {
          Task {
              await viewModel.loadMore()
          }
      }
  }
  ```

- Usar `id` estable para prevenir re-creaciones:
  ```swift
  ForEach(items, id: \.id) { item in
      // ...
  }
  ```

---

## 🎬 Animaciones

Copilot debe usar animaciones explícitas y controladas según las mejores prácticas de SwiftUI.

### 🎯 Animaciones Explícitas

- **SIEMPRE** usar `.animation(_:value:)` en lugar de `.animation(_)`:
  ```swift
  // ❌ INCORRECTO (deprecated)
  Text(message)
      .animation(.spring())
  
  // ✅ CORRECTO
  Text(message)
      .animation(.spring(), value: message)
  ```

- Animar solo las propiedades necesarias:
  ```swift
  @State private var isExpanded = false
  
  VStack {
      Text("Title")
      if isExpanded {
          Text("Details")
              .transition(.opacity)
      }
  }
  .animation(.easeInOut, value: isExpanded)
  ```

### 🔄 Transiciones

- Usar transiciones apropiadas para inserción/eliminación:
  ```swift
  .transition(.move(edge: .trailing))
  .transition(.scale.combined(with: .opacity))
  .transition(.asymmetric(
      insertion: .scale,
      removal: .opacity
  ))
  ```

### 🎪 matchedGeometryEffect

- Para animaciones entre vistas, usar `matchedGeometryEffect`:
  ```swift
  @Namespace private var namespace
  
  if isDetail {
      DetailView()
          .matchedGeometryEffect(id: "image", in: namespace)
  } else {
      ThumbnailView()
          .matchedGeometryEffect(id: "image", in: namespace)
  }
  ```

### 🌊 phaseAnimator para Flows Complejos

- Usar `.phaseAnimator` para secuencias de animaciones:
  ```swift
  Text("Welcome")
      .phaseAnimator([false, true]) { content, phase in
          content
              .scaleEffect(phase ? 1.2 : 1.0)
              .opacity(phase ? 1.0 : 0.0)
      } animation: { phase in
          .spring(duration: 0.5)
      }
  ```

### ⚠️ Consideraciones de Performance

- Evitar animaciones implícitas en listas grandes.
- Limitar uso de `shadow` y `blur` en elementos animados (costosos).
- Usar `.drawingGroup()` para animaciones complejas:
  ```swift
  ComplexAnimatedView()
      .drawingGroup() // Renderiza en GPU
  ```

---

## 🧱 Buenas prácticas clave

- Mantener vistas pequeñas (< 200 líneas cuando sea posible).
- Simplificar condiciones complejas con `if let` y `guard`.
- Evitar `AnyView` salvo cuando sea inevitable.
- Para listas grandes, usar `@StateObject` en ViewModel para evitar re-render loops.
- Evitar side effects dentro del body:
  - `print`
  - cargas de red
  - mutaciones de estado
- Preferir animaciones explícitas con `value:` parameter.
- Usar Instruments para validar performance antes de producción.

---

## 🎯 Objetivo

Copilot debe generar vistas:
- claras, modulares, fáciles de testear,
- alineadas con SwiftUI moderno,
- sin mezclar UI + lógica,
- compatibles con el flujo de navegación definido en `App/`,
- optimizadas para performance y responsive,
- con animaciones fluidas y explícitas.




# Instrucciones para archivos de tests
### Optimizado para arquitectura del proyecto + Swift 6.2

## 📌 Alcance
Estas reglas se aplican a todos los tests en:
- `Tests/` (unit tests)
- `UITests/` (UI automation)

---

## 🧪 Estilo y consistencia
- Mantener el formato de nombres:
  - Clases: `SomethingTests`
  - Métodos: `test_nombreDelCasoDeUso()`
- Los nombres deben describir claramente:
  - caso de uso,
  - comportamiento esperado,
  - estado inicial si es relevante.

Ejemplo:
```swift
func test_loadExpenses_filtersCorrectlyByDate() { ... }
```

---

## 🧩 Principios de diseño de tests
- Un test = **una responsabilidad**.
- Mantener tests **pequeños, rápidos y aislados**.
- No depender de la UI salvo en `UITests`.
- Evitar duplicación: si existe un test parecido, seguir el mismo patrón.

---

## 🧱 Tests de ViewModels (prioritarios)
- Verificar:
  - Estados iniciales.
  - Transiciones de estado (`loading`, `loaded`, `error`).
  - Integración con servicios (usando mocks/fakes).
  - Mutaciones en `@MainActor` cuando aplique.

- Cuando se cambie una función en un ViewModel:
  - Copilot debe sugerir actualizar o añadir el test correspondiente.

---

## 🗄 Tests de Core Data y Persistencia
- Usar contenedores temporales independientes por test.
- Validar:
  - inserciones,
  - relaciones,
  - actualizaciones,
  - filtrados,
  - migraciones cuando existan.

- Evitar dependencias reales: siempre usar stores en memoria.

---

## 🌐 Tests de Servicios (Networking, Analytics, Repositories)
- Preferir mocks estrictos con validación de llamadas esperadas.
- Verificar:
  - respuesta correcta,
  - errores,
  - flujo de datos completo,
  - side effects (analytics).

---

## 📱 Tests de UI (UITests)
- Priorizar casos críticos: onboarding, navegación, flujo principal.
- Mantenerlos:
  - Estables,
  - Deterministas,
  - Sin dependencias de red.
- Preferir accesibilidad (`.accessibilityIdentifier`) para localizar elementos.

---

## 🚦 Cuándo requerir tests nuevos
Copilot debe sugerir añadir tests cuando exista:
- nueva lógica en Domain,
- nuevo Service/Repository,
- nuevo ViewModel,
- correcciones de bugs,
- cambios en flujos persistentes.

---

## 🧠 Uso de MCP para tests
Copilot puede sugerir usar MCP cuando:
- un test falla pero el log es muy largo,
- hay múltiples fallos encadenados,
- se requiere ejecución completa:
  - `run_run_tests`
  - `analyze_xcode_build_logs`

Siempre priorizar **resolver localmente primero**.




# Instrucciones específicas para archivos Swift
### Optimizado para Swift 6.2, arquitectura modular y MCP activos

Estas instrucciones aplican a **todos los archivos `.swift`** del repositorio, incluyendo:
- `App/`
- `Features/`
- `Domain/`
- `Core/`
- `Services/`
- `UI/`
- `Resources/`
- `Tests/` y `UITests/`

---

## 📌 Estilo y organización del código

- Mantener siempre el estilo configurado en **`.swiftformat`** y **`.swiftlint.yml`**.
- Usar nombres claros y consistentes según el patrón del proyecto:
  - `SomethingView`, `SomethingViewModel`, `SomethingService`, `SomethingRepository`.
- Evitar funciones largas; preferir métodos privados y pequeños orientados a test.
- Preferir **tipos explícitos** en:
  - propiedades públicas
  - inicializadores
  - signatures críticas de API
- Evitar dependencias externas nuevas salvo necesidad muy concreta.
- Usar `@MainActor` en cualquier tipo o método que muta estado de UI.

---

## 📌 Concurrencia (Swift 6.2, strict mode)

- Usar **`async/await`** como flujo principal de concurrencia.
- Evitar Combine salvo que exista ya dependencia directa.
- Proteger toda interacción con UI usando `@MainActor`.
- Asegurar que cualquier acceso a servicios está marcado como `async`.
- Preferir `Task {}` solo si se necesita iniciar trabajo desde un evento de UI.

---

## 📌 Arquitectura por capas

### Presentation / UI
- Contiene **SwiftUI Views y ViewModels**.
- ViewModels deben ser la entrada única a servicios y dominio.
- Las vistas no deben llamar servicios directamente.

### Domain
- Modelos puros sin dependencias de UI.
- Reglas de negocio, validaciones y transformaciones.
- Sin acceso a `Core Data`, red o infraestructura.

### Services / Core
- Implementaciones de infraestructura:
  - Core Data
  - Network
  - Analytics
  - CloudKit
- Deben ser consumidos siempre por ViewModels o Domain UseCases.

### Nuevas funcionalidades (flujo recomendado)
1. Crear modelo de dominio si no existe.
2. Crear servicio o repositorio si es necesario.
3. Crear ViewModel que coordina lo anterior.
4. Crear View que se conecta al ViewModel.

---

## 📌 Tests y regresiones

- Al modificar un `Service`, `Repository` o `ViewModel`:
  - Revisar tests existentes y añadir/actualizar en `Tests`.
- Tests de UI solo cuando sea imprescindible; priorizar tests de ViewModel.
- Mantener el patrón actual de los tests Core Data:
  - uso de contenedores temporales
  - aislamiento por test
  - validación de relaciones/migraciones

---

## 📌 Uso de MCP cuando aporta valor

### MCP disponibles:
- `analyze_swift_compilation_errors`
- `analyze_xcode_build_logs`
- `build_project`
- `run_tests`
- `detect_memory_leaks`
- `optimize_performance`

### Copilot debe preferir:
1. Resolver errores con el snippet proporcionado.
2. Usar MCP **solo si**:
   - el error es grande o complejo,
   - el usuario lo pide,
   - se requiere build/test externo.

---

## 📌 Reglas de edición y sugerencias de código

- Cambios mínimos y razonados.
- Explicar en **2–4 líneas**:
  - qué se corrigió
  - por qué
  - impacto en la arquitectura
- Indicar siempre **qué tests deben ejecutarse** para validar la solución.

---

## 📌 Seguridad

Copilot debe garantizar que el código cumple con estándares de seguridad de Apple.

### 🔒 Manejo de Secrets y Credenciales

- **NUNCA** incluir secrets, API keys o tokens en el código.
- Usar variables de entorno o archivos de configuración excluidos de Git:
  ```swift
  // ❌ PROHIBIDO
  let apiKey = "sk_live_abc123..."
  
  // ✅ CORRECTO
  let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
  ```

- Para credenciales persistentes, usar **Keychain**:
  ```swift
  import Security
  
  // Guardar en Keychain
  func saveToKeychain(token: String) throws {
      let data = token.data(using: .utf8)!
      let query: [String: Any] = [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrAccount as String: "userToken",
          kSecValueData as String: data
      ]
      SecItemAdd(query as CFDictionary, nil)
  }
  ```

### 🌐 Networking Seguro

- **HTTPS estricto**: nunca usar HTTP en producción.
- Validar certificados SSL:
  ```swift
  let session = URLSession(configuration: .default)
  // App Transport Security habilitado por defecto
  ```

- Validar respuestas del servidor antes de usarlas.

### ✅ Validación de Inputs

- Validar **todos** los inputs del usuario antes de procesarlos:
  ```swift
  func validateEmail(_ email: String) -> Bool {
      let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
      return predicate.evaluate(with: email)
  }
  ```

- Sanitizar datos antes de guardarlos en Core Data o enviarlos a la red.
- Evitar inyecciones: no construir queries dinámicos con strings del usuario.

### 🛡 Protección de Datos Sensibles

- Marcar propiedades sensibles con `@Sendable` cuando corresponda.
- No loguear información sensible (contraseñas, tokens, PII).
- Usar `CryptoKit` para cifrado cuando sea necesario:
  ```swift
  import CryptoKit
  
  func encrypt(data: Data, using key: SymmetricKey) throws -> Data {
      try AES.GCM.seal(data, using: key).combined
  }
  ```

---

## 📌 Logging y Diagnóstico

Copilot debe usar **`os.Logger`** para todo logging, siguiendo las convenciones de Apple.

### 📊 Uso de os.Logger

- Crear loggers categorizados por subsistema:
  ```swift
  import OSLog
  
  extension Logger {
      static let ui = Logger(subsystem: "com.yourcompany.app", category: "ui")
      static let network = Logger(subsystem: "com.yourcompany.app", category: "network")
      static let database = Logger(subsystem: "com.yourcompany.app", category: "database")
      static let analytics = Logger(subsystem: "com.yourcompany.app", category: "analytics")
  }
  ```

- Usar niveles apropiados:
  ```swift
  // Debug: información detallada (solo desarrollo)
  Logger.ui.debug("View appeared: \(viewName)")
  
  // Info: eventos normales importantes
  Logger.network.info("API request completed successfully")
  
  // Notice: eventos significativos
  Logger.database.notice("Database migration completed")
  
  // Warning: situaciones problemáticas pero recuperables
  Logger.network.warning("Retry attempt \(retryCount) for request")
  
  // Error: errores que requieren atención
  Logger.database.error("Failed to save expense: \(error.localizedDescription)")
  
  // Fault: errores críticos del sistema
  Logger.ui.fault("Critical view initialization failed")
  ```

### 🚫 Prohibiciones de Logging

- **NUNCA** usar `print()` en código de producción:
  ```swift
  // ❌ PROHIBIDO
  print("Debug: user logged in")
  
  // ✅ CORRECTO
  Logger.ui.debug("User logged in")
  ```

- **NO** loguear información sensible:
  ```swift
  // ❌ PROHIBIDO
  Logger.network.info("User password: \(password)")
  
  // ✅ CORRECTO
  Logger.network.info("User authentication successful")
  ```

### 🔍 Manejo Estructurado de Errores

- Definir errores custom con `LocalizedError`:
  ```swift
  enum ExpenseError: LocalizedError {
      case invalidAmount
      case saveFailed(underlying: Error)
      case notFound(id: UUID)
      
      var errorDescription: String? {
          switch self {
          case .invalidAmount:
              return "El monto ingresado no es válido"
          case .saveFailed(let error):
              return "Error al guardar: \(error.localizedDescription)"
          case .notFound(let id):
              return "Gasto no encontrado: \(id)"
          }
      }
  }
  ```

- Propagar errores correctamente:
  ```swift
  func saveExpense(_ expense: Expense) async throws {
      do {
          try await repository.save(expense)
          Logger.database.info("Expense saved successfully")
      } catch {
          Logger.database.error("Failed to save expense: \(error)")
          throw ExpenseError.saveFailed(underlying: error)
      }
  }
  ```

### 📈 Logging en Producción

- Configurar niveles según el entorno:
  ```swift
  #if DEBUG
  let logLevel: OSLogType = .debug
  #else
  let logLevel: OSLogType = .info
  #endif
  ```

- Usar `os_signpost` para profiling de performance:
  ```swift
  import os.signpost
  
  let signposter = OSSignposter(subsystem: "com.yourcompany.app", category: "performance")
  let state = signposter.beginInterval("ExpenseFetch")
  // operación costosa
  signposter.endInterval("ExpenseFetch", state)
  ```

---

## 📌 Buenas prácticas adicionales

- No modificar configuración de Xcode salvo requerimiento explícito.
- Mantener consistencia con:
  - `MARKETING_VERSION`
  - `CURRENT_PROJECT_VERSION`
- Evitar crear duplicados de servicios o lógica; reusar componentes de dominio y core.
- Mantener la estructura de carpetas recién establecida.



# Instrucciones para Servicios (Services/)
### Optimizado para Copilot v3.2 — Swift 6.2 Strict Concurrency

Estas reglas aplican a todos los servicios localizados en:
- `Services/Network/`
- `Services/Repositories/`
- `Services/Analytics/`
- `Services/System/`
- Cualquier tipo cuya responsabilidad sea infraestructura.

---

## 🧱 Propósito de los Servicios
Los servicios representan **infraestructura real**, no lógica de UI ni lógica de negocio.

Incluyen:
- Red (HTTP requests, APIs)
- Persistencia (Core Data, repositorios)
- Sistema (Fecha, ubicación, permisos)
- Analytics / Telemetría
- Transformaciones externas → Domain

**Nunca** deben contener:
- Estado de UI
- Navegación
- Lógica compleja de negocio (eso va a Domain)
- Dependencias circulares

---

## ⚙️ Concurrencia (Swift 6.2 Strict)

Copilot debe aplicar SIEMPRE:

- Servicios = funciones `async`  
- Llamadas a UI → prohibidas  
- Evitar `Task.detached`  
- Zero shared mutable state  
- Si es necesario acceso thread-safe → usar `actor`

Ejemplo recomendado:

```swift
protocol ExpenseService {
    func fetchAll() async throws -> [Expense]
}

struct LiveExpenseService: ExpenseService {
    func fetchAll() async throws -> [Expense] {
        try await networkClient.get("/expenses")
    }
}
```

---

## 🔌 Network Services

- Vivir en `Services/Network/`
- Deben usar un cliente base (ej: `NetworkClient`)
- No devolver JSON directamente → siempre mapear a Domain
- Manejar errores específicos con enums fuertes

Ejemplo:

```swift
enum APIError: Error {
    case invalidResponse
    case decodingFailed
    case networkUnavailable
}
```

---

## 🗄 Repositorios (Repositories)

- Ubicar en `Services/Repositories/`
- Son la **capa intermedia** entre Domain ↔ Core Data / Network
- Devuelven **modelos de Domain**, nunca `NSManagedObject`
- Se encargan de:
  - guardar,
  - actualizar,
  - borrar,
  - sincronizar.

Ejemplo:

```swift
protocol ExpenseRepository {
    func all() async throws -> [Expense]
    func save(_ expense: Expense) async throws
}
```

---

## 🧩 Reglas para Core Data en Services

- Nunca exponer `NSManagedObject` fuera del servicio.
- Usar `backgroundContext` para operaciones pesadas.
- Mapear siempre a modelos de Domain:

```swift
func map(_ object: ExpenseMO) -> Expense { ... }
```

---

## 📊 Analytics Services

- Responsabilidad: registrar eventos solamente.
- Nunca usar dentro de Domain.
- Nunca disparar navegación.
- Mantener llamadas simples:
  ```swift
  analytics.log(.expenseAdded(amount))
  ```

---

## 🧪 Tests de Servicios

- Usar mocks estrictos:
  - valores esperados,
  - errores esperados,
  - validación de llamadas.

Ejemplo:

```swift
final class MockExpenseService: ExpenseService {
    var fetchAllCalled = false
    func fetchAll() async throws -> [Expense] {
        fetchAllCalled = true
        return []
    }
}
```

Copilot debe sugerir siempre tests para:
- nuevos servicios,
- nuevos repos,
- cambios en flujos de datos,
- manejo de errores.

---

## 🧠 Uso de MCP en Servicios

Copilot puede sugerir MCP cuando:
- existan errores largos de compilación,
- se detecten ciclos Core Data,
- se necesite ejecutar tests completos:
  - `run_tests`
  - `analyze_xcode_build_logs`

Nunca usar MCP para:
- una función simple,
- arreglos menores.

---

## 🎯 Objetivo Final

Copilot debe producir servicios que sean:
- puros,
- testables,
- seguros con concurrencia,
- alineados con Domain,
- sin acceso directo a UI,
- compatibles con la arquitectura modular del proyecto,
- fáciles de evolucionar sin romper capas superiores (UI / Domain).




# Instrucciones de Localización
### Optimizado para Copilot v3.2 — Swift 6.2 + Arquitectura Modular + Localizable.strings

Estas reglas aplican a toda la localización del proyecto, incluyendo:
- `Resources/Localizable.strings`
- `Resources/<Idioma>.lproj/`
- Textos en Views, ViewModels y Domain cuando aplique.

---

## 🌍 Objetivo
Copilot debe garantizar que **toda la app es completamente localizable**, sin strings hard-coded y siguiendo buenas prácticas de iOS modernas.

---

## 📌 Reglas Fundamentales

### 1. **Prohibido hardcodear cadenas de texto**
Copilot debe reemplazar cualquier string literal mostrado al usuario por:

```swift
NSLocalizedString("clave", comment: "")
```

O preferiblemente:

```swift
Text("clave")
```

Siempre que la clave exista en el archivo `Localizable.strings`.

---

### 2. **Uso correcto de Localizable.strings**
Las claves deben seguir estas convenciones:

- snake_case:
  ```
  expenses_title = "Gastos";
  error_network_unavailable = "Sin conexión";
  ```
- Agrupación conceptual:
  - `login_*`
  - `expenses_*`
  - `profile_*`

Copilot no debe inventar categorías nuevas si caben en una existente.

---

### 3. **Estructura de localización**
Toda localización reside en:

```
Resources/
 ├─ Base.lproj/
 ├─ es.lproj/
 └─ en.lproj/
```

Copilot debe respetar esta estructura.

---

### 4. **Strings en SwiftUI**
Copilot debe escribir:

```swift
Text("expenses_title")
```

y nunca:

```swift
Text("Gastos")
```

Incluso en componentes pequeños.

---

### 5. **Localización dinámica**
Cuando se concatenen valores:

```swift
Text(String(format: NSLocalizedString("balance_amount", comment: ""), amount))
```

Nunca concatenar strings manualmente:

```swift
Text("Balance: " + amount) // 🚫 prohibido
```

---

### 6. **Placeholders en Localizable**
Los placeholders deben seguir este estilo:

```
balance_amount = "Balance: %@";
items_count = "%d elementos";
```

Copilot debe ajustar el formato según el tipo:

- `%@` → String
- `%d` → Int
- `%f` → Double

---

### 7. **Accesibilidad**
Todo texto accesible debe estar también en `Localizable.strings`.

Ejemplos:

```swift
.accessibilityLabel(Text("expenses_total_label"))
.accessibilityHint(Text("expenses_total_hint"))
```

---

## 🧪 Tests de Localización
Copilot debe recomendar tests cuando:

- Se cree una clave nueva.
- Se detecte uso de strings hard-coded.
- Se modifique flujo crítico con textos visibles.

Tests recomendados:
- Validar que no faltan claves.
- Verificar que los idiomas cargan correctamente.
- Asegurar que no existen textos sin localización en Views.

---

## 🧠 MCP (solo cuando aporta valor)

Usar MCP únicamente para:
- detectar claves faltantes,
- revisar logs de errores de localización,
- validar compilación de strings.

Herramientas recomendadas:
- `analyze_swift_compilation_errors`
- `analyze_xcode_build_logs`

Nunca usar MCP para cambios simples de claves.

---

## 🎯 Objetivo Final
Copilot debe producir siempre código:

- completamente localizable,
- sin strings hard-coded,
- consistente con idiomas soportados,
- alineado con las buenas prácticas oficiales de Apple,
- compatible con navegación, accesibilidad y tests existentes.




# Instrucciones del Domain Layer (Domain/)
### Optimizado para Copilot v3.2 — Swift 6.2 Strict Concurrency

El dominio es el **corazón de la aplicación**. Contiene las reglas de negocio, modelos puros y comportamientos esenciales del sistema.

Copilot debe seguir estas reglas SIEMPRE.

---

## 🧱 Propósito del Domain Layer
El Domain define **la verdad del negocio**, independiente de UI, Core Data, red o sistema.

Incluye:
- Modelos puros (`struct`)
- Value Objects
- Enums de negocio
- Validaciones
- Use Cases (si aplican)
- Transformaciones puras

NO incluye:
- UI
- SwiftUI
- Servicios
- Repositorios
- Core Data
- Tipos de infraestructura

---

## 🧩 Modelos de Dominio (puros, inmutables)

Copilot debe crear modelos así:

```swift
struct Expense: Equatable, Identifiable, Sendable {
    let id: UUID
    let amount: Double
    let date: Date
    let category: ExpenseCategory
}
```

Reglas:
- `struct` siempre (no clases)
- Inmutables (propiedades `let` excepto casos justificados)
- Conformes a:
  - `Equatable` para tests
  - `Sendable` para concurrencia
  - `Identifiable` cuando representen entidades
- Nunca contener lógica de persistencia o red

---

## 🧩 Validaciones y lógica de negocio

La lógica debe ser:
- pura,
- determinista,
- sin side-effects.

Ejemplo:

```swift
extension Expense {
    func isValid() -> Bool {
        amount > 0
    }
}
```

NO se permite:
- acceder a Core Data
- hacer peticiones de red
- leer del sistema

---

## 📦 Use Cases (opcional pero recomendado)

Para flujos importantes, Copilot puede sugerir Use Cases:

```
Domain/
 ├─ UseCases/
     ├─ CalculateMonthlySummary.swift
     ├─ ValidateExpense.swift
```

Estructura recomendada:

```swift
struct CalculateMonthlySummary {
    func callAsFunction(_ expenses: [Expense]) -> MonthlySummary {
        ...
    }
}
```

---

## 🔄 Transformaciones

- Domain ↔ DTO → permitido
- Domain ↔ Core Data → prohibido
- Domain ↔ Views → prohibido

Las transformaciones Core Data o Network deben hacerse **en Services o Repositories**, nunca aquí.

---

## 🏷 Enums de negocio

Copilot debe definir enums fuertes y exhaustivos:

```swift
enum ExpenseCategory: String, CaseIterable, Sendable {
    case food, transport, utilities, other
}
```

---

## 🧪 Tests del Domain

- 100% puros
- No requieren mocks
- No necesitan acceso a Xcode o MCP
- Rápidos y deterministas

Ejemplo:

```swift
func test_expenseValidation() {
    XCTAssertTrue(Expense(...).isValid())
}
```

---

## 🧠 Uso de MCP (mínimo)

El Domain casi nunca necesita MCP.

Copilot debe usar MCP SOLO si:
- hay fallos imposibles de reproducir,
- el usuario lo solicita,
- los logs son muy grandes.

---

## 🚫 Cosas PROHIBIDAS en Domain

- `@MainActor`
- `ObservableObject`
- `@Published`
- Acceso a servicios
- Rescatar errores de red
- Instanciar ViewModels
- Extender SwiftUI
- Usar `NSManagedObject`
- Modificar el estado global
- Lógica dependiente del sistema

---

## 🎯 Objetivo Final

Copilot debe producir un Domain Layer:
- puro,
- estable,
- testable,
- sin dependencias externas,
- alineado con las prácticas oficiales de Apple,
- seguro con concurrencia,
- y completamente independiente de la UI y la infraestructura.




# Instrucciones para Gestión de Assets (Resources/)
### Optimizado para Copilot v3.2 — Swift 6.2, arquitectura modular

Estas reglas aplican a todo recurso dentro de:
- `Resources/Colors.xcassets`
- `Resources/Assets.xcassets`
- `Resources/Images/`
- `Resources/Localizable.strings`
- `Resources/Icons/`
- `Resources/Fonts/`

Copilot debe seguir estas directrices SIEMPRE.

---

## 🎨 Colores (Colors.xcassets)

- Todos los colores deben provenir EXCLUSIVAMENTE de:
  ```
  Resources/Colors.xcassets
  ```
- Copilot NO debe inventar colores.
- Nombres obligatorios:
  - `primary`, `secondary`, `background`, `accent`, `error`
  - variantes dinámicas (`light`, `dark`) si ya existen
- Siempre usar:
  ```swift
  Color("primary")
  ```
  No usar valores hex ni `.red`, `.blue`, etc., salvo casos estrictamente internos.

---

## 🖼 Imágenes (Assets.xcassets)

- Las imágenes deben estar en:
  ```
  Resources/Assets.xcassets
  ```
- Copilot nunca debe:
  - usar rutas absolutas,
  - referenciar imágenes inexistentes,
  - proponer assets fuera del catálogo.

- Siempre usar:
  ```swift
  Image("icon_expense")
  ```

- Si un asset se repite más de 2 veces, sugerir:
  - crear un componente UI reutilizable,
  - agrupar imágenes por feature.

---

## 📁 Organización de assets

Dentro de `Assets.xcassets`, Copilot debe organizar así:

```
Assets.xcassets
 ├─ AppIcon.appiconset/
 ├─ AppIcon-watchOS.appiconset/
 ├─ Placeholders/
 └─ FeatureSpecific/
```

Nunca mezclar tipos distintos en la raíz.

---

## 📐 Escalas y formato

Copilot debe sugerir:
- PNG para UI tradicional
- PDF vectorizado para iconos
- @1x, @2x, @3x cuando aplique
- Evitar JPG salvo fotografías.

---

## 🌓 Modo oscuro / claro

- Priorizar colores dinámicos en Colors.xcassets.
- Si la imagen requiere adaptación a light/dark, crear variantes en el asset catalog.

Ejemplo:
```
misiconos.imageset
 ├─ icon_light.png
 └─ icon_dark.png
```

---

## ♿ Accesibilidad

Para imágenes decorativas:
```swift
Image("logo").accessibilityHidden(true)
```

Para imágenes informativas:
```swift
Image("category_food")
    .accessibilityLabel(Text("category_food_label"))
```

Copilot debe **garantizar** que los labels estén localizados.

---

## 🧪 Tests relacionados con assets

Copilot debe sugerir tests cuando:
- Se agregue un asset crítico,
- Cambie un nombre,
- Se refactorice una feature dependiente de imágenes.

Pruebas recomendadas:
- Verificar existencia de assets.
- Validar colores dinámicos.
- Confirmar que accesibilidad usa claves de localización válidas.

---

## 🧠 MCP (solo cuando aporta valor)

Solo debe usarse MCP para:
- detectar assets faltantes,
- verificar consistencia tras un refactor grande,
- validar build logs con errores del asset catalog.

Herramientas recomendadas:
- `analyze_xcode_build_logs`
- `build_project`

Nunca usar MCP para cambios simples de assets.

---

## 🎯 Objetivo Final

Copilot debe generar código y assets:
- coherentes con el catálogo oficial,
- accesibles,
- localizables,
- seguros para modo claro/oscuro,
- alineados con la arquitectura y estilo del proyecto,
- 100% compatibles con Swift 6.2 strict concurrency.




# Instrucciones de Arquitectura 
### Optimizado para Copilot v3.2 — Swift 6.2 Strict Concurrency + Arquitectura Modular Real del Proyecto

Estas reglas se aplican a todo el repositorio. Copilot debe respetarlas
**en cada propuesta de código**, sin excepciones.

---

## 🧱 Estructura del Proyecto

Copilot debe comprender y respetar siempre estas capas:

```
ProjectName/
 ├─ App/                → Punto de entrada + NavigationStack root
 ├─ Features/           → Pantallas completas (cada feature es un módulo)
 ├─ Domain/             → Modelos puros + lógica de negocio
 ├─ Core/               → Core Data stack + utilidades base
 ├─ Services/           → Servicios de infraestructura (Network, Repos, Analytics)
 ├─ UI/                 → Componentes SwiftUI reutilizables
 ├─ Resources/          → Colors.xcassets, Assets, Localizables
 ├─ Tests/              → Tests unitarios
 └─ UITests/            → Tests UI
```

---

## 🧩 Principios Fundamentales

### 1. **Separación estricta UI / Lógica**
- Las **Views** nunca contienen lógica de negocio.
- Toda lógica reside en **ViewModels**, **Domain** o **Services**.
- Vistas → Inputs del usuario  
- ViewModels → Estados, eventos, side‑effects  
- Domain → Reglas puras, validaciones, entidades  
- Services → Infraestructura (persistencia, red, sistema)

---

## ⚙️ Concurrencia (Swift 6.2, modo estricto)

Copilot debe aplicar SIEMPRE:

- `@MainActor` en:
  - Views
  - ViewModels que mutan estado observado
- Servicios asíncronos con:
  - `async/await`
  - zero shared mutable state
- Evitar:
  - closures escapando sin `self`
  - `Task.detached` salvo necesidad explícita
  - Combine salvo código heredado

---

## 🗃 Persistencia y Core Data

- Todo el acceso a persistencia debe ir en:
  - `Core/Database/`
  - `Services/Repositories/`
- ViewModels nunca interactúan directamente con Core Data.
- Usar contenedores aislados para tests.
- No exponer `NSManagedObject` a la UI.
  - Transformar a modelos puros de Domain.

---

## 🌐 Servicios de Red

- Ubicar en `Services/Network/`.
- Arquitectura recomendada:
  - `NetworkClient` → capa base
  - Servicios concretos → `ExpenseService`, `UserService`, etc.
- Respuestas deben ser mapeadas a Domain, nunca usadas directamente en UI.

---

## 🧠 Domain Layer (Reglas de negocio)

- No depende de UI ni Core Data.
- Tipos puros (`struct`).
- Lógica testable y determinista.
- Modelos de Domain deben ser siempre inmutables.

---

## 🖥 ViewModels (Presentation Layer)

Copilot debe estructurarlos así:

```swift
@MainActor
final class SomethingViewModel: ObservableObject {
    @Published var state: SomethingState = .idle

    private let service: SomethingService
    init(service: SomethingService = .live) {
        self.service = service
    }

    func load() async { ... }
}
```

Reglas:
- Sin lógica de presentación en Services.
- Sin lógica de negocio compleja en View.
- Estados representados con enums (`idle`, `loading`, `loaded`, `error`).

---

## 🎨 UI Layer

- Views deben ser puras, declarativas, sin side‑effects.
- Colores deben provenir de:
  - `Resources/Colors.xcassets`
- Componentes reutilizables en:
  - `UI/Components/`

---

## 🧪 Testing Architecture

- Domain: tests 100% puros.
- Services: mocks y tests de comportamiento.
- ViewModels: tests de estados y side‑effects.
- UI tests: críticos y de navegación principal.

---

## 🧠 Uso de MCP

Copilot debe usar MCP solo cuando sea realmente necesario:

### Usar MCP para:
- errores de compilación complejos,
- logs voluminosos,
- build y tests automatizados.

### NO usar MCP para:
- errores triviales,
- cambios simples en vistas o ViewModels,
- accesos directos a rutas del proyecto sin necesidad.

---

## 🚦 Reglas Obligatorias para Copilot

- No inventar tipos, rutas o servicios.
- No modificar configuración de Xcode sin solicitud del usuario.
- Mantener compatibilidad con Swift 6.2 strict.
- Seguir las prácticas oficiales de Apple:
  - MainActor para UI
  - concurrency safety
  - arquitectura modular y testable
- No introducir dependencias externas innecesarias.

---

## 🎯 Objetivo

Copilot debe producir código que:
- compile a la primera,
- sea modular y mantenible,
- respete Swift 6.2,
- siga la arquitectura del proyecto,
- sea fácil de testear,
- y evolucione el proyecto sin introducir riesgos.

