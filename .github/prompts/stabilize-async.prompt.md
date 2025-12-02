---
name: /stabilize-async
description: Estabiliza flujos async/await, elimina race conditions y asegura strict concurrency
---

# Estabilización de flujos async/await (Swift 6.2)

## Objetivo
Detectar y corregir problemas de concurrencia, bloqueo o inestabilidad en flujos async.

## Acciones
1. Identificar:
   - awaits incorrectos
   - operaciones en MainActor innecesarias
   - race conditions
   - llamadas concurrentes inseguras
2. Proponer mejoras:
   - aislar actores correctamente
   - fijar prioridades de Task
   - reestructurar flujos async
3. Validar con MCP si hay errores:
   - cortes_build_project
   - analyze_swift_compilation_errors

## Resultado esperado
Flujos async predecibles, seguros y compatibles con Swift 6.2 strict concurrency.
