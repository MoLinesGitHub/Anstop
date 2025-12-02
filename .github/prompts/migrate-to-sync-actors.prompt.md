---
name: /migrate-to-sync-actors
description: Migra servicios y estados compartidos a actores Swift 6.2 con strict concurrency
---

# Migración a Actores Swift 6.2 (strict concurrency)

## Objetivo
Convertir servicios y estados compartidos en actores seguros para concurrencia, sin romper la arquitectura Cortes.

## Acciones que debe realizar Copilot
1. Identificar:
   - estados compartidos
   - servicios que manejan caché o datos mutables
   - repositorios que escriben en memoria

2. Migrar a actores:
   - crear `actor` para responsabilidades compartidas
   - añadir métodos async seguros
   - evitar `nonisolated` salvo casos justificados

3. Mantener contrato existente:
   - las Views NO deben conocer actores directamente
   - los ViewModels deben recibir dependencias ya migradas

4. Validación:
   - ejecutar MCP con `cortes_build_project` si hay errores de concurrencia
   - corregir anotaciones @MainActor y Sendable

## Resultado esperado
Servicios seguros, libres de data races, y compatibles con Swift 6.2.
