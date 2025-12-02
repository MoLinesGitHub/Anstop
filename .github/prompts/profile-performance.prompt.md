---
name: /profile-performance
description: Detecta cuellos de botella y optimiza rendimiento en Views, ViewModels y Services
---

# Perfilado y optimización de rendimiento (SwiftUI + Services + Domain)

## Objetivo
Detectar cuellos de botella en:
- Views
- ViewModels
- Domain transforms
- Services async

## Acciones que debe realizar Copilot
1. Localizar problemas típicos:
   - operaciones pesadas dentro del body
   - sincronizaciones innecesarias en MainActor
   - usos incorrectos de Task
   - accesos a servicios dentro de la vista
   - estructuras mutables en Domain

2. Proponer mejoras:
   - mover cálculos al ViewModel
   - usar `Task(priority:)` de forma explícita
   - descomponer vistas complejas
   - reorganizar async/await para eliminar bloqueos

3. Integración con MCP opcional:
   - pegar logs de Time Profiler
   - analizar build logs si hay warnings de rendimiento

## Resultado esperado
Rendimiento estable, menos recomputaciones y un flujo async seguro.
