#!/usr/bin/env node
"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const index_js_1 = require("@modelcontextprotocol/sdk/server/index.js");
const stdio_js_1 = require("@modelcontextprotocol/sdk/server/stdio.js");
const types_js_1 = require("@modelcontextprotocol/sdk/types.js");
const child_process_1 = require("child_process");
const util_1 = require("util");
const path = __importStar(require("path"));
const execAsync = (0, util_1.promisify)(child_process_1.exec);
/**
 * Configuración específica para el proyecto Anstop
 */
const ANSTOP_CONFIG = {
    projectPath: '/Volumes/SSD/xCode_Projects/Anstop',
    projectFile: '/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcodeproj',
    workspaceFile: '/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcworkspace',
    schemeName: 'Anstop',
    defaultDevice: 'iPhone 16 Pro'
};
class XcodeMCPServer {
    constructor() {
        this.server = new index_js_1.Server({
            name: "xcode-mcp",
            version: "1.0.0",
        });
        this.setupToolHandlers();
        this.server.onerror = (error) => console.error("[MCP Error]", error);
        process.on("SIGINT", async () => {
            await this.server.close();
            process.exit(0);
        });
    }
    setupToolHandlers() {
        this.server.setRequestHandler(types_js_1.ListToolsRequestSchema, async () => ({
            tools: [
                {
                    name: "xcode_build_project",
                    description: "Compila un proyecto Xcode (optimizado para Anstop con workspace)",
                    inputSchema: {
                        type: "object",
                        properties: {
                            project_path: {
                                type: "string",
                                description: "Ruta al archivo .xcodeproj o .xcworkspace",
                                default: ANSTOP_CONFIG.workspaceFile
                            },
                            scheme: {
                                type: "string",
                                description: "Scheme a compilar",
                                default: ANSTOP_CONFIG.schemeName
                            },
                            configuration: {
                                type: "string",
                                description: "Configuración (Debug/Release)",
                                default: "Debug"
                            },
                            destination: {
                                type: "string",
                                description: "Destino de compilación",
                                default: `platform=iOS Simulator,name=${ANSTOP_CONFIG.defaultDevice}`
                            },
                            use_workspace: {
                                type: "boolean",
                                description: "Usar workspace en lugar de project",
                                default: true
                            }
                        }
                    }
                },
                {
                    name: "xcode_clean_project",
                    description: "Limpia el build de un proyecto Xcode",
                    inputSchema: {
                        type: "object",
                        properties: {
                            project_path: {
                                type: "string",
                                description: "Ruta al archivo .xcodeproj o .xcworkspace"
                            },
                            scheme: {
                                type: "string",
                                description: "Scheme a limpiar (opcional)"
                            }
                        },
                        required: ["project_path"]
                    }
                },
                {
                    name: "xcode_list_schemes",
                    description: "Lista todos los schemes de un proyecto",
                    inputSchema: {
                        type: "object",
                        properties: {
                            project_path: {
                                type: "string",
                                description: "Ruta al archivo .xcodeproj o .xcworkspace"
                            }
                        },
                        required: ["project_path"]
                    }
                },
                {
                    name: "xcode_list_targets",
                    description: "Lista todos los targets de un proyecto",
                    inputSchema: {
                        type: "object",
                        properties: {
                            project_path: {
                                type: "string",
                                description: "Ruta al archivo .xcodeproj o .xcworkspace"
                            }
                        },
                        required: ["project_path"]
                    }
                },
                {
                    name: "xcode_run_tests",
                    description: "Ejecuta tests (optimizado para AnstopTests y AnstopUITests)",
                    inputSchema: {
                        type: "object",
                        properties: {
                            project_path: {
                                type: "string",
                                description: "Ruta al workspace",
                                default: ANSTOP_CONFIG.workspaceFile
                            },
                            scheme: {
                                type: "string",
                                description: "Scheme para tests",
                                default: ANSTOP_CONFIG.schemeName
                            },
                            test_target: {
                                type: "string",
                                enum: ["AnstopTests", "AnstopUITests", "all"],
                                description: "Target específico de tests",
                                default: "all"
                            },
                            destination: {
                                type: "string",
                                description: "Destino para tests",
                                default: `platform=iOS Simulator,name=${ANSTOP_CONFIG.defaultDevice}`
                            },
                            parallel: {
                                type: "boolean",
                                description: "Ejecutar tests en paralelo",
                                default: true
                            }
                        }
                    }
                },
                {
                    name: "xcode_archive_project",
                    description: "Crea un archive del proyecto",
                    inputSchema: {
                        type: "object",
                        properties: {
                            project_path: {
                                type: "string",
                                description: "Ruta al archivo .xcodeproj o .xcworkspace"
                            },
                            scheme: {
                                type: "string",
                                description: "Scheme para archive"
                            },
                            archive_path: {
                                type: "string",
                                description: "Ruta donde guardar el archive"
                            }
                        },
                        required: ["project_path", "scheme", "archive_path"]
                    }
                },
                {
                    name: "xcode_get_build_settings",
                    description: "Obtiene la configuración de build del proyecto",
                    inputSchema: {
                        type: "object",
                        properties: {
                            project_path: {
                                type: "string",
                                description: "Ruta al archivo .xcodeproj o .xcworkspace"
                            },
                            target: {
                                type: "string",
                                description: "Target específico (opcional)"
                            },
                            configuration: {
                                type: "string",
                                description: "Configuración (Debug/Release)",
                                default: "Debug"
                            }
                        },
                        required: ["project_path"]
                    }
                },
                {
                    name: "xcode_find_projects",
                    description: "Busca proyectos Xcode en una ruta",
                    inputSchema: {
                        type: "object",
                        properties: {
                            search_path: {
                                type: "string",
                                description: "Ruta donde buscar proyectos",
                                default: "/Users/molinesmac/Documents"
                            },
                            include_workspaces: {
                                type: "boolean",
                                description: "Incluir archivos .xcworkspace",
                                default: true
                            }
                        }
                    }
                },
                {
                    name: "xcode_get_version",
                    description: "Obtiene la versión de Xcode instalada",
                    inputSchema: {
                        type: "object",
                        properties: {}
                    }
                },
                {
                    name: "xcode_get_simulators",
                    description: "Lista todos los simuladores disponibles",
                    inputSchema: {
                        type: "object",
                        properties: {
                            runtime: {
                                type: "string",
                                description: "Filtrar por runtime (iOS, watchOS, tvOS)"
                            }
                        }
                    }
                }
            ]
        }));
        this.server.setRequestHandler(types_js_1.CallToolRequestSchema, async (request) => {
            const { name, arguments: args } = request.params;
            try {
                switch (name) {
                    case "xcode_build_project":
                        return await this.buildProject(args);
                    case "xcode_clean_project":
                        return await this.cleanProject(args);
                    case "xcode_list_schemes":
                        return await this.listSchemes(args);
                    case "xcode_list_targets":
                        return await this.listTargets(args);
                    case "xcode_run_tests":
                        return await this.runTests(args);
                    case "xcode_archive_project":
                        return await this.archiveProject(args);
                    case "xcode_get_build_settings":
                        return await this.getBuildSettings(args);
                    case "xcode_find_projects":
                        return await this.findProjects(args);
                    case "xcode_get_version":
                        return await this.getXcodeVersion();
                    case "xcode_get_simulators":
                        return await this.getSimulators(args);
                    default:
                        throw new types_js_1.McpError(types_js_1.ErrorCode.MethodNotFound, `Herramienta no encontrada: ${name}`);
                }
            }
            catch (error) {
                const errorMessage = error instanceof Error ? error.message : String(error);
                throw new types_js_1.McpError(types_js_1.ErrorCode.InternalError, `Error en ${name}: ${errorMessage}`);
            }
        });
    }
    async buildProject(args) {
        const { project_path, scheme, configuration = "Debug", destination = "iOS Simulator" } = args;
        const isWorkspace = project_path.endsWith('.xcworkspace');
        const projectFlag = isWorkspace ? '-workspace' : '-project';
        let cmd = `xcodebuild ${projectFlag} "${project_path}" -configuration ${configuration}`;
        if (scheme) {
            cmd += ` -scheme "${scheme}"`;
        }
        cmd += ` -destination "platform=${destination}" build`;
        const { stdout, stderr } = await execAsync(cmd);
        return {
            content: [
                {
                    type: "text",
                    text: `✅ Build completado para ${path.basename(project_path)}\n\n${stdout}${stderr ? `\nWarnings/Errors:\n${stderr}` : ''}`
                }
            ]
        };
    }
    async cleanProject(args) {
        const { project_path, scheme } = args;
        const isWorkspace = project_path.endsWith('.xcworkspace');
        const projectFlag = isWorkspace ? '-workspace' : '-project';
        let cmd = `xcodebuild ${projectFlag} "${project_path}" clean`;
        if (scheme) {
            cmd += ` -scheme "${scheme}"`;
        }
        const { stdout, stderr } = await execAsync(cmd);
        return {
            content: [
                {
                    type: "text",
                    text: `🧹 Clean completado para ${path.basename(project_path)}\n\n${stdout}${stderr ? `\nOutput:\n${stderr}` : ''}`
                }
            ]
        };
    }
    async listSchemes(args) {
        const { project_path } = args;
        const isWorkspace = project_path.endsWith('.xcworkspace');
        const projectFlag = isWorkspace ? '-workspace' : '-project';
        const cmd = `xcodebuild ${projectFlag} "${project_path}" -list`;
        const { stdout } = await execAsync(cmd);
        return {
            content: [
                {
                    type: "text",
                    text: `📋 Schemes disponibles en ${path.basename(project_path)}:\n\n${stdout}`
                }
            ]
        };
    }
    async listTargets(args) {
        const { project_path } = args;
        const isWorkspace = project_path.endsWith('.xcworkspace');
        const projectFlag = isWorkspace ? '-workspace' : '-project';
        const cmd = `xcodebuild ${projectFlag} "${project_path}" -list`;
        const { stdout } = await execAsync(cmd);
        return {
            content: [
                {
                    type: "text",
                    text: `🎯 Targets disponibles en ${path.basename(project_path)}:\n\n${stdout}`
                }
            ]
        };
    }
    async runTests(args) {
        const { project_path, scheme, destination = "iOS Simulator" } = args;
        const isWorkspace = project_path.endsWith('.xcworkspace');
        const projectFlag = isWorkspace ? '-workspace' : '-project';
        const cmd = `xcodebuild ${projectFlag} "${project_path}" -scheme "${scheme}" -destination "platform=${destination}" test`;
        const { stdout, stderr } = await execAsync(cmd);
        return {
            content: [
                {
                    type: "text",
                    text: `🧪 Tests ejecutados para ${scheme}:\n\n${stdout}${stderr ? `\nErrors:\n${stderr}` : ''}`
                }
            ]
        };
    }
    async archiveProject(args) {
        const { project_path, scheme, archive_path } = args;
        const isWorkspace = project_path.endsWith('.xcworkspace');
        const projectFlag = isWorkspace ? '-workspace' : '-project';
        const cmd = `xcodebuild ${projectFlag} "${project_path}" -scheme "${scheme}" -archivePath "${archive_path}" archive`;
        const { stdout, stderr } = await execAsync(cmd);
        return {
            content: [
                {
                    type: "text",
                    text: `📦 Archive creado en ${archive_path}:\n\n${stdout}${stderr ? `\nOutput:\n${stderr}` : ''}`
                }
            ]
        };
    }
    async getBuildSettings(args) {
        const { project_path, target, configuration = "Debug" } = args;
        const isWorkspace = project_path.endsWith('.xcworkspace');
        const projectFlag = isWorkspace ? '-workspace' : '-project';
        let cmd = `xcodebuild ${projectFlag} "${project_path}" -configuration ${configuration} -showBuildSettings`;
        if (target) {
            cmd += ` -target "${target}"`;
        }
        const { stdout } = await execAsync(cmd);
        return {
            content: [
                {
                    type: "text",
                    text: `⚙️ Build Settings para ${path.basename(project_path)}:\n\n${stdout}`
                }
            ]
        };
    }
    async findProjects(args) {
        const { search_path = "/Users/molinesmac/Documents", include_workspaces = true } = args;
        let cmd = `find "${search_path}" -name "*.xcodeproj" -type d`;
        if (include_workspaces) {
            cmd += ` && find "${search_path}" -name "*.xcworkspace" -type d`;
        }
        const { stdout } = await execAsync(cmd);
        const projects = stdout.trim().split('\n').filter(line => line.length > 0);
        return {
            content: [
                {
                    type: "text",
                    text: `🔍 Proyectos Xcode encontrados en ${search_path}:\n\n${projects.map(p => `• ${p}`).join('\n')}\n\nTotal: ${projects.length} proyectos`
                }
            ]
        };
    }
    async getXcodeVersion() {
        const { stdout } = await execAsync('xcodebuild -version');
        return {
            content: [
                {
                    type: "text",
                    text: `🛠️ Versión de Xcode:\n\n${stdout}`
                }
            ]
        };
    }
    async getSimulators(args) {
        const { runtime } = args;
        let cmd = 'xcrun simctl list devices available';
        const { stdout } = await execAsync(cmd);
        let result = stdout;
        if (runtime) {
            const lines = stdout.split('\n').filter(line => line.toLowerCase().includes(runtime.toLowerCase()) ||
                !line.includes('--') && !line.startsWith('=='));
            result = lines.join('\n');
        }
        return {
            content: [
                {
                    type: "text",
                    text: `📱 Simuladores disponibles${runtime ? ` (${runtime})` : ''}:\n\n${result}`
                }
            ]
        };
    }
    async run() {
        const transport = new stdio_js_1.StdioServerTransport();
        await this.server.connect(transport);
        console.error("Xcode MCP Server ejecutándose en stdio");
    }
}
const server = new XcodeMCPServer();
server.run().catch(console.error);
//# sourceMappingURL=index.js.map