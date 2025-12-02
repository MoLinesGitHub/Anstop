# Instrucciones para Gestión de Assets (Resources/)
### Optimizado para Copilot v3.2 — proyecto (Swift 6.2, arquitectura modular)

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
- `run_build_project`

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

