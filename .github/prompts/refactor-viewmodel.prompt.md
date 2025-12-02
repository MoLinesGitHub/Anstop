---
name: /refactor-viewmodel
description: Refactoriza ViewModels para hacerlos limpios, testables y seguros con concurrencia
---

# Refactor profesional de ViewModels (Swift 6.2 • MainActor • Architecture)

## Objetivo
Transformar un ViewModel confuso o demasiado grande en una estructura limpia, estable, testable y alineada con la arquitectura.

## Acciones que debe realizar Copilot

1. Revisar errores comunes:
   - demasiadas responsabilidades
   - states mezclados
   - lógica de UI incrustada
   - llamadas directas al servicio desde la vista
   - métodos demasiado largos
   - falta de aislamiento de MainActor
   - excesivo uso de closures

2. Reestructurar ViewModel:
   - aplicar `@MainActor`
   - mover lógica pesada a servicios o domain
   - organizar propiedades como estados claros
   - eliminar dependencia circular UI ↔ ViewModel
   - dividir métodos grandes en funciones pequeñas
   - eliminar side effects

3. Validar integridad:
   - asegurar que la vista no se rompe
   - mantener interfaz pública del ViewModel
   - proponer TestCases adicionales

4. MCP opcional:
   - usar `run_build_project` si el refactor origina errores
   - analizar errores con `analyze_swift_compilation_errors`

## Resultado esperado
Un ViewModel simplificado, seguro y preparado para strict concurrency.
