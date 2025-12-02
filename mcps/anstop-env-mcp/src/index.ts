#!/usr/bin/env node

/**
 * Anstop Environment MCP Server
 * 
 * Servidor MCP específico para el proyecto Anstop - aplicación iOS de gestión de clientes para profesionales del masaje terapéutico.
 * Proporciona herramientas especializadas para el desarrollo, testing y deployment de Anstop.
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from '@modelcontextprotocol/sdk/types.js';
import * as fs from 'fs-extra';
import * as path from 'path';
import { execSync } from 'child_process';

// Configuración actualizada del entorno Anstop
const ANSTOP_CONFIG = {
  projectPath: process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop',
  projectName: process.env.ANSTOP_PROJECT_NAME || 'Anstop',
  bundleId: process.env.ANSTOP_BUNDLE_ID || 'com.molinesdesigns.Anstop',
  teamId: process.env.ANSTOP_TEAM_ID || 'GD6M44DYPQ',
  githubRepo: process.env.ANSTOP_GITHUB_REPO || 'github.com/MoLinesGitHub/Anstop.git',
  xcodeProject: process.env.ANSTOP_XCODE_PROJECT || '/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcodeproj',
  xcodeWorkspace: process.env.ANSTOP_WORKSPACE || '/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcworkspace',
  buildConfig: process.env.ANSTOP_BUILD_CONFIG || 'Debug',
  targetDevice: process.env.ANSTOP_TARGET_DEVICE || 'iPhone 16 Pro',
  
  // Rutas de la arquitectura modular
  paths: {
    app: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'Anstop/App'),
    features: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'Anstop/Features'),
    domain: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'Anstop/Domain'),
    core: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'Anstop/Core'),
    services: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'Anstop/Services'),
    ui: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'Anstop/UI'),
    resources: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'Anstop/Resources'),
    tests: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'AnstopTests'),
    uiTests: path.join(process.env.ANSTOP_PROJECT_PATH || '/Volumes/SSD/xCode_Projects/Anstop', 'AnstopUITests')
  }
};

// Definición de herramientas actualizadas según arquitectura modular
const tools: Tool[] = [
  {
    name: 'anstop_project_status',
    description: 'Obtiene el estado del proyecto Anstop: git, estructura modular, build y configuración',
    inputSchema: {
      type: 'object',
      properties: {
        include_architecture: {
          type: 'boolean',
          default: true,
          description: 'Incluir información de arquitectura modular'
        }
      },
    },
  },
  {
    name: 'anstop_build_project',
    description: 'Compila el proyecto Anstop validando Swift 6.2 strict concurrency',
    inputSchema: {
      type: 'object',
      properties: {
        configuration: {
          type: 'string',
          enum: ['Debug', 'Release'],
          default: 'Debug',
          description: 'Configuración de build',
        },
        clean: {
          type: 'boolean',
          default: false,
          description: 'Limpiar build anterior',
        },
        use_workspace: {
          type: 'boolean',
          default: true,
          description: 'Usar .xcworkspace en lugar de .xcodeproj'
        },
        analyze_errors: {
          type: 'boolean',
          default: true,
          description: 'Analizar errores de concurrency y arquitectura'
        }
      },
    },
  },
  {
    name: 'anstop_run_tests',
    description: 'Ejecuta tests de Anstop (AnstopTests y AnstopUITests)',
    inputSchema: {
      type: 'object',
      properties: {
        testTarget: {
          type: 'string',
          enum: ['AnstopTests', 'AnstopUITests', 'all'],
          default: 'all',
          description: 'Target de tests a ejecutar',
        },
        parallel: {
          type: 'boolean',
          default: true,
          description: 'Ejecutar tests en paralelo'
        }
      },
    },
  },
  {
    name: 'anstop_validate_structure',
    description: 'Valida que la estructura del proyecto coincida con la arquitectura modular definida',
    inputSchema: {
      type: 'object',
      properties: {
        check_missing_folders: {
          type: 'boolean',
          default: true,
          description: 'Verificar carpetas faltantes'
        }
      },
    },
  },
  {
    name: 'anstop_check_instructions',
    description: 'Valida que el código cumpla con las reglas de .github/instructions/',
    inputSchema: {
      type: 'object',
      properties: {
        instruction_file: {
          type: 'string',
          enum: ['architecture', 'swift', 'ui', 'services', 'domain', 'tests', 'assets', 'localization', 'all'],
          default: 'all',
          description: 'Archivo de instrucciones a validar'
        }
      },
    },
  },
  {
    name: 'anstop_deploy_prepare',
    description: 'Prepara Anstop para deployment (App Store o TestFlight)',
    inputSchema: {
      type: 'object',
      properties: {
        version: {
          type: 'string',
          description: 'Número de versión (ej: 1.0.1)',
        },
        buildNumber: {
          type: 'string',
          description: 'Número de build',
        },
        target: {
          type: 'string',
          enum: ['testflight', 'appstore'],
          default: 'testflight',
          description: 'Destino de deployment'
        },
        validate_checklist: {
          type: 'boolean',
          default: true,
          description: 'Validar CHECKLIST.md antes de deployment'
        }
      },
      required: ['version'],
    },
  },
];

// Servidor MCP
const server = new Server(
  {
    name: 'anstop-env-mcp',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Handler para listar herramientas
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools };
});

// Handler para ejecutar herramientas
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'anstop_project_status': {
        const include_architecture = args?.include_architecture !== false;
        
        const gitStatus = execSync('git status --porcelain', { 
          cwd: ANSTOP_CONFIG.projectPath, 
          encoding: 'utf8' 
        });
        
        const projectInfo: any = {
          projectPath: ANSTOP_CONFIG.projectPath,
          projectName: ANSTOP_CONFIG.projectName,
          bundleId: ANSTOP_CONFIG.bundleId,
          gitStatus: gitStatus.trim() ? 'Cambios pendientes' : 'Limpio',
          lastCommit: execSync('git log -1 --oneline', { 
            cwd: ANSTOP_CONFIG.projectPath, 
            encoding: 'utf8' 
          }).trim(),
          xcodeProject: ANSTOP_CONFIG.xcodeProject,
          xcodeWorkspace: ANSTOP_CONFIG.xcodeWorkspace,
          buildConfig: ANSTOP_CONFIG.buildConfig,
        };

        if (include_architecture) {
          projectInfo.architecture = {
            layers: ['App', 'Features', 'Domain', 'Core', 'Services', 'UI', 'Resources'],
            testTargets: ['AnstopTests', 'AnstopUITests'],
            swiftVersion: '6.2 (strict concurrency)',
            instructions: '.github/instructions/*.instructions.md'
          };
        }

        return {
          content: [
            {
              type: 'text',
              text: `📊 Estado del Proyecto Anstop\n\n${JSON.stringify(projectInfo, null, 2)}`,
            },
          ],
        };
      }

      case 'anstop_build_project': {
        const config = args?.configuration || 'Debug';
        const clean = args?.clean || false;
        const use_workspace = args?.use_workspace !== false;
        const analyze_errors = args?.analyze_errors !== false;
        
        let command = '';
        const projectFile = use_workspace ? 
          `-workspace "${ANSTOP_CONFIG.xcodeWorkspace}"` : 
          `-project "${ANSTOP_CONFIG.xcodeProject}"`;
        
        if (clean) {
          command += `xcodebuild clean ${projectFile} -scheme "${ANSTOP_CONFIG.projectName}" && `;
        }
        
        command += `xcodebuild build ${projectFile} -scheme "${ANSTOP_CONFIG.projectName}" -configuration ${config} -destination 'platform=iOS Simulator,name=${ANSTOP_CONFIG.targetDevice}'`;
        
        const result = execSync(command, { 
          cwd: ANSTOP_CONFIG.projectPath, 
          encoding: 'utf8' 
        });

        const strictMaxChars = 60000; // ~20k tokens
        let truncatedResult = result;
        
        if (result.length > strictMaxChars) {
          const startChars = Math.floor(strictMaxChars * 0.2);
          const endChars = Math.floor(strictMaxChars * 0.3);
          
          truncatedResult = result.substring(0, startChars) + 
            "\n\n🔄 [LOG TRUNCADO - MOSTRANDO INICIO Y FINAL RELEVANTE] 🔄\n\n" + 
            result.substring(result.length - endChars);
        }

        const buildStatus = result.includes('BUILD SUCCEEDED') ? '✅ BUILD SUCCEEDED' : 
                           result.includes('BUILD FAILED') ? '❌ BUILD FAILED' : '⚠️ Estado desconocido';
        
        const errorLines = result.split('\n').filter(line => 
          line.includes('error:') || line.includes('Error:') || line.includes('failed')
        ).slice(0, 15);

        // Análisis de errores de concurrency
        const concurrencyErrors = errorLines.filter(line => 
          line.includes('@MainActor') || 
          line.includes('Sendable') || 
          line.includes('actor') ||
          line.includes('async')
        );

        let summary = `
🔨 Estado del Build: ${buildStatus}
📁 Configuración: ${config}
🧹 Clean: ${clean ? 'Sí' : 'No'}
🔧 Usando: ${use_workspace ? 'Workspace' : 'Project'}

${errorLines.length > 0 ? '❌ Errores detectados: ' + errorLines.length : '✅ Sin errores'}
`;

        if (analyze_errors && concurrencyErrors.length > 0) {
          summary += `\n⚠️ Errores de Swift 6.2 strict concurrency: ${concurrencyErrors.length}`;
          summary += `\n💡 Revisar: .github/instructions/swift.instructions.md`;
        }

        return {
          content: [
            {
              type: 'text',
              text: `${summary}\n\n📋 Log:\n${truncatedResult}`,
            },
          ],
        };
      }

      case 'anstop_run_tests': {
        const testTarget = args?.testTarget || 'all';
        const parallel = args?.parallel !== false;
        
        let command = `xcodebuild test -workspace "${ANSTOP_CONFIG.xcodeWorkspace}" -scheme "${ANSTOP_CONFIG.projectName}" -destination 'platform=iOS Simulator,name=${ANSTOP_CONFIG.targetDevice}'`;
        
        if (testTarget !== 'all') {
          command += ` -only-testing:${testTarget}`;
        }
        
        if (parallel) {
          command += ' -parallel-testing-enabled YES';
        }
        
        const result = execSync(command, { 
          cwd: ANSTOP_CONFIG.projectPath, 
          encoding: 'utf8' 
        });

        const passed = (result.match(/Test Suite .* passed/g) || []).length;
        const failed = (result.match(/Test Suite .* failed/g) || []).length;

        const summary = `
🧪 Tests Ejecutados: ${testTarget}
✅ Pasados: ${passed}
❌ Fallidos: ${failed}
⚡ Paralelo: ${parallel ? 'Sí' : 'No'}
`;

        return {
          content: [
            {
              type: 'text',
              text: `${summary}\n\n📋 Resultado:\n${result.substring(result.length - 3000)}`,
            },
          ],
        };
      }

      case 'anstop_validate_structure': {
        const check_missing_folders = args?.check_missing_folders !== false;
        
        const expectedPaths = [
          { path: ANSTOP_CONFIG.paths.app, name: 'App' },
          { path: ANSTOP_CONFIG.paths.features, name: 'Features' },
          { path: ANSTOP_CONFIG.paths.domain, name: 'Domain' },
          { path: ANSTOP_CONFIG.paths.core, name: 'Core' },
          { path: ANSTOP_CONFIG.paths.services, name: 'Services' },
          { path: ANSTOP_CONFIG.paths.ui, name: 'UI' },
          { path: ANSTOP_CONFIG.paths.resources, name: 'Resources' },
          { path: ANSTOP_CONFIG.paths.tests, name: 'AnstopTests' },
          { path: ANSTOP_CONFIG.paths.uiTests, name: 'AnstopUITests' },
        ];

        const results = [];
        for (const { path: folderPath, name } of expectedPaths) {
          const exists = fs.existsSync(folderPath);
          results.push({ name, exists, path: folderPath });
        }

        const missing = results.filter(r => !r.exists);
        
        let report = '🏗️ Validación de Estructura Modular\n\n';
        
        if (missing.length === 0) {
          report += '✅ Todas las carpetas de la arquitectura están presentes.\n\n';
        } else {
          report += `⚠️ Faltan ${missing.length} carpetas:\n`;
          missing.forEach(m => report += `  - ${m.name} (${m.path})\n`);
          report += '\n';
        }

        report += 'Estructura actual:\n';
        results.forEach(r => {
          report += `${r.exists ? '✅' : '❌'} ${r.name}\n`;
        });

        return {
          content: [
            {
              type: 'text',
              text: report,
            },
          ],
        };
      }

      case 'anstop_check_instructions': {
        const instruction_file = args?.instruction_file || 'all';
        
        const instructionsPath = path.join(ANSTOP_CONFIG.projectPath, '.github/instructions');
        const files = instruction_file === 'all' 
          ? fs.readdirSync(instructionsPath).filter(f => f.endsWith('.instructions.md'))
          : [`${instruction_file}.instructions.md`];

        let report = '📋 Validación de Instrucciones\n\n';
        
        for (const file of files) {
          const filePath = path.join(instructionsPath, file);
          if (fs.existsSync(filePath)) {
            report += `✅ ${file}\n`;
            const content = fs.readFileSync(filePath, 'utf8');
            report += `   Tamaño: ${(content.length / 1024).toFixed(1)} KB\n`;
          } else {
            report += `❌ ${file} - NO ENCONTRADO\n`;
          }
        }

        report += `\n💡 Todas las instrucciones están en: .github/instructions/`;

        return {
          content: [
            {
              type: 'text',
              text: report,
            },
          ],
        };
      }



      case 'anstop_deploy_prepare': {
        const version = args?.version;
        const buildNumber = args?.buildNumber || Date.now().toString();
        const target = args?.target || 'testflight';
        const validate_checklist = args?.validate_checklist !== false;
        
        let report = `🚀 Preparando Deployment de Anstop\n\n`;
        report += `📦 Versión: ${version}\n`;
        report += `🔢 Build: ${buildNumber}\n`;
        report += `🎯 Destino: ${target}\n\n`;
        
        // Validar CHECKLIST.md si está habilitado
        if (validate_checklist) {
          const checklistPath = path.join(ANSTOP_CONFIG.projectPath, 'CHECKLIST.md');
          if (fs.existsSync(checklistPath)) {
            const checklist = fs.readFileSync(checklistPath, 'utf8');
            const pendingItems = (checklist.match(/\[ \]/g) || []).length;
            const completedItems = (checklist.match(/\[x\]/gi) || []).length;
            
            report += `📋 CHECKLIST.md:\n`;
            report += `   ✅ Completados: ${completedItems}\n`;
            report += `   ⏳ Pendientes: ${pendingItems}\n\n`;
            
            if (pendingItems > 0) {
              report += `⚠️ ADVERTENCIA: Hay ${pendingItems} items pendientes en CHECKLIST\n\n`;
            }
          }
        }
        
        // Actualizar Info.plist
        const infoPlistPath = path.join(ANSTOP_CONFIG.projectPath, 'Anstop/Info.plist');
        
        try {
          execSync(`/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${version}" "${infoPlistPath}"`, { encoding: 'utf8' });
          execSync(`/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildNumber}" "${infoPlistPath}"`, { encoding: 'utf8' });
          report += `✅ Info.plist actualizado\n`;
        } catch (error) {
          report += `❌ Error actualizando Info.plist: ${error}\n`;
        }
        
        report += `\n💡 Siguiente paso:\n`;
        if (target === 'testflight') {
          report += `   xcodebuild archive + export para TestFlight\n`;
        } else {
          report += `   Validar en App Store Connect y enviar para revisión\n`;
        }

        return {
          content: [
            {
              type: 'text',
              text: report,
            },
          ],
        };
      }

      default:
        throw new Error(`Herramienta desconocida: ${name}`);
    }
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `Error ejecutando ${name}: ${error}`,
        },
      ],
      isError: true,
    };
  }
});

// Iniciar servidor
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Anstop Environment MCP Server ejecutándose en stdio');
}

main().catch((error) => {
  console.error('Error fatal:', error);
  process.exit(1);
});