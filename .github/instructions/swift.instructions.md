# Instrucciones específicas para archivos Swift en  
### Optimizado para Swift 6.2, arquitectura modular y MCP activos

Estas instrucciones aplican a **todos los archivos `.swift`** del repositorio, incluyendo:
- `ProjectName/App/`
- `ProjectName/Features/`
- `ProjectName/Domain/`
- `ProjectName/Core/`
- `ProjectName/Services/`
- `ProjectName/UI/`
- `ProjectName/Resources/`
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
- `run_build_project`
- `run_run_tests`
- `detect_memory_leaks`
- `optimize_run_performance`

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
