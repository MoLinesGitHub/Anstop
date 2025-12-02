# Instrucciones para archivos de tests (CortesTests, CortesUITests)
### Optimizado para arquitectura del proyecto Cortes + Swift 6.2

## 📌 Alcance
Estas reglas se aplican a todos los tests en:
- `CortesTests/` (unit tests)
- `CortesUITests/` (UI automation)

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
- No depender de la UI salvo en `CortesUITests`.
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

## 📱 Tests de UI (CortesUITests)
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
  - `cortes_run_tests`
  - `analyze_xcode_build_logs`

Siempre priorizar **resolver localmente primero**.

