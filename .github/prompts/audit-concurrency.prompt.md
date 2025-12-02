---
name: /audit-concurrency
description: Revisa problemas de strict concurrency en todo el proyecto
---

# Auditoría de concurrencia

## Objetivo
Detectar violaciones strict concurrency.

## Acciones
1. Detectar:
   - acceso a estado no aislado
   - tipos no-Sendable
   - uso incorrecto de Task
2. Proponer correcciones
3. Validar con MCP

## Resultado esperado
Concurrencia segura al 100%.
