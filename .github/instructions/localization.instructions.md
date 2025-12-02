# Instrucciones de Localización (Proyecto Cortes)
### Optimizado para Copilot v3.2 — Swift 6.2 + Arquitectura Modular + Localizable.strings

Estas reglas aplican a toda la localización del proyecto, incluyendo:
- `Resources/Localizable.strings`
- `Resources/<Idioma>.lproj/`
- Textos en Views, ViewModels y Domain cuando aplique.

---

## 🌍 Objetivo
Copilot debe garantizar que **toda la app Cortes es completamente localizable**, sin strings hard-coded y siguiendo buenas prácticas de iOS modernas.

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

