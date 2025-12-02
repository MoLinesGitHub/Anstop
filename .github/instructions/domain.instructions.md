# Instrucciones del Domain Layer (Domain/)
### Optimizado para Copilot v3.2 — Swift 6.2 Strict Concurrency + arquitectura

El dominio es el **corazón de la app**. Contiene las reglas de negocio, modelos puros y comportamientos esenciales del sistema.

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

