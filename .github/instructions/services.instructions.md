# Instrucciones para Servicios (Services/)
### Optimizado para Copilot v3.2 — Swift 6.2 Strict Concurrency + arquitectura

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
  - `run_run_tests`
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

