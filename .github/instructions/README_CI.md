# Guía de CI/CD — proyecto (GitHub Actions)
### iOS • Swift 6.2 • Xcode 26.1 • TestFlight • PR checks

Este documento explica todos los workflows del repositorio de.

---

# 🏗 CI/CD GENERAL

La carpeta:

.github/workflows/

contiene los workflows que automatizan:

- validación de pull requests  
- build del proyecto  
- ejecución de tests  
- publicación de releases  
- generación de builds para TestFlight  
- análisis estático (SwiftLint / SwiftFormat)  
- cache inteligente de SwiftPM (3× más rápido)  

---

# 🧪 1. `ci.yml`
### Propósito
Pipeline general para:

- compilar iOS (simulador + dispositivo real)  
- ejecutar tests  
- validar sintaxis Swift 6.2  
- ejecutar SwiftLint + SwiftFormat  
- cachear dependencias SPM  
- impedir merges con errores  

### Incluye:
- Xcode 26.1  
- targets de iPhone 16e, iPhone 15 Pro y iPhone X  
- strict concurrency  
- build incremental  

---

# 🔍 2. `pr.yml`
### Propósito
Validar Pull Requests con:

- SwiftLint  
- SwiftFormat  
- tests  
- análisis incremental  
- comentarios automáticos  

Incluye:
- anotaciones sobre estilo  
- detección de APIs deprecated  
- bloqueo automático si falla cualquier check  

---

# 🚀 3. `release.yml`
### Propósito
Automatizar:

- tagging automático  
- generación de release notes  
- creación de versión firmada  
- compilación para distribución  
- subida del .ipa a TestFlight (si está activado)

### Mejoras incluidas:
- versiones semánticas  
- notas de cambios automáticas  
- archivado reproducible  
- reutilización del cache SPM  

---

# 📦 CACHÉ DE SWIFTPM

Todos los workflows incluyen:

~/.build
~/.swiftpm

Esto acelera:
- compilar  
- lint  
- tests  
- release builds  

---

# 🛡 NORMAS DE SEGURIDAD

- ninguna release se crea sin que **ci.yml** pase  
- los PR deben tener:
  - tests pasando  
  - SwiftLint limpio  
  - formato corregido  
- no se permiten merges con warnings críticos  

---

# 🎯 OBJETIVO FINAL DE CI/CD

Garantizar que el proyecto:
- se construye de forma estable  
- es testado automáticamente  
- sigue estándares de Apple  
- entrega builds reproducibles  
- ofrece releases limpias y trazables  
- está preparado para TestFlight y App Store  
