# name: project-health
# description: Revisa el estado general del proyecto (build, tests y warnings)

## Goals

- Verificar rápidamente:
  - Si la build funciona en Debug.
  - Si los tests unitarios y de integración pasan.
  - Si hay errores o warnings importantes en el build log.
- Proponer una lista priorizada de acciones.

## Steps (high level)

1. Ejecutar el tool `build_project` (Debug, clean=false) y recoger el resultado del build.
2. Ejecutar el tool `run_tests` con `testType: "unit"` para conocer el estado de los tests.
3. Usar `analyze_xcode_build_logs` y/o `analyze_swift_compilation_errors` para:
   - Resumir errores y warnings principales del último build log.
4. Preparar un informe con:
   - Estado de build.
   - Estado de tests.
   - Lista de problemas ordenados por impacto.
   - Siguiente acción recomendada para cada uno.
