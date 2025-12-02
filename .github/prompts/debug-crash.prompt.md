---
name: /debug-crash
description: Analiza crashes y stacktraces para encontrar la causa raíz
---

# Diagnóstico de crashes

## Objetivo
Analizar crashes reales y encontrar la causa raíz de forma precisa.

## Acciones
1. Revisar stacktrace:
   - función exacta del fallo
   - hilo que provocó el crash
2. Identificar:
   - nil inesperado
   - index out of bounds
   - race conditions
   - actor isolation violations
3. Proponer corrección mínima y segura.
4. Validar con MCP opcionalmente.

## Resultado esperado
Corrección estable que elimina el crash sin afectar arquitectura.
