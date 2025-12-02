# Guía de Instrucciones Avanzadas para GitHub Copilot — proyecto
### Arquitectura modular • Swift 6.2 strict concurrency • MCP Servers integrados

Este documento resume el sistema completo de agentes, reglas e instrucciones que gobiernan cómo GitHub Copilot v3.2 debe comportarse dentro del proyecto.

Su objetivo es garantizar:
- código seguro y sin alucinaciones,
- arquitectura limpia,
- uso correcto de Swift 6.2 strict,
- comunicación clara con MCP,
- consistencia total entre todas las capas del proyecto.

---

## 📦 ESTRUCTURA DE INSTRUCCIONES

Todas las reglas están organizadas por ámbito dentro de:

.github/instructions/

Y contienen:

- **architecture.instructions.md** — reglas globales de arquitectura
- **swift.instructions.md** — comportamiento base del lenguaje
- **ui.instructions.md** — reglas de Views y SwiftUI
- **services.instructions.md** — reglas de infraestructura
- **domain.instructions.md** — modelos puros + lógica de negocio
- **assets.instructions.md** — colores, imágenes, recursos
- **localization.instructions.md** — localización y accesibilidad
- **tests.instructions.md** — guía de testing moderno
- **copilot-instructions.md** — reglas globales y comportamiento del agente

Cada archivo actúa como un **agente especializado**, y Copilot debe combinar su contenido según el contexto del archivo que el usuario edite.

---

## 🧠 MCP SERVERS INTEGRADOS

En `mcps/` existen tres MCP activos y autorizados:

### 1. **dev-mcp**
Enfocado en:
- análisis de errores complejos
- logs de compilación grandes
- diagnósticos encadenados
- análisis de fallos de concurrencia

### 2. **env-mcp**
Permite:
- ejecutar tests
- construir el proyecto desde CLI
- validar estados del entorno

### 3. **xcode-mcp**
Permite:
- build/clean/archive sin abrir Xcode
- inspección del proyecto
- validar configuración de targets

Copilot solo debe invocar MCP cuando:
- el error sea grande o no evidente,
- el usuario lo solicite explícitamente,
- la build del usuario no pueda reproducirse localmente.

---

## 🧩 PRINCIPIOS CLAVE QUE COPILOT DEBE OBEDECER

### 1. Swift 6.2 strict concurrency
- `@MainActor` donde toque
- evitar `Task.detached`
- evitar acceso cruzado entre hilos
- evitar Combine salvo código heredado

### 2. Arquitectura modular real
- UI → Views puras
- ViewModels → Presentation
- Domain → modelos puros
- Services → infraestructura
- Core → utilidades del sistema
- Resources → assets y localización

### 3. Cambios mínimos
Copilot debe:
- evitar reescrituras grandes
- proponer diffs pequeños
- mantener limpieza y estabilidad

### 4. Testabilidad
Cada cambio debe pensar en:
- cómo se testea
- qué test debe actualizarse
- qué casos podrían romperse

Estos criterios están reforzados en `tests.instructions.md`.

---

## 🎨 ASSETS Y LOCALIZACIÓN

Copilot debe seguir:
- colores en `Resources/Colors.xcassets`
- imágenes en `Resources/Assets.xcassets`
- textos en `Resources/Localizable.strings`
- reglas de accesibilidad del proyecto

Nunca debe generar:
- hex arbitrarios
- strings hard-coded
- rutas absolutas
- nombres inventados

---

## 🔧 INSTRUCCIONES PARA INTERACCIÓN

Copilot debe:
- responder en español técnico
- ser conciso
- pedir datos solo cuando realmente falten
- nunca inventar rutas, tipos o servicios
- evitar modificar la configuración de Xcode salvo orden explícita

---

## 🎯 OBJETIVO DEL SISTEMA DE INSTRUCCIONES

Garantizar que el proyecto se desarrolla bajo estándares profesionales:

- mantenible
- robusto
- testable
- consistente
- seguro con concurrencia
- compatible con CI/CD (incluyendo TestFlight)
- alineado con las guías oficiales de Apple
