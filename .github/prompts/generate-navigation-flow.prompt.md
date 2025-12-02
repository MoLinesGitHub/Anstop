---
name: /generate-navigation-flow
description: Crea flujos de navegación completos usando NavigationStack y ViewModels
---

# Generación de flujos de navegación completos (NavigationStack • arquitectura)

## Objetivo
Crear un flujo de pantallas completamente estructurado usando NavigationStack, ViewModels y datos del dominio.

## Acciones que debe realizar Copilot

1. Crear estructura del flujo:
   ProjectName/
     ├─ UI/
     │   ├─ ScreenAView.swift
     │   ├─ ScreenBView.swift
     │   └─ ScreenCView.swift
     ├─ ViewModels/
     │   ├─ ScreenAViewModel.swift
     │   ├─ ScreenBViewModel.swift
     │   └─ ScreenCViewModel.swift
     └─ Domain/
         └─ FlowNameModels.swift

2. Reglas:
   - cada pantalla con su propio ViewModel
   - navegación declarativa (`NavigationLink` o `navigationDestination`)
   - estado del flujo en ViewModel principal
   - operaciones async en ViewModel, nunca en la View
   - modelos puros Sendable

3. Integración:
   - generar ejemplo de cómo invocar el flujo desde el `root NavigationStack`
   - opcional: agregar test de navegación

4. No romper arquitectura:
   - sin global state
   - sin Singletons
   - sin lógica en la vista

## Resultado esperado
Un flujo de navegación modular, escalable y completamente integrado en la arquitectura.
