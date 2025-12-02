---
name: /optimize-swiftui
description: Optimiza vistas SwiftUI eliminando re-renderizados y mejorando rendimiento
---

# Optimización avanzada de SwiftUI (Swift 6.2 • Strict Concurrency •)

## Objetivo
Optimizar vistas SwiftUI eliminando recomputaciones, re-renderizados innecesarios y estados incorrectos.

## Acciones que debe realizar Copilot
1. Detectar problemas típicos:
   - uso incorrecto de @State, @Binding, @StateObject, @ObservedObject
   - body demasiado complejo
   - cálculos pesados dentro del body
   - vistas que no son `Equatable`
   - subcomponentes que deberían ser estructurados en archivos separados
   - problemas de rendimiento con listas

2. Aplicar mejoras:
   - convertir vistas a `@MainActor` cuando proceda
   - extraer subcomponentes puros
   - aplicar `.transaction`, `.animation(nil)` o `.drawingGroup()` según proceda
   - usar `EquatableView` cuando sea seguro
   - eliminar closures capturando self sin necesidad
   - mover lógica del body al ViewModel

3. Sugerir modificaciones mínimas:
   - pequeño diff por archivo
   - sin reescribir vistas completas

4. Usar MCP si la vista tiene errores que impidan compilar:
   - run_build_project
   - analyze_swift_compilation_errors

## Resultado esperado
Una vista SwiftUI más rápida, estable y mantenible, sin alterar el comportamiento original.
