# Guía de MCP Servers — proyecto
### Arquitectura avanzada: Swift 6.2 + CI/CD + Análisis Automático

Este documento describe el sistema MCP (Model Context Protocol) integrado en, y cómo Copilot debe utilizarlos para análisis avanzados sin interferir con el flujo normal de desarrollo.

---

# 📦 MCP SERVERS DISPONIBLES

En la carpeta:

mcps/

existen **tres MCP servers especializados** que amplían las capacidades de Copilot.

---

## 🧠 1. `dev-mcp`
### Propósito
Análisis profundo del estado del proyecto:

- errores de compilación complejos  
- logs de build voluminosos  
- diagnósticos encadenados  
- análisis de concurrencia  
- fallos que no se pueden reproducir desde un solo archivo  

### Cuando usarlo
Copilot debe llamar a este MCP cuando:

- el log sea más grande que una pantalla  
- los errores sean múltiples y conectados  
- la causa raíz no sea evidente  

---

## 🧪 2. `env-mcp`
### Propósito
Automatizar operaciones habituales del entorno:

- ejecutar tests (unitarios y UI)
- construir el proyecto fuera de Xcode
- validar configuraciones de targets
- limpiar entorno de build

### Cuando usarlo
- antes de merges grandes  
- tras un refactor que toque varias capas  
- cuando Copilot no esté seguro del resultado final  

---

## 📱 3. `xcode-mcp`
### Propósito
Interacción directa con Xcode desde CLI:

- `xcodebuild`  
- `archive` para TestFlight  
- `clean build`  
- inspección del `.xcodeproj`  
- validación de info.plist  

### Cuando usarlo
- para generar versiones firmadas  
- para validar que CI usará la config correcta  
- para verificar targets o configuraciones corruptas  

---

# ⚙️ NORMAS DE USO PARA COPILOT

Copilot debe:

1. **Priorizar resolver localmente** siempre que sea posible.  
2. **Usar MCP solo cuando:**
   - el error sea masivo,
   - se requiera build real,
   - el usuario lo ordene,
   - el análisis manual no sea viable.  
3. **Nunca abusar de MCP** porque ralentiza la productividad.  
4. **Indicar qué MCP va a usar y por qué**.  

---

# 🔐 PERMISOS Y SEGURIDAD

Los MCP:
- no pueden borrar archivos  
- no pueden modificar la estructura del proyecto  
- no tienen acceso fuera de la carpeta `mcps/`  

---

# 🎯 OBJETIVO FINAL DEL MCP

Ofrecer a:

- diagnósticos avanzados  
- builds reproducibles  
- detección de problemas imposibles de ver desde el editor  
- integración inteligente con Copilot v3.2  
