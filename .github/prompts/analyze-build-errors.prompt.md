---
name: /analyze-build-errors
description: Analiza errores de compilación en usando MCP y propone correcciones precisas
---

# Análisis profesional de errores de compilación (Swift 6.2 • Xcode 26.1 • MCP)

## Objetivo
Identificar la causa raíz de errores de compilación, con diagnóstico preciso y plan de corrección mínimo.

## Acciones que debe realizar Copilot

1. Ejecutar MCP:
   - llamar a `run_build_project`
   - obtener logs completos
   - pasar los logs a `analyze_swift_compilation_errors`

2. Identificar:
   - errores de tipo
   - errores strict concurrency
   - actores mal aislados
   - problemas de Sendable
   - imports faltantes
   - dependencias rotas después de un refactor

3. Proponer solución:
   - entregar diffs pequeños
   - corregir solo lo necesario
   - no reescribir archivos enteros
   - si hay múltiples causas, indicar orden correcto de reparación

4. Validación:
   - sugerir correr tests unitarios después
   - validar que UI no se ve afectada

## Resultado esperado
Corrección precisa con impacto mínimo y explicación clara del error.
