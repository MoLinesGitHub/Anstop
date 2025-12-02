# Instrucciones para archivos de UI (SwiftUI)
### Optimizado para Copilot v3.2 — proyecto (Swift 6.2, arquitectura modular)

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

