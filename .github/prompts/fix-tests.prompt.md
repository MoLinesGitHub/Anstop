---
name: /fix-tests
description: Investigar y arreglar tests fallidos en Cortes usando MCP
---

# Fix Tests - Arregla tests fallidos

Tengo tests fallando en Cortes.

1. Usa el tool `cortes_run_tests` con `testType: "unit"` para obtener el estado actual de los tests y resumir solo los fallidos.
2. Si estoy editando un archivo de tests concreto:
   - Explica qué está comprobando el test (o tests) que falla en ese archivo.
   - Relaciónalo con el código de producción afectado (ViewModels, Services, Repositories).
3. Propón cambios mínimos en código o en los propios tests para que el comportamiento sea coherente, manteniendo el estilo actual del proyecto.
4. Sugiere uno o varios comandos de tests para revalidar (por ejemplo `cortes_run_tests` de nuevo o tests de una feature concreta con `run_automated_feature_tests`).
