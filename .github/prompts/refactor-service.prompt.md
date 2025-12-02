---
name: /refactor-service
description: Refactoriza servicios para mejorar testabilidad y strict concurrency
---

# Refactor de servicios (Swift 6.2)

## Objetivo
Reestructurar servicios complejos para hacerlos más seguros, limpios y testables.

## Acciones
1. Identificar:
   - responsabilidad múltiple
   - acceso mutable inseguro
   - lógica mezclada con UI o ViewModels
2. Refactorizar:
   - extraer protocolos
   - crear mocks
   - convertir a actor si procede
   - mover transformaciones al Domain
3. Validar:
   - tests de servicio
   - uso correcto desde ViewModels

## Resultado esperado
Servicios robustos, aislados y compatibles con concurrencia moderna.
