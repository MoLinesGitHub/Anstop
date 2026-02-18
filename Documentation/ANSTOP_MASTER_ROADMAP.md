# ANSTOP MASTER ROADMAP
Fecha de auditoría: 2026-02-18
Proyecto: Anstop (iOS)
Estado: SOURCE_OF_TRUTH

## 1) Alcance de consolidación
- Este es el único Markdown permitido dentro de `Documentation/`.
- Cualquier referencia histórica a nombres anteriores se interpreta como error tipográfico y se normaliza a `Anstop`.
- Objetivo: servir como roadmap operativo para Claude Code, Gemini y Codex con estados verificables.

## 2) Entradas auditadas
- Carpeta de documentación consolidada:
  - `Documentation/ANSTOP_MASTER_ROADMAP.md`
- Código auditado:
  - `Anstop/`
  - `AnstopTests/`
  - `AnstopUITests/`
  - `Anstop.xcodeproj/project.pbxproj`
  - `Anstop.xcworkspace`

## 3) Evidencia de plataforma (hecho vs no hecho)
- Hecho:
  - Proyecto iOS funcional con targets `Anstop`, `AnstopTests`, `AnstopUITests`.
- No hecho:
  - No existe target/producto activo de watchOS ni widgets en este workspace.
- Evidencia:
  - `xcodebuild -list -project Anstop.xcodeproj`
  - `xcodebuild -list -workspace Anstop.xcworkspace`
  - Resultado de esquemas: `Anstop`, `GlassKitPro`, `GlassKitProAnimations`.

## 4) Estado real por dominio
| Dominio | Estado | Evidencia principal | Gap |
|---|---|---|---|
| Onboarding + Home + Panic | ✅ Implementado | `Anstop/Features/Onboarding/OnboardingView.swift`, `Anstop/Features/Home/HomeView.swift`, `Anstop/Features/PanicButton/PanicFlowView.swift` | Sin gap bloqueante |
| Diario y progreso | ✅ Implementado | `Anstop/Features/DailyJournal/*.swift`, `Anstop/Domain/Models/ProgramProgress.swift` | Mejorar cobertura edge-cases UI |
| StoreKit (compra/restore) | ✅ Base implementada | `Anstop/Services/StoreKit/PurchaseManager.swift`, `Anstop/Features/Paywall/PaywallView.swift` | Falta test UI de compra/restore |
| IA asistente | ⚠️ Parcial | `Anstop/Services/Backend/AIService.swift` | Respuestas locales por reglas, sin backend IA real |
| Notificaciones | ✅ Base implementada | `Anstop/Services/Notifications/NotificationManager.swift` | Mejorar UX de permisos/reintento |
| Localización | ⚠️ Parcial avanzada | `Anstop/Resources/es.lproj/Localizable.strings`, `Anstop/Resources/en.lproj/Localizable.strings` | Queda contenido legal extenso embebido en español en `LegalData` |
| Arquitectura | ⚠️ Parcial | Predominan Views con estado/manager directo | No hay capa MVVM consistente en features |
| watchOS / Widgets | ❌ No iniciado en este repo | Sin targets ni esquema final de producto | Fuera de alcance actual de iOS release |

## 5) Resultado de validación técnica reciente
- Build:
  - `xcodebuild build -workspace Anstop.xcworkspace -scheme Anstop -destination 'generic/platform=iOS Simulator'`
  - Estado: `BUILD SUCCEEDED`
- Tests unitarios:
  - `xcodebuild test -workspace Anstop.xcworkspace -scheme Anstop -destination 'platform=iOS Simulator,id=F66D0C94-2AE0-4894-B6E7-3F8A6603C8F9' -only-testing:AnstopTests`
  - Estado: `TEST SUCCEEDED`
- UI smoke tests:
  - `xcodebuild test ... -only-testing:AnstopUITests`
  - Estado: `TEST SUCCEEDED` (onboarding básico, panic flow, apertura/cierre paywall)

## 6) Riesgos vigentes (priorizados)
1. IA productiva no integrada (solo heurística local).
2. Localización incompleta en algunos botones/etiquetas visibles.
3. Cobertura UI aún mínima para compra/restauración y regresiones de navegación.
4. Divergencia arquitectura objetivo (MVVM) vs implementación real (stateful views).
5. Warning no bloqueante de metadata/AppIntents pendiente de limpieza.

## 7) Roadmap único priorizado

### P0 - Bloqueadores de release iOS (0-3 días)
- ✅ Consolidación documental completada:
  - Solo existe `Documentation/ANSTOP_MASTER_ROADMAP.md`.
- ✅ Secrets en cliente mitigados:
  - `AppStoreSecrets` usa environment/Info.plist.
- ✅ UI test panic estabilizado:
  - Flujo determinista con soporte `UI_TESTING` en `HomeView`.

 ### P1 - Calidad mínima release (3-7 días)
 - Localización final:
  - ✅ Testimonios del paywall migrados a claves EN/ES.
  - ✅ Contenido legal (Política, Términos, EULA) ahora proviene de `Localizable.strings`.
- Testing:
  - Añadir UI tests para compra, restore y navegación de quick-access.
- Arquitectura:
  - Definir criterio incremental de migración a MVVM (empezar por `Home`, `Settings`, `Paywall`).

### P2 - Funcionalidad diferencial (1-2 semanas)
- IA real:
  - Integrar endpoint/backend de IA con fallback local explícito.
- Audio terapéutico:
  - Sustituir placeholders por catálogo real y política free/premium.

### P3 - Release readiness (1-2 semanas)
- Hardening funcional en dispositivo real.
- Cierre legal/compliance de textos y flujo de consentimiento.
- Métricas de producto y embudo de conversión.

### P4 - Futuro (post-release iOS)
- watchOS y widgets en repositorio/targets dedicados tras estabilizar iOS.

## 8) Backlog técnico accionable para agentes
1. Localización residual:
   - Archivo: `Anstop/Domain/Models/LegalData.swift`
   - Acción: mover privacidad/términos/EULA a recursos localizados EN/ES (no hardcode en Swift).
2. UI tests premium:
   - Archivo: `AnstopUITests/AnstopUITests.swift`
   - Acción: cubrir restore, compra fallida/cancelada y retorno desde paywall.
3. Refactor incremental MVVM:
   - Empezar por `HomeView` y `SettingsView`.
   - Criterio: lógica de negocio fuera de `View`, estado observable aislado.
4. IA backend:
   - Archivo base: `Anstop/Services/Backend/AIService.swift`
   - Acción: adaptar servicio para modo remoto + fallback local.

## 9) Definición de Done v1.0 (iOS)
- Build estable sin warnings críticos.
- Suite `AnstopTests` y `AnstopUITests` verde en ejecución repetible.
- 100% de texto visible EN/ES localizado por clave.
- Compra/restore premium validado en pruebas funcionales.
- IA y audio definidos explícitamente como real o fallback con comportamiento documentado.

## 10) Regla operativa para futuros cambios
- Si el código cambia estado funcional, este archivo debe actualizarse en el mismo commit.
- Ningún otro `.md` debe añadirse dentro de `Documentation/` sin reemplazar este roadmap.
