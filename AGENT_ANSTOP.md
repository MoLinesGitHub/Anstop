# 🤖 Agente Especializado para Anstop
## Automatización Completa de Build, Tests y Validación

---

## ✨ ¿Qué hace este agente?

El agente **"Agent for 'Anstop'"** es un asistente inteligente que **compila automáticamente** el proyecto sin pedir permiso, valida la arquitectura modular, detecta problemas de concurrencia Swift 6.2 y ejecuta tests relevantes.

### 🚀 Comportamiento Automático (Sin Preguntar)

Cuando detecta cambios o el usuario hace una consulta, el agente:

1. **✅ Compila automáticamente** el proyecto
2. **✅ Analiza errores** de Swift 6.2 strict concurrency
3. **✅ Valida arquitectura** modular (UI→VM→Domain→Services)
4. **✅ Detecta memory leaks** en Services/ViewModels
5. **✅ Ejecuta tests** relevantes según la capa modificada
6. **✅ Valida assets, localización y performance** cuando aplique

---

## 📋 Workflow Automático Completo

### 1️⃣ Estado Inicial
```
- Obtiene estado del proyecto (git, build, config)
- Detecta archivos modificados
- Identifica qué capa se modificó (UI/ViewModels/Domain/Services/Core)
```

### 2️⃣ Compilación Automática
```
- Ejecuta build sin preguntar
- Si falla: analiza errores con MCP especializado
- Si pasa: continúa con validaciones
```

### 3️⃣ Validación de Arquitectura
```
- Verifica separación de capas
- Detecta violaciones de flujo (UI→VM→Domain→Services)
- Valida que Domain es puro (sin UI ni infraestructura)
- Verifica inyección de dependencias correcta
```

### 4️⃣ Validación Swift 6.2
```
- Verifica @MainActor en Views y ViewModels
- Detecta accesos cruzados de actores
- Valida Sendable conformance
- Revisa Task/async/await correctos
```

### 5️⃣ Detección de Memory Leaks
```
- Si cambios en Services o ViewModels:
  * Detecta retain cycles
  * Analiza closures capturando self
  * Verifica weak/unowned correctos
```

### 6️⃣ Tests Automáticos
```
- Si cambios en lógica:
  * Ejecuta tests de la capa modificada
  * Analiza fallos
  * Sugiere fixes basados en arquitectura
```

### 7️⃣ Validaciones Adicionales
```
- Si cambios en UI:
  * Performance (re-renders, LazyVStack, prefetch)
  * Assets (colores, imágenes, dark mode)
  * Animaciones (explicit value-based)
  
- Si cambios en textos:
  * Strings hardcoded
  * Claves faltantes en Localizable.strings
```

### 8️⃣ Reporte Final
```
✅ BUILD STATUS: [SUCCESS/FAILED]

📊 RESUMEN:
- Archivos modificados: X
- Capa afectada: [UI/ViewModels/Domain/Services/Core]
- Errores: X
- Warnings: X
- Tests: X passed, Y failed

🚨 PROBLEMAS CRÍTICOS (prioridad 1)
⚠️  VIOLACIONES DE ARQUITECTURA (prioridad 2)
🔍 MEMORY LEAKS (prioridad 3)
⚡ OPTIMIZACIONES SUGERIDAS (prioridad 4)

📝 SIGUIENTE ACCIÓN RECOMENDADA
```

---

## 🎯 Reglas Específicas de Anstop

### Swift 6.2 Strict Concurrency
El agente **detecta y corrige**:
- ✅ @MainActor faltante en Views/ViewModels
- ✅ Accesos a @Published desde background threads
- ✅ Task.detached usado incorrectamente
- ✅ Sendable faltante en modelos compartidos
- ✅ Capturas de self en closures sin isolation

### Arquitectura Modular
El agente **valida**:
- ✅ UI → ViewModels (no acceso directo a Services)
- ✅ ViewModels → Domain + Services
- ✅ Domain → puro (sin UI ni infraestructura)
- ✅ Services → infraestructura (Core Data, Network, Analytics)
- ✅ Core → utilidades del sistema

**Prohibido:**
- ❌ UI accediendo directamente a Services
- ❌ Domain dependiendo de UI
- ❌ Services conociendo ViewModels
- ❌ Circular dependencies entre capas

### GlassKitPro
El agente **verifica**:
- ✅ `import GlassKitPro` presente
- ✅ Namespace correcto: `GlassKit.ComponentName`
- ✅ Opacidades suaves (0.15-0.25 para partículas)
- ✅ Componentes usados correctamente

### StoreKit 2
El agente **valida**:
- ✅ PurchaseManager usa async/await
- ✅ Transaction.updates manejado correctamente
- ✅ Actor isolation en compras
- ✅ Receipts validados

---

## 🛠 MCP Tools Disponibles

El agente tiene acceso a **15+ herramientas especializadas**:

### Compilación
- `anstop_build_project` - Build con validación de concurrency
- `xcode_build_project` - Build directo de Xcode
- `xcode_clean_project` - Limpia cache

### Análisis de Errores
- `analyze_swift_compilation_errors` - Errores Swift 6.2
- `analyze_xcode_build_logs` - Logs inteligentes
- `detect_memory_leaks` - Retain cycles

### Arquitectura
- `validate_architecture` - Separación de capas
- `validate_structure` - Estructura de carpetas
- `check_instructions` - Reglas de .github/instructions/

### Tests
- `run_tests` - Tests con análisis de fallos
- `anstop_run_tests` - Tests paralelos

### Optimización
- `optimize_performance` - Cuellos de botella
- `validate_localization` - Strings hardcoded
- `check_assets` - Assets faltantes

### Estado
- `anstop_project_status` - Estado completo

---

## 💡 Comportamiento Inteligente

### Caché de Estado
- Recuerda último build status
- Mantiene lista de archivos modificados
- Trackea tests que fallaron antes

### Predicción
- Cambio en ViewModel → ejecuta tests automáticamente
- Cambio en UI → valida assets y performance
- Cambio en Service → valida arquitectura y memory leaks

### Auto-Fix
- Imports faltantes: añade automáticamente
- @MainActor faltante: sugiere con diff
- Sendable faltante: propone conformance

---

## 🔄 Workflows Comunes

### Usuario Reporta Error
```
1. Compila inmediatamente (sin preguntar)
2. Analiza error con MCP específico
3. Identifica causa raíz
4. Propone fix con código
5. Aplica fix si usuario confirma
6. Re-compila automáticamente
7. Verifica que funcionó
```

### Usuario Pide Feature
```
1. Identifica capa(s) afectada(s)
2. Verifica arquitectura similar existente
3. Propone implementación modular
4. Genera código respetando arquitectura
5. Compila automáticamente
6. Sugiere tests necesarios
```

### Usuario Hace Cambios
```
1. Detecta qué archivos cambiaron
2. Compila automáticamente
3. Si falla: analiza y corrige
4. Si pasa: valida arquitectura
5. Ejecuta tests relevantes
6. Reporta estado
```

---

## 📈 Métricas de Éxito

El agente es exitoso si:
- ✅ Detecta problemas **antes** que el usuario
- ✅ Compila en primer intento 80% de las veces
- ✅ No pregunta innecesariamente
- ✅ Respeta arquitectura en todas las sugerencias
- ✅ Tests pasan después de cambios
- ✅ Zero violaciones de Swift 6.2 strict concurrency

---

## 🎨 Tono y Estilo

- **Proactivo:** Actúa sin pedir permiso
- **Preciso:** Errores con archivo:línea exactos
- **Educativo:** Explica POR QUÉ algo viola arquitectura
- **Constructivo:** Siempre propone solución, no solo reporta
- **Eficiente:** Un solo análisis completo, no múltiples pasadas

---

## 🚀 Cómo Usar el Agente

### Opción 1: Invocar Explícitamente
```
@Agent for 'Anstop' revisa el proyecto
```

### Opción 2: Automático en Contexto
El agente se activa automáticamente cuando:
- Estás en el workspace de Anstop
- Haces cambios en archivos Swift
- Reportas un error de compilación
- Pides una nueva feature

### Ejemplos de Uso

**Revisar Estado Completo:**
```
@Agent for 'Anstop' dame el estado del proyecto
```

**Después de Cambios:**
```
@Agent for 'Anstop' compila y valida
```

**Añadir Feature:**
```
@Agent for 'Anstop' añade una nueva vista de estadísticas
```

**Corregir Errores:**
```
@Agent for 'Anstop' hay errores de compilación, corrígelos
```

---

## 📦 Configuración

El agente está configurado en:
```
.github/agents/Agent for 'Anstop'.agent.md
```

### Personalización
Puedes modificar:
- Workflow de validación
- Reglas específicas del proyecto
- Tools MCP a usar
- Formato de reportes
- Umbrales de performance

---

## 🎯 Ventajas del Agente

### Para el Desarrollador:
- ⏱️ **Ahorra tiempo:** No esperas a compilar manualmente
- 🐛 **Detecta bugs temprano:** Antes de que rompan la app
- 📚 **Aprende:** Explica por qué algo es incorrecto
- 🎯 **Consistencia:** Siempre valida las mismas reglas
- 🧪 **Tests automáticos:** Se ejecutan cuando tiene sentido

### Para el Proyecto:
- 🏗️ **Arquitectura limpia:** Valida separación de capas
- 🔒 **Concurrency segura:** Zero data races
- 🚀 **Performance óptima:** Detecta problemas de UI
- 📱 **Calidad alta:** Tests pasan, assets correctos
- 🌍 **Localización completa:** Sin strings hardcoded

---

## 📝 Notas Importantes

### El agente NO pregunta para:
- ✅ Compilar el proyecto
- ✅ Ejecutar tests relevantes
- ✅ Analizar errores
- ✅ Validar arquitectura
- ✅ Detectar memory leaks

### El agente SÍ pregunta para:
- ⚠️ Aplicar fixes que modifican código
- ⚠️ Cambiar arquitectura existente
- ⚠️ Añadir nuevas dependencias
- ⚠️ Modificar configuración de Xcode

---

## 🔮 Roadmap Futuro

Mejoras planeadas:
- [ ] Sugerencias de refactoring automático
- [ ] Detección de code smells específicos de iOS
- [ ] Análisis de cobertura de tests
- [ ] Sugerencias de accessibility
- [ ] Integración con CI/CD
- [ ] Métricas de complejidad ciclomática

---

## 💬 Feedback

Si el agente:
- No detecta un problema → Reporta para mejorarlo
- Sugiere algo incorrecto → Explica por qué está mal
- Es demasiado verboso → Ajusta el formato de reporte
- Falta una validación → Añádela al workflow

---

**Última actualización:** 4 de Diciembre 2025  
**Versión:** 1.0  
**Proyecto:** Anstop  
**Swift:** 6.2 Strict Concurrency  

**¡El agente está listo para ayudarte a construir Anstop de forma más eficiente! 🚀**
