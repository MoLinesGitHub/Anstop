---
name: /clean-architecture-audit
description: Audita la arquitectura del proyecto para detectar violaciones y proponer mejoras
---

# Auditoría completa de arquitectura (UI / ViewModel / Domain / Services)

## Objetivo
Revisar estructura de archivos, responsabilidades y dependencias para garantizar que mantiene arquitectura limpia.

## Acciones que debe realizar Copilot
1. Detectar violaciones:
   - lógica de dominio en Views
   - lógica de UI dentro de Services
   - modelos mezclados con Core Data
   - dependencias circulares
   - ViewModels demasiado complejos

2. Proponer correcciones:
   - separar responsabilidades
   - refactorizar carpetas mal ubicadas
   - sugerir `UseCases` cuando simplifiquen lógica
   - convertir tipos incorrectos en structs sendables

3. Validar build y estructura:
   - opcional: usar MCP para compilar
   - sugerir nuevos tests en Domain y ViewModel

## Resultado esperado
Arquitectura sólida, mantenible, con capas bien aisladas y código limpio.
