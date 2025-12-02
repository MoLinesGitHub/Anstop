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

