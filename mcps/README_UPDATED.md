# MCP Servers Actualizados - Proyecto Anstop

## 📅 Actualización: 1 Diciembre 2024

Los 3 MCP servers han sido actualizados para reflejar la **arquitectura modular real** del proyecto Anstop y las reglas definidas en `.github/instructions/`.

---

## 🎯 Cambios Principales

### 1. **anstop-dev-mcp** - Análisis y Validación

#### Herramientas Actualizadas:

1. **`analyze_swift_compilation_errors`**
   - ✅ Valida cumplimiento de **Swift 6.2 strict concurrency**
   - ✅ Analiza errores por **capa arquitectónica** (app, domain, services, etc.)
   - ✅ Detecta violaciones de `@MainActor` y `Sendable`

2. **`detect_memory_leaks`**
   - ✅ Análisis por capa (services, viewmodels, core)
   - ✅ Validación de `Sendable` protocol
   - ✅ Detección de retain cycles y actor isolation

3. **`validate_architecture`** (antes: validate_mcp_architecture)
   - ✅ Verifica separación estricta UI/Lógica/Domain/Services
   - ✅ Valida flujo de dependencias (UI→ViewModel→Domain/Services)
   - ✅ Comprueba reglas de concurrency (@MainActor en Views/ViewModels)
   - ✅ Asegura pureza del Domain layer

4. **`run_tests`** (antes: run_automated_feature_tests)
   - ✅ Ejecuta AnstopTests y AnstopUITests
   - ✅ Análisis de fallos basado en arquitectura
   - ✅ Genera reportes de cobertura opcionales

5. **`optimize_performance`** (antes: optimize_anstop_performance)
   - ✅ Valida reglas de `ui.instructions.md`
   - ✅ Detecta re-renderizados innecesarios en SwiftUI
   - ✅ Verifica uso de `.animation(_:value:)` explícito
   - ✅ Sugiere uso de Instruments (Time Profiler, SwiftUI, Leaks)

6. **`validate_localization`** (NUEVA)
   - ✅ Detecta strings hardcoded en Views
   - ✅ Valida claves en Localizable.strings
   - ✅ Comprueba idiomas (es, en)

7. **`check_assets`** (NUEVA)
   - ✅ Valida referencias a Colors.xcassets
   - ✅ Verifica imágenes en Assets.xcassets
   - ✅ Comprueba soporte de dark mode
   - ✅ Valida accessibilityLabel localizados

#### Configuración Actualizada:

```typescript
const ANSTOP_PROJECT_ROOT = '/Volumes/SSD/xCode_Projects/Anstop';
const ANSTOP_STRUCTURE = {
  app: 'Anstop/App',
  features: 'Anstop/Features',
  domain: 'Anstop/Domain',
  core: 'Anstop/Core',
  services: 'Anstop/Services',
  ui: 'Anstop/UI',
  resources: 'Anstop/Resources',
  tests: 'AnstopTests',
  uiTests: 'AnstopUITests',
  instructions: '.github/instructions'
};
```

---

### 2. **anstop-env-mcp** - Entorno y Build

#### Herramientas Actualizadas:

1. **`anstop_project_status`**
   - ✅ Incluye información de arquitectura modular
   - ✅ Muestra capas (App, Features, Domain, Core, Services, UI)
   - ✅ Indica versión de Swift (6.2 strict concurrency)

2. **`anstop_build_project`**
   - ✅ Usa `.xcworkspace` por defecto
   - ✅ Analiza errores de concurrency automáticamente
   - ✅ Sugiere revisar `.github/instructions/swift.instructions.md`

3. **`anstop_run_tests`**
   - ✅ Soporta targets específicos (AnstopTests, AnstopUITests)
   - ✅ Ejecución paralela de tests
   - ✅ Reportes con estadísticas (pasados/fallidos)

4. **`anstop_validate_structure`** (NUEVA)
   - ✅ Valida presencia de todas las carpetas de arquitectura
   - ✅ Detecta carpetas faltantes
   - ✅ Muestra estructura completa del proyecto

5. **`anstop_check_instructions`** (NUEVA)
   - ✅ Valida archivos en `.github/instructions/`
   - ✅ Comprueba existencia de todas las reglas
   - ✅ Muestra tamaño de cada archivo de instrucciones

6. **`anstop_deploy_prepare`**
   - ✅ Valida CHECKLIST.md antes de deployment
   - ✅ Soporta TestFlight y App Store
   - ✅ Actualiza Info.plist automáticamente
   - ✅ Muestra items pendientes en checklist

#### Configuración Actualizada:

```typescript
const CORTES_CONFIG = {
  projectPath: '/Volumes/SSD/xCode_Projects/Anstop',
  xcodeProject: '/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcodeproj',
  xcodeWorkspace: '/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcworkspace',
  paths: {
    app: 'Anstop/App',
    features: 'Anstop/Features',
    domain: 'Anstop/Domain',
    // ... todas las capas
  }
};
```

**Herramientas Eliminadas:**
- ❌ `anstop_create_client` (no relacionado con desarrollo)
- ❌ `anstop_analytics_report` (no relacionado con desarrollo)

---

### 3. **xcode-mcp** - Gestión de Xcode

#### Herramientas Actualizadas:

1. **`xcode_build_project`**
   - ✅ Optimizado para Anstop con workspace
   - ✅ Valores por defecto para Anstop.xcworkspace
   - ✅ Scheme "Anstop" y device "iPhone 16 Pro" preconfigurados

2. **`xcode_run_tests`**
   - ✅ Soporta targets específicos (AnstopTests, AnstopUITests, all)
   - ✅ Ejecución paralela de tests
   - ✅ Configuración por defecto para Anstop

#### Configuración Específica para Anstop:

```typescript
const CORTES_CONFIG = {
  projectPath: '/Volumes/SSD/xCode_Projects/Anstop',
  projectFile: '/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcodeproj',
  workspaceFile: '/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcworkspace',
  schemeName: 'Anstop',
  defaultDevice: 'iPhone 16 Pro'
};
```

---

## 🚀 Uso de los MCPs

### Desde GitHub Copilot CLI:

Los MCPs están automáticamente disponibles cuando trabajas en el proyecto Anstop.

#### Ejemplos:

**Validar arquitectura:**
```
¿La arquitectura de Anstop cumple con las reglas?
```
→ Usa `anstop-dev-mcp` → `validate_architecture`

**Compilar el proyecto:**
```
Compila Anstop en Debug
```
→ Usa `anstop-env-mcp` → `anstop_build_project`

**Ejecutar tests:**
```
Ejecuta los tests unitarios
```
→ Usa `xcode-mcp` → `xcode_run_tests` con `test_target: AnstopTests`

**Validar localización:**
```
¿Hay strings hardcoded en las vistas?
```
→ Usa `anstop-dev-mcp` → `validate_localization`

**Preparar para TestFlight:**
```
Prepara deployment versión 1.0.1
```
→ Usa `anstop-env-mcp` → `anstop_deploy_prepare`

---

## 📋 Alineación con .github/instructions/

Los MCPs ahora están **100% alineados** con las reglas definidas en:

- ✅ `architecture.instructions.md` - Validación de capas y dependencias
- ✅ `swift.instructions.md` - Concurrency, logging, seguridad
- ✅ `ui.instructions.md` - Performance, animaciones, prefetch
- ✅ `services.instructions.md` - Repositorios, networking, Core Data
- ✅ `domain.instructions.md` - Pureza, validaciones, use cases
- ✅ `tests.instructions.md` - ViewModels, persistence, UI tests
- ✅ `assets.instructions.md` - Colores, imágenes, dark mode
- ✅ `localization.instructions.md` - Strings, placeholders, accesibilidad

---

## ✅ Build Status

**Todos los MCPs compilados exitosamente:**

```bash
✅ anstop-dev-mcp build: OK
✅ anstop-env-mcp build: OK
✅ xcode-mcp build: OK
```

---

## 🎯 Próximos Pasos

1. **Comenzar a programar la aplicación** con los MCPs actualizados
2. Los MCPs ahora validan automáticamente:
   - Swift 6.2 strict concurrency
   - Arquitectura modular
   - Separación de capas
   - Localización
   - Assets y colores
   - Performance de SwiftUI

3. **GitHub Copilot CLI** usará estos MCPs cuando sea necesario:
   - Análisis de errores complejos
   - Validación de arquitectura
   - Ejecución de tests
   - Preparación de deployment

---

## 📝 Notas Técnicas

- **Límite de tokens:** Los logs de build se truncan automáticamente a ~60k caracteres (~20k tokens) para evitar errores MCP
- **Workspace por defecto:** Se usa `.xcworkspace` en lugar de `.xcodeproj` para manejar dependencias
- **Tests paralelos:** Habilitados por defecto para acelerar ejecución
- **Análisis automático:** Los errores de concurrency se detectan y clasifican automáticamente

---

## 🔄 Changelog

### v1.1.0 - 1 Diciembre 2024

#### anstop-dev-mcp:
- Actualizada configuración a rutas reales del proyecto
- 2 herramientas nuevas: `validate_localization`, `check_assets`
- Renombradas herramientas para mayor claridad
- Alineación con `.github/instructions/`

#### anstop-env-mcp:
- Actualizada configuración de paths modulares
- 2 herramientas nuevas: `anstop_validate_structure`, `anstop_check_instructions`
- Eliminadas 2 herramientas no relacionadas con desarrollo
- Mejorado análisis de errores de build
- Validación de CHECKLIST.md en deployment

#### xcode-mcp:
- Configuración específica para Anstop
- Soporte mejorado de workspace
- Tests paralelos por defecto
- Valores por defecto optimizados para el proyecto

---

**¡Los MCPs están listos para empezar a programar Anstop! 🚀**
