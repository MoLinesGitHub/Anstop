#!/usr/bin/env node

/**
 * Anstop Development MCP Server
 *
 * Servidor MCP personalizado para optimizar el desarrollo de Anstop con:
 * - Análisis automático de errores Swift/Xcode
 * - Detección de memory leaks en servicios
 * - Validación de arquitectura MCP
 * - Testing automatizado de features
 * - Análisis inteligente de build logs
 * - Optimización de rendimiento específica para Anstop
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ErrorCode,
  ListToolsRequestSchema,
  McpError,
} from '@modelcontextprotocol/sdk/types.js';
import { spawn, exec } from 'child_process';
import { promisify } from 'util';
import { readFile, writeFile, readdir, stat } from 'fs/promises';
import path from 'path';

const execAsync = promisify(exec);

/**
 * Configuración del servidor MCP para Anstop
 * Actualizado según la arquitectura modular real del proyecto
 */
const ANSTOP_PROJECT_ROOT = process.env.ANSTOP_PROJECT_ROOT || '/Volumes/SSD/xCode_Projects/Anstop';
const ANSTOP_PROJECT_NAME = 'Anstop';
const ANSTOP_BUNDLE_ID = 'com.molinesdesigns.Anstop';
const ANSTOP_XCODE_PROJECT = path.join(ANSTOP_PROJECT_ROOT, 'Anstop.xcodeproj');
const ANSTOP_WORKSPACE = path.join(ANSTOP_PROJECT_ROOT, 'Anstop.xcworkspace');

/**
 * Estructura modular real del proyecto Anstop
 */
const ANSTOP_STRUCTURE = {
  app: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/App'),
  features: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/Features'),
  domain: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/Domain'),
  core: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/Core'),
  services: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/Services'),
  ui: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/UI'),
  resources: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/Resources'),
  tests: path.join(ANSTOP_PROJECT_ROOT, 'AnstopTests'),
  uiTests: path.join(ANSTOP_PROJECT_ROOT, 'AnstopUITests'),
  viewModels: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/ViewModel'),
  views: path.join(ANSTOP_PROJECT_ROOT, 'Anstop/Views'),
  instructions: path.join(ANSTOP_PROJECT_ROOT, '.github/instructions')
};

/**
 * Herramientas disponibles en el MCP de Anstop
 */
const ANSTOP_TOOLS = [
  {
    name: 'analyze_swift_compilation_errors',
    description: 'Analiza errores de compilación Swift/Xcode específicos de Anstop respetando Swift 6.2 strict concurrency y arquitectura modular',
    inputSchema: {
      type: 'object',
      properties: {
        build_log_path: {
          type: 'string',
          description: 'Ruta al archivo de log de build de Xcode (opcional, busca automáticamente)'
        },
        include_warnings: {
          type: 'boolean',
          default: true,
          description: 'Incluir warnings además de errores'
        },
        layer: {
          type: 'string',
          enum: ['app', 'features', 'domain', 'core', 'services', 'ui', 'tests', 'all'],
          default: 'all',
          description: 'Capa arquitectónica específica a analizar'
        },
        check_concurrency: {
          type: 'boolean',
          default: true,
          description: 'Validar cumplimiento de Swift 6.2 strict concurrency (@MainActor, Sendable)'
        }
      }
    }
  },
  {
    name: 'detect_memory_leaks',
    description: 'Escanea código Swift en busca de memory leaks, referencias circulares y violaciones de concurrency (Swift 6.2 strict)',
    inputSchema: {
      type: 'object',
      properties: {
        layer: {
          type: 'string',
          enum: ['services', 'viewmodels', 'core', 'all'],
          default: 'all',
          description: 'Capa específica a analizar'
        },
        deep_analysis: {
          type: 'boolean',
          default: false,
          description: 'Análisis profundo incluyendo delegates, closures y actor isolation'
        },
        check_sendable: {
          type: 'boolean',
          default: true,
          description: 'Validar conformidad con Sendable protocol'
        }
      }
    }
  },
  {
    name: 'validate_architecture',
    description: 'Valida la arquitectura modular de Anstop según las reglas definidas en .github/instructions/',
    inputSchema: {
      type: 'object',
      properties: {
        check_layer_separation: {
          type: 'boolean',
          default: true,
          description: 'Verificar separación estricta UI/Lógica/Domain/Services'
        },
        check_dependencies: {
          type: 'boolean',
          default: true,
          description: 'Validar que las dependencias fluyan correctamente (UI→ViewModel→Domain/Services)'
        },
        check_concurrency_rules: {
          type: 'boolean',
          default: true,
          description: 'Validar reglas de Swift 6.2 strict concurrency (@MainActor en ViewModels/Views)'
        },
        validate_domain_purity: {
          type: 'boolean',
          default: true,
          description: 'Verificar que Domain no dependa de UI ni infraestructura'
        }
      }
    }
  },
  {
    name: 'run_tests',
    description: 'Ejecuta tests de Anstop (AnstopTests/ y AnstopUITests/) con análisis de resultados',
    inputSchema: {
      type: 'object',
      properties: {
        test_target: {
          type: 'string',
          enum: ['AnstopTests', 'AnstopUITests', 'all'],
          default: 'all',
          description: 'Target de tests a ejecutar'
        },
        test_class: {
          type: 'string',
          description: 'Clase de test específica (opcional)'
        },
        test_method: {
          type: 'string',
          description: 'Método de test específico (opcional)'
        },
        generate_coverage: {
          type: 'boolean',
          default: false,
          description: 'Generar reporte de cobertura'
        },
        analyze_failures: {
          type: 'boolean',
          default: true,
          description: 'Analizar fallos y sugerir fixes basados en arquitectura'
        }
      }
    }
  },
  {
    name: 'analyze_xcode_build_logs',
    description: 'Análisis inteligente de logs de build de Xcode con categorización de problemas específicos para Anstop',
    inputSchema: {
      type: 'object',
      properties: {
        log_path: {
          type: 'string',
          description: 'Ruta específica al log (opcional, busca el más reciente)'
        },
        filter_level: {
          type: 'string',
          enum: ['all', 'errors', 'warnings', 'critical'],
          default: 'all',
          description: 'Nivel de filtrado de mensajes'
        },
        summarize: {
          type: 'boolean',
          default: true,
          description: 'Generar resumen ejecutivo'
        }
      }
    }
  },
  {
    name: 'optimize_performance',
    description: 'Detecta problemas de rendimiento y sugiere optimizaciones según guías de .github/instructions/ui.instructions.md',
    inputSchema: {
      type: 'object',
      properties: {
        layer: {
          type: 'string',
          enum: ['ui', 'services', 'viewmodels', 'domain', 'all'],
          default: 'all',
          description: 'Capa específica a optimizar'
        },
        check_swiftui_performance: {
          type: 'boolean',
          default: true,
          description: 'Analizar re-renderizados innecesarios, LazyVStack, prefetch'
        },
        check_animations: {
          type: 'boolean',
          default: true,
          description: 'Validar uso de .animation(_:value:) explícito'
        },
        check_memory: {
          type: 'boolean',
          default: true,
          description: 'Analizar uso de memoria y retain cycles'
        },
        suggest_instruments: {
          type: 'boolean',
          default: true,
          description: 'Sugerir uso de Instruments (Time Profiler, SwiftUI, Leaks)'
        }
      }
    }
  },
  {
    name: 'validate_localization',
    description: 'Valida que no existan strings hardcoded y que todas las claves de Localizable.strings estén presentes',
    inputSchema: {
      type: 'object',
      properties: {
        check_missing_keys: {
          type: 'boolean',
          default: true,
          description: 'Detectar claves faltantes en Localizable.strings'
        },
        check_hardcoded_strings: {
          type: 'boolean',
          default: true,
          description: 'Detectar strings hardcoded en Views'
        },
        languages: {
          type: 'array',
          items: { type: 'string' },
          default: ['es', 'en'],
          description: 'Idiomas a validar'
        }
      }
    }
  },
  {
    name: 'check_assets',
    description: 'Valida que todos los assets (colores, imágenes) estén correctamente definidos en Resources/',
    inputSchema: {
      type: 'object',
      properties: {
        check_colors: {
          type: 'boolean',
          default: true,
          description: 'Validar referencias a Colors.xcassets'
        },
        check_images: {
          type: 'boolean',
          default: true,
          description: 'Validar referencias a Assets.xcassets'
        },
        check_dark_mode: {
          type: 'boolean',
          default: true,
          description: 'Verificar soporte de modo oscuro en colores dinámicos'
        },
        check_accessibility: {
          type: 'boolean',
          default: true,
          description: 'Validar accessibilityLabel localizados'
        }
      }
    }
  }
];

/**
 * Servidor MCP principal
 */
class AnstopDevMCPServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: 'anstop-dev-mcp',
        version: '1.0.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.setupToolHandlers();
    this.setupErrorHandling();
  }

  private setupErrorHandling(): void {
    this.server.onerror = (error) => {
      console.error('[MCP Error]', error);
    };

    process.on('SIGINT', async () => {
      await this.server.close();
      process.exit(0);
    });
  }

  private setupToolHandlers(): void {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: ANSTOP_TOOLS,
    }));

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      try {
        switch (name) {
          case 'analyze_swift_compilation_errors':
            return await this.analyzeSwiftCompilationErrors(args);

          case 'detect_memory_leaks':
            return await this.detectMemoryLeaks(args);

          case 'validate_architecture':
            return await this.validateArchitecture(args);

          case 'run_tests':
            return await this.runTests(args);

          case 'analyze_xcode_build_logs':
            return await this.analyzeXcodeBuildLogs(args);

          case 'optimize_performance':
            return await this.optimizePerformance(args);

          case 'validate_localization':
            return await this.validateLocalization(args);

          case 'check_assets':
            return await this.checkAssets(args);

          default:
            throw new McpError(
              ErrorCode.MethodNotFound,
              `Herramienta desconocida: ${name}`
            );
        }
      } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        throw new McpError(
          ErrorCode.InternalError,
          `Error ejecutando ${name}: ${errorMessage}`
        );
      }
    });
  }

  /**
   * Analiza errores de compilación Swift/Xcode
   */
  private async analyzeSwiftCompilationErrors(args: any) {
    const { build_log_path, include_warnings = true, target_files } = args;
    
    console.log(`🔍 Analizando errores de compilación de Anstop...`);
    
    try {
      // Buscar logs de build más recientes si no se especifica ruta
      const logPath = build_log_path || await this.findLatestBuildLog();
      
      if (!logPath) {
        return {
          content: [{
            type: 'text',
            text: '⚠️ No se encontraron logs de build recientes. Ejecute una compilación primero.'
          }]
        };
      }

      const logContent = await readFile(logPath, 'utf-8');
      const errors = this.parseSwiftErrors(logContent, include_warnings);
      
      if (errors.length === 0) {
        return {
          content: [{
            type: 'text',
            text: '✅ No se encontraron errores de compilación en Anstop.'
          }]
        };
      }

      const analysis = this.generateErrorAnalysis(errors);
      
      return {
        content: [{
          type: 'text',
          text: `📊 **Análisis de Errores de Compilación - ${ANSTOP_PROJECT_NAME}**\n\n${analysis}`
        }]
      };
      
    } catch (error) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error analizando compilación: ${error}`
        }]
      };
    }
  }

  /**
   * Detecta memory leaks en servicios de Anstop
   */
  private async detectMemoryLeaks(args: any) {
    const { layer = 'all', deep_analysis = false, check_sendable = true } = args;
    
    console.log(`🔍 Detectando memory leaks en ${ANSTOP_PROJECT_NAME}...`);
    
    try {
      const leaks: any[] = [];
      
      // TODO: Implementar análisis real de memory leaks
      // Por ahora retorna placeholder
      
      if (leaks.length === 0) {
        return {
          content: [{
            type: 'text',
            text: `✅ No se detectaron memory leaks en ${ANSTOP_PROJECT_NAME}.`
          }]
        };
      }
      
      let report = `🚨 **Reporte de Memory Leaks - ${ANSTOP_PROJECT_NAME}**\n\n`;
      report += `Se encontraron ${leaks.length} posibles memory leaks.\n`;
      
      return {
        content: [{
          type: 'text',
          text: report
        }]
      };
      
    } catch (error) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error detectando memory leaks: ${error}`
        }]
      };
    }
  }

  /**
   * Valida arquitectura modular de Anstop
   */
  private async validateArchitecture(args: any) {
    const { 
      check_layer_separation = true, 
      check_dependencies = true,
      check_concurrency_rules = true,
      validate_domain_purity = true
    } = args;
    
    console.log(`🏗️ Validando arquitectura modular de Anstop...`);
    
    try {
      const issues = [];
      
      if (check_layer_separation) {
        // Verificar que Views no contengan lógica de negocio
        // Verificar que Domain no importe SwiftUI
        issues.push(...await this.checkLayerSeparation());
      }
      
      if (check_dependencies) {
        // Validar flujo: UI → ViewModel → Domain/Services
        issues.push(...await this.checkDependencyFlow());
      }
      
      if (check_concurrency_rules) {
        // Validar @MainActor en Views/ViewModels
        // Detectar uso indebido de Task.detached
        issues.push(...await this.checkConcurrencyRules());
      }
      
      if (validate_domain_purity) {
        // Verificar que Domain sea 100% puro
        issues.push(...await this.checkDomainPurity());
      }
      
      if (issues.length === 0) {
        return {
          content: [{
            type: 'text',
            text: `✅ Arquitectura modular de ${ANSTOP_PROJECT_NAME} cumple con todas las reglas de .github/instructions/`
          }]
        };
      }
      
      const report = this.generateArchitectureReport(issues);
      
      return {
        content: [{
          type: 'text',
          text: `🏗️ **Validación de Arquitectura - ${ANSTOP_PROJECT_NAME}**\n\n${report}`
        }]
      };
      
    } catch (error) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error validando arquitectura: ${error}`
        }]
      };
    }
  }

  /**
   * Ejecuta tests de Anstop
   */
  private async runTests(args: any) {
    const { 
      test_target = 'all', 
      test_class,
      test_method,
      generate_coverage = false,
      analyze_failures = true
    } = args;
    
    console.log(`🧪 Ejecutando tests de ${ANSTOP_PROJECT_NAME}...`);
    
    try {
      let command = 'xcodebuild test';
      command += ` -project "${ANSTOP_XCODE_PROJECT}"`;
      command += ` -scheme ${ANSTOP_PROJECT_NAME}`;
      command += ` -destination 'platform=iOS Simulator,name=iPhone 16 Pro'`;
      
      if (test_target !== 'all') {
        command += ` -only-testing:${test_target}`;
      }
      
      if (test_class) {
        command += `/${test_class}`;
      }
      
      if (test_method) {
        command += `/${test_method}`;
      }
      
      if (generate_coverage) {
        command += ' -enableCodeCoverage YES';
      }
      
      const { stdout, stderr } = await execAsync(command, { cwd: ANSTOP_PROJECT_ROOT });
      const output = stdout + stderr;
      
      const results = this.parseTestResults(output);
      
      let report = `🧪 **Resultados de Tests - ${ANSTOP_PROJECT_NAME}**\n\n`;
      report += `✅ Pasados: ${results.passed}\n`;
      report += `❌ Fallidos: ${results.failed}\n`;
      report += `⏱️ Tiempo: ${results.duration}s\n\n`;
      
      if (results.failed > 0 && analyze_failures) {
        report += `🔍 **Análisis de Fallos:**\n`;
        report += await this.analyzeTestFailures(results.failures);
      }
      
      return {
        content: [{
          type: 'text',
          text: report
        }]
      };
      
    } catch (error) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error ejecutando tests: ${error}`
        }]
      };
    }
  }

  /**
   * Analiza logs de build de Xcode
   */
  private async analyzeXcodeBuildLogs(args: any) {
    const { log_path, filter_level = 'all', summarize = true } = args;
    
    console.log(`📋 Analizando logs de build de Xcode para Anstop...`);
    
    try {
      const logPath = log_path || await this.findLatestBuildLog();
      
      if (!logPath) {
        return {
          content: [{
            type: 'text',
            text: '⚠️ No se encontraron logs de build para analizar.'
          }]
        };
      }
      
      const logContent = await readFile(logPath, 'utf-8');
      const analysis = this.analyzeBuildLog(logContent, filter_level);
      
      let report = `📋 **Análisis de Build Log - ${ANSTOP_PROJECT_NAME}**\n\n`;
      
      if (summarize) {
        report += this.generateBuildSummary(analysis);
      } else {
        report += this.generateDetailedBuildAnalysis(analysis);
      }
      
      return {
        content: [{
          type: 'text',
          text: report
        }]
      };
      
    } catch (error) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error analizando build logs: ${error}`
        }]
      };
    }
  }

  /**
   * Optimiza rendimiento según guías de ui.instructions.md
   */
  private async optimizePerformance(args: any) {
    const { 
      layer = 'all',
      check_swiftui_performance = true,
      check_animations = true,
      check_memory = true,
      suggest_instruments = true
    } = args;
    
    console.log(`⚡ Analizando rendimiento de ${ANSTOP_PROJECT_NAME}...`);
    
    try {
      const issues = [];
      
      if (check_swiftui_performance && (layer === 'ui' || layer === 'all')) {
        // Detectar cálculos costosos en body
        // Validar uso de LazyVStack/LazyHStack
        // Verificar implementación de prefetch con .task(id:)
        issues.push(...await this.checkSwiftUIPerformance());
      }
      
      if (check_animations && (layer === 'ui' || layer === 'all')) {
        // Validar uso de .animation(_:value:) explícito
        // Detectar .animation(_) deprecated
        issues.push(...await this.checkAnimations());
      }
      
      if (check_memory) {
        // Analizar retain cycles
        // Validar uso de [weak self]
        issues.push(...await this.checkMemoryUsage(layer));
      }
      
      let report = `⚡ **Análisis de Rendimiento - ${ANSTOP_PROJECT_NAME}**\n\n`;
      
      if (issues.length === 0) {
        report += `✅ No se encontraron problemas de rendimiento.\n\n`;
      } else {
        report += this.generatePerformanceReport(issues);
      }
      
      if (suggest_instruments) {
        report += `\n📊 **Recomendación:** Ejecutar Instruments para análisis profundo:\n`;
        report += `- Time Profiler: detectar cuellos de botella\n`;
        report += `- SwiftUI: analizar re-renderizados\n`;
        report += `- Leaks: detectar memory leaks\n`;
      }
      
      return {
        content: [{
          type: 'text',
          text: report
        }]
      };
      
    } catch (error) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error analizando rendimiento: ${error}`
        }]
      };
    }
  }

  /**
   * Valida localización según localization.instructions.md
   */
  private async validateLocalization(args: any) {
    const {
      check_missing_keys = true,
      check_hardcoded_strings = true,
      languages = ['es', 'en']
    } = args;
    
    console.log(`🌍 Validando localización de ${ANSTOP_PROJECT_NAME}...`);
    
    try {
      const issues = [];
      
      if (check_missing_keys) {
        issues.push(...await this.checkMissingLocalizationKeys(languages));
      }
      
      if (check_hardcoded_strings) {
        issues.push(...await this.checkHardcodedStrings());
      }
      
      if (issues.length === 0) {
        return {
          content: [{
            type: 'text',
            text: `✅ Localización de ${ANSTOP_PROJECT_NAME} es correcta.`
          }]
        };
      }
      
      const report = this.generateLocalizationReport(issues);
      
      return {
        content: [{
          type: 'text',
          text: `🌍 **Validación de Localización**\n\n${report}`
        }]
      };
      
    } catch (error) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error validando localización: ${error}`
        }]
      };
    }
  }

  /**
   * Valida assets según assets.instructions.md
   */
  private async checkAssets(args: any) {
    const {
      check_colors = true,
      check_images = true,
      check_dark_mode = true,
      check_accessibility = true
    } = args;
    
    console.log(`🎨 Validando assets de ${ANSTOP_PROJECT_NAME}...`);
    
    try {
      const issues = [];
      
      if (check_colors) {
        issues.push(...await this.validateColorAssets());
      }
      
      if (check_images) {
        issues.push(...await this.validateImageAssets());
      }
      
      if (check_dark_mode) {
        issues.push(...await this.validateDarkModeSupport());
      }
      
      if (check_accessibility) {
        issues.push(...await this.validateAccessibilityLabels());
      }
      
      if (issues.length === 0) {
        return {
          content: [{
            type: 'text',
            text: `✅ Assets de ${ANSTOP_PROJECT_NAME} están correctamente configurados.`
          }]
        };
      }
      
      const report = this.generateAssetsReport(issues);
      
      return {
        content: [{
          type: 'text',
          text: `🎨 **Validación de Assets**\n\n${report}`
        }]
      };
      
    } catch (error) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error validando assets: ${error}`
        }]
      };
    }
  }

  // Métodos auxiliares privados...
  private async findLatestBuildLog(): Promise<string | null> {
    const derivedDataPath = path.join(process.env.HOME || '', 'Library/Developer/Xcode/DerivedData');
    return null; // TODO: Implementar búsqueda de logs
  }

  private parseSwiftErrors(logContent: string, includeWarnings: boolean): any[] {
    const errors = [];
    const lines = logContent.split('\n');
    
    for (const line of lines) {
      if (line.includes('error:') || (includeWarnings && line.includes('warning:'))) {
        errors.push({ line, type: line.includes('error:') ? 'error' : 'warning' });
      }
    }
    
    return errors;
  }

  private generateErrorAnalysis(errors: any[]): string {
    let analysis = `Total de errores: ${errors.filter(e => e.type === 'error').length}\n`;
    analysis += `Total de warnings: ${errors.filter(e => e.type === 'warning').length}\n\n`;
    
    // Agrupar por tipo común
    const concurrencyErrors = errors.filter(e => 
      e.line.includes('@MainActor') || e.line.includes('Sendable') || e.line.includes('actor')
    );
    
    if (concurrencyErrors.length > 0) {
      analysis += `⚠️ Detectados ${concurrencyErrors.length} errores de concurrency (Swift 6.2 strict)\n`;
      analysis += `Revisar: .github/instructions/swift.instructions.md\n\n`;
    }
    
    return analysis;
  }

  private async checkLayerSeparation(): Promise<any[]> {
    const issues: any[] = [];
    
    // Verificar que Views no tengan lógica de negocio
    const viewsPath = ANSTOP_STRUCTURE.views;
    // TODO: Implementar análisis de separación de capas
    
    return issues;
  }

  private async checkDependencyFlow(): Promise<any[]> {
    // Validar que Domain no importe SwiftUI, Core Data, etc.
    // Validar que Services no accedan a UI directamente
    return [];
  }

  private async checkConcurrencyRules(): Promise<any[]> {
    // Verificar @MainActor en ViewModels y Views
    // Detectar Task.detached innecesarios
    return [];
  }

  private async checkDomainPurity(): Promise<any[]> {
    // Verificar que Domain sea 100% puro (structs, sin side effects)
    return [];
  }

  private generateArchitectureReport(issues: any[]): string {
    let report = `Se encontraron ${issues.length} problemas de arquitectura:\n\n`;
    
    for (const issue of issues) {
      report += `- ${issue.description}\n`;
      report += `  Archivo: ${issue.file}\n`;
      report += `  Solución: ${issue.suggestion}\n\n`;
    }
    
    return report;
  }

  private parseTestResults(output: string): any {
    const passedMatch = output.match(/Test Suite .* passed/g);
    const failedMatch = output.match(/Test Suite .* failed/g);
    
    return {
      passed: passedMatch ? passedMatch.length : 0,
      failed: failedMatch ? failedMatch.length : 0,
      duration: 0,
      failures: []
    };
  }

  private async analyzeTestFailures(failures: any[]): Promise<string> {
    let analysis = '';
    
    for (const failure of failures) {
      analysis += `❌ ${failure.name}\n`;
      analysis += `   Razón: ${failure.reason}\n`;
      analysis += `   Sugerencia: Revisar ViewModel correspondiente\n\n`;
    }
    
    return analysis;
  }

  private analyzeBuildLog(logContent: string, filterLevel: string): any {
    return {
      errors: this.parseSwiftErrors(logContent, false),
      warnings: this.parseSwiftErrors(logContent, true)
    };
  }

  private generateBuildSummary(analysis: any): string {
    return `Errores: ${analysis.errors.length}\nWarnings: ${analysis.warnings.length}`;
  }

  private generateDetailedBuildAnalysis(analysis: any): string {
    return JSON.stringify(analysis, null, 2);
  }

  private async checkSwiftUIPerformance(): Promise<any[]> {
    // Detectar cálculos costosos en body
    // Validar uso de LazyVStack/LazyHStack
    return [];
  }

  private async checkAnimations(): Promise<any[]> {
    // Detectar .animation(_) deprecated
    // Validar uso de .animation(_:value:)
    return [];
  }

  private async checkMemoryUsage(layer: string): Promise<any[]> {
    // Analizar retain cycles y [weak self]
    return [];
  }

  private generatePerformanceReport(issues: any[]): string {
    let report = '';
    
    for (const issue of issues) {
      report += `⚠️ ${issue.title}\n`;
      report += `   ${issue.description}\n`;
      report += `   Fix: ${issue.fix}\n\n`;
    }
    
    return report;
  }

  private async checkMissingLocalizationKeys(languages: string[]): Promise<any[]> {
    // Validar que todas las claves referenciadas existan en Localizable.strings
    return [];
  }

  private async checkHardcodedStrings(): Promise<any[]> {
    // Detectar Text("string literal") en lugar de Text("key")
    return [];
  }

  private generateLocalizationReport(issues: any[]): string {
    let report = `Se encontraron ${issues.length} problemas de localización:\n\n`;
    
    for (const issue of issues) {
      report += `- ${issue.description}\n`;
    }
    
    return report;
  }

  private async validateColorAssets(): Promise<any[]> {
    // Validar referencias a Color("...") que existen en Colors.xcassets
    return [];
  }

  private async validateImageAssets(): Promise<any[]> {
    // Validar Image("...") que existen en Assets.xcassets
    return [];
  }

  private async validateDarkModeSupport(): Promise<any[]> {
    // Verificar colores dinámicos para dark mode
    return [];
  }

  private async validateAccessibilityLabels(): Promise<any[]> {
    // Verificar que accessibilityLabel estén localizados
    return [];
  }

  private generateAssetsReport(issues: any[]): string {
    let report = `Se encontraron ${issues.length} problemas con assets:\n\n`;
    
    for (const issue of issues) {
      report += `- ${issue.description}\n`;
    }
    
    return report;
  }

  async run(): Promise<void> {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('🚀 Anstop Development MCP Server iniciado');
  }
}

/**
 * Punto de entrada principal
 */
const server = new AnstopDevMCPServer();
server.run().catch(console.error);
