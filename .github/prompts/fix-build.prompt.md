---
name: /fix-build
description: Analiza y corrige errores de compilación en Cortes usando MCP
---

# Fix Build - Corrige errores de compilación

Tengo errores de compilación en el proyecto Cortes.

1. Lanza, si es necesario, el tool `cortes_build_project` en configuración Debug (sin clean) para generar o actualizar el build log.
2. Usa `analyze_swift_compilation_errors` y/o `analyze_xcode_build_logs` para:
   - Resumir los errores principales.
   - Explicar la causa probable.
   - Proponer cambios concretos en los archivos afectados, priorizando el archivo actual si aplica.
3. Indica qué tests debería ejecutar después para verificar la corrección (por ejemplo `xcodebuild test` o tests de una feature concreta).
