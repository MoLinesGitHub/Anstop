# Anstop Environment MCP

Servidor MCP (Model Context Protocol) específico para el proyecto **Anstop** - aplicación iOS de gestión de clientes para profesionales del masaje terapéutico.

## Descripción

Este MCP proporciona herramientas especializadas para el desarrollo, testing y deployment del proyecto Anstop, optimizando el flujo de trabajo con capacidades específicas del dominio de masaje terapéutico.

## Características

### 🔧 Herramientas Disponibles

- **`anstop_project_status`**: Estado actual del proyecto (git, build, configuración)
- **`anstop_build_project`**: Compilación con configuración específica
- **`anstop_run_tests`**: Ejecución de tests unitarios y UI
- **`anstop_create_client`**: Creación de clientes de prueba para masaje terapéutico
- **`anstop_analytics_report`**: Generación de reportes de analytics de sesiones y clientes
- **`anstop_deploy_prepare`**: Preparación para deployment a App Store

### 🌍 Variables de Entorno

```bash
CORTES_IOS_PATH="/Volumes/SSD/xCode_Projects/Anstop/iOS_Anstop"
CORTES_PROJECT_NAME="Anstop"
CORTES_BUNDLE_ID="com.molinesdesigns.Anstop"
CORTES_TEAM_ID="GD6M44DYPQ"
CORTES_GITHUB_REPO="github.com/MoLinesGitHub/Anstop.git"
CORTES_XCODE_PROJECT="/Volumes/SSD/xCode_Projects/Anstop/iOS_Anstop/Anstop.xcodeproj"
CORTES_BUILD_CONFIG="Debug"
CORTES_TARGET_DEVICE="iPhone 16 Pro"
```

## Instalación

1. **Instalar dependencias:**
```bash
cd /Volumes/SSD/xCode_Projects/Anstop/mcps/anstop-env-mcp
npm install
```

2. **Compilar:**
```bash
npm run build
```

3. **Configurar en .mcp.json:**
El servidor ya está configurado en `/Volumes/SSD/xCode_Projects/Anstop/iOS_Anstop/.mcp.json`

## Uso

### Ejemplos de Comandos

```javascript
// Verificar estado del proyecto
await anstop_project_status()

// Compilar en modo Release
await anstop_build_project({ configuration: "Release", clean: true })

// Ejecutar solo tests unitarios
await anstop_run_tests({ testType: "unit" })

// Crear cliente de prueba
await anstop_create_client({
  name: "Juan Pérez",
  email: "juan@example.com",
  phone: "+34 666 777 888"
})

// Generar reporte mensual
await anstop_analytics_report({ period: "month" })

// Preparar para deployment
await anstop_deploy_prepare({ version: "1.0.1", buildNumber: "100" })
```

## Arquitectura

```
anstop-env-mcp/
├── src/
│   └── index.ts          # Servidor MCP principal
├── dist/                 # Código compilado
├── package.json          # Dependencias y scripts
├── tsconfig.json         # Configuración TypeScript
└── README.md            # Documentación
```

## Integración con Anstop

Este MCP está específicamente diseñado para el proyecto Anstop y proporciona:

- **Gestión de build optimizada** para el proyecto iOS
- **Testing automatizado** con configuraciones específicas
- **Herramientas de datos** para testing y desarrollo de funciones de masaje
- **Analytics simulados** para pruebas de UI con métricas de clientes y sesiones
- **Deployment automatizado** con configuración de equipo

## Mantenimiento

- Actualizar versiones en `package.json`
- Ejecutar `npm run build` después de cambios
- Verificar logs con `LOG_LEVEL=debug`

---

**Proyecto Anstop** - Sistema de gestión de clientes para profesionales del masaje terapéutico  
*Desarrollado por MoLines Designs*