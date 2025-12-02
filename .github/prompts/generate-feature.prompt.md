---
name: /generate-feature
description: Genera una nueva feature completa siguiendo la arquitectura modular del proyecto
---

# Generación completa de nuevas Features según arquitectura

## Objetivo
Crear una nueva Feature siguiendo:
- separación: UI / ViewModel / Domain / Services
- Swift 6.2 strict concurrency
- estructura real del proyecto

## Acciones que debe realizar Copilot
1. Crear árbol de archivos:
   FeatureName/
     ├─ UI/
     │   └─ FeatureNameView.swift
     ├─ ViewModel/
     │   └─ FeatureNameViewModel.swift
     ├─ Domain/
     │   └─ FeatureNameModel.swift
     └─ Services/
         └─ FeatureNameService.swift

2. Aplicar reglas internas:
   - modelos puros (Sendable, Equatable)
   - ViewModel `@MainActor`
   - servicios async/await
   - cero lógica en las vistas

3. Añadir tests:
   - Domain
   - ViewModel (uso de mocks)
   - Service (si aplica)

4. Integración:
   - generar ejemplo de navegación con NavigationStack
   - insertar entrada temporal en el router del proyecto

## Resultado esperado
Una Feature lista para compilar, con arquitectura limpia y archivos mínimos sin artificios.
