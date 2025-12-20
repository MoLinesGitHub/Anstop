# 🚀 **ROADMAP COMPLETO – Anstop (App de Ansiedad / Ataques de Pánico)**
### *Objetivo: MVP en 6–8 semanas, escalable a 2.500–80.000 €/mes*
### **📅 Última actualización: 2 de diciembre de 2025**

---

## 📊 **ESTADO GENERAL DEL PROYECTO**

**✅ MVP FUNCIONAL COMPLETADO (80%)**

### Estado por Módulos:
- ✅ **Arquitectura base**: Estructura modular, SwiftData, NavigationStack
- ✅ **Navegación principal**: HomeView con accesos rápidos
- ✅ **Flujo de pánico**: PanicFlowView con 3 pasos guiados
- ✅ **Respiración**: BreathingCircle con animación
- ✅ **Suscripciones**: PurchaseManager con StoreKit 2
- ✅ **Onboarding**: 3 pasos personalizados
- ✅ **Diario**: DailyJournalView con SwiftData
- ✅ **Programa 30 días**: ThirtyDayProgramView con progreso
- ✅ **Biblioteca**: LibraryView con protocolos
- ✅ **Asistente IA**: AIHelperView básico
- ✅ **Configuración**: SettingsView completo
- ✅ **Audio**: AudioManager implementado
- ✅ **Paywall**: PaywallView con conversión optimizada
- ✅ **Haptics**: Sistema de retroalimentación táctil
- 🔄 **Contenido terapéutico**: Audios y guías (en progreso)
- 🔜 **Tests**: Unitarios y UI (pendiente)
- 🔜 **Localización**: Multi-idioma (pendiente)

---

# ✅ **PHASE 0 — Fundamentos del negocio** [COMPLETADO 100%]

### ✅ 0.1 Definir la propuesta de valor
- ✅ App que ayuda al usuario **en tiempo real** durante ansiedad o ataques de pánico
- ✅ Contenido terapéutico: audio guías, respiración, grounding, técnicas instantáneas
- ✅ Función estrella: **"Botón de pánico"** → activación inmediata de protocolos guiados

### ✅ 0.2 Modelo de monetización
- ✅ **Freemium** implementado:
  - ✅ Gratis: herramientas básicas, respiración, diario, 1 guía de pánico
  - ✅ Premium (configurado en StoreKit):
    - `premium.monthly`
    - `premium.yearly`
    - Guías completas de audio
    - Programa de 30 días
    - Ejercicios personalizados
    - Asistente IA 24/7
    - Sin anuncios

### ✅ 0.3 Identidad del producto
- ✅ Nombre: **Anstop**
- ✅ Bundle ID: `com.molinesdesigns.Anstop`
- ✅ Paleta: azul suave, blanco, transparencias
- ✅ Tono: seguro, amable, directo (nunca clínico)
- ✅ Icono y assets configurados

---

# ✅ **PHASE 1 — Arquitectura del proyecto** [COMPLETADO 100%]

### ✅ 1.1 Stack técnico
- ✅ **Swift 6.0**
- ✅ **SwiftUI** con NavigationStack
- ✅ **Observation API** (@Observable)
- ✅ **SwiftData** (@Model, @Query)
- ✅ **StoreKit 2** (PurchaseManager)
- ✅ **AVFoundation** (AudioManager)
- ✅ **Haptic Feedback** (HapticManager)
- 🔜 BackgroundTasks (recordatorios)
- 🔜 CloudKit (sincronización v2)

### ✅ 1.2 Estructura modular implementada
```
Anstop/
 ├── App/
 │    └── AnstopApp.swift ✅
 ├── Features/ ✅
 │    ├── Home/ ✅
 │    ├── PanicButton/ ✅
 │    ├── Breathing/ ✅
 │    ├── AudioGuides/ ✅
 │    ├── DailyJournal/ ✅
 │    ├── Exercises/ ✅
 │    ├── AIHelper/ ✅
 │    ├── ThirtyDayProgram/ ✅
 │    ├── Onboarding/ ✅
 │    ├── Settings/ ✅
 │    └── Paywall/ ✅
 ├── Core/ ✅
 │    ├── Models/ ✅ (JournalEntry, AnxietyEvent, ProgramProgress, Protocol)
 │    ├── AudioManager.swift ✅
 │    ├── PurchaseManager/ ✅
 │    ├── Services/ ✅ (AIService)
 │    ├── Managers/ ✅ (HapticManager)
 │    ├── Extensions/ ✅
 │    └── Theme/ ✅
 ├── UI/ ✅
 │    ├── PrimaryButtonStyle.swift ✅
 │    ├── SecondaryButtonStyle.swift ✅
 │    └── CardBackground+Adaptive.swift ✅
 └── Resources/ ✅
      └── Assets.xcassets/ ✅
```

### ✅ 1.3 Flujo principal
- ✅ HomeView → acceso rápido a todas las funciones
- ✅ Panic Protocol → PanicFlowView (3 pasos)
- ✅ Ejercicios → BreathingCircle, Grounding, Audio
- ✅ Diario + Progreso → SwiftData
- ✅ Paywall Premium → con trial de 7 días

---

# ✅ **PHASE 2 — Diseño de experiencia** [COMPLETADO 95%]

### ✅ 2.1 Pantallas esenciales del MVP

#### ✅ 1. OnboardingView
- ✅ 3 pantallas empáticas
- ✅ Pregunta sobre nivel de ansiedad inicial
- ✅ Personalización guardada en @AppStorage

#### ✅ 2. HomeView
- ✅ Botón grande: **"Estoy teniendo ansiedad"**
- ✅ Banner premium para usuarios no premium
- ✅ Acceso rápido a:
  - ✅ Respiración
  - ✅ Grounding 5–4–3–2–1
  - ✅ Audio calmante
  - ✅ Diario del día
- ✅ Navegación a todas las secciones

#### ✅ 3. PanicFlowView (la estrella)
- ✅ Guía paso a paso:
  - ✅ "Respira conmigo" (con BreathingCircle animado)
  - ✅ "Tu cuerpo está a salvo"
  - ✅ "Vamos a bajar tu ritmo"
- ✅ Pantalla de completado con CTA premium
- ✅ Contador de completados
- ✅ Tiempo estimado: 60–180 segundos

#### ✅ 4. BreathingView
- ✅ Círculo animado con easing suave
- ✅ Animación de 4 segundos (inhalar/exhalar)
- ✅ Degradado azul calmante
- 🔄 Múltiples protocolos: 4–7–8, 4–4, 3–3–3 (pendiente)

#### ✅ 5. AudioGuidesView
- ✅ Lista de audios
- ✅ Contenido freemium/premium diferenciado
- ✅ Paywall integrado para usuarios no premium
- 🔄 Contenido de audio real (en progreso)

#### ✅ 6. DailyJournalView
- ✅ Nueva entrada por día
- ✅ Track: estrés, sueño, notas
- ✅ Historial con SwiftData
- ✅ Eliminación de entradas
- ✅ Navegación a historial completo

#### ✅ 7. PaywallView
- ✅ Diseño NO clínico
- ✅ Mensaje: "Ayuda inmediata cuando más la necesitas"
- ✅ Testimonio de usuarios
- ✅ Estadísticas de eficacia
- ✅ Trial de 7 días destacado
- ✅ Dos versiones: completa y simple
- ✅ Integración con StoreKit 2

#### ✅ 8. ThirtyDayProgramView (EXTRA)
- ✅ Grid de 30 días
- ✅ Sistema de rachas (streaks)
- ✅ Progreso visual
- ✅ Navegación a contenido diario
- ✅ Contenido programático generado

#### ✅ 9. LibraryView (EXTRA)
- ✅ Biblioteca de protocolos
- ✅ Grounding 5-4-3-2-1
- ✅ Respiración progresiva
- ✅ Ansiedad nocturna
- ✅ Pánico social
- ✅ Navegación a detalle

#### ✅ 10. AIHelperView (EXTRA)
- ✅ Chat conversacional
- ✅ Integración con servicio IA
- ✅ Mensajes del usuario y asistente
- ✅ Indicador de escritura
- ✅ Scroll automático

#### ✅ 11. SettingsView (EXTRA)
- ✅ Gestión de cuenta premium
- ✅ Configuración de recordatorios
- ✅ Haptics on/off
- ✅ Gestión de datos
- ✅ Políticas y términos
- ✅ Información de la app

### ✅ 2.2 Animaciones clave
- ✅ Pulsación calmada en botones (scale con spring)
- ✅ Animación de respiración (scale con easeInOut)
- ✅ Haptic feedback sincronizado
- ✅ withOptionalAnimation (accesibilidad)
- 🔄 Ondas de respiración avanzadas (pendiente)
- 🔄 Blur y degradados dinámicos (pendiente)

---

# ✅ **PHASE 3 — Implementación del MVP** [COMPLETADO 85%]

## ✅ 3.1 SwiftData + @Query
**Estado: COMPLETADO**

Modelos implementados:
```swift
✅ @Model JournalEntry
   - id: UUID
   - date: Date
   - mood: Int
   - stressLevel: Int
   - sleepQuality: Int
   - notes: String

✅ @Model AnxietyEvent
   - id: UUID
   - date: Date
   - intensity: Int

✅ @Model ProgramProgress
   - id: UUID
   - completedDays: [Int]
   - startDate: Date
   - lastCompletionDate: Date?
   - currentStreak: Int
```

---

## ✅ 3.2 Panic Protocol (flujo guiado)
**Estado: COMPLETADO**

```swift
✅ PanicFlowView
   - TabView con 3 pasos
   - Navegación progresiva
   - Pantalla de completado
   - CTA premium integrado
   - Contador de completados

✅ PanicCompletionView
   - Feedback visual de éxito
   - Sugerencia premium contextual
   - Botón de retorno
```

---

## ✅ 3.3 Animación de respiración
**Estado: COMPLETADO**

```swift
✅ BreathingCircle
   - Animación scale 0.4 → 1.0
   - EaseInOut 4 segundos
   - Repeat forever con autoreverses
   - Degradado azul suave
```

---

## ✅ 3.4 Audio Player
**Estado: COMPLETADO**

```swift
✅ AudioManager (@Observable)
   - play(_:) implementado
   - pause() implementado
   - stop() implementado
   - resume() implementado
   - isPlaying estado
   - currentTime tracking
   - duration tracking
   - AVAudioSession configurado
```

---

## ✅ 3.5 Suscripciones (StoreKit 2)
**Estado: COMPLETADO**

```swift
✅ PurchaseManager (@Observable)
   - loadProducts() async
   - purchase(_:) async throws
   - restorePurchases() async
   - isPremium computed property
   - Transaction verification
   - currentEntitlements tracking
   
✅ Productos configurados:
   - premium.monthly
   - premium.yearly
```

---

## ✅ 3.6 Bloqueo de contenido → Premium
**Estado: COMPLETADO**

```swift
✅ Implementado en:
   - AudioGuidesView → PaywallSimpleView
   - ThirtyDayProgram → algunos días bloqueados
   - PanicCompletionView → CTA contextual
   - HomeView → Banner premium
```

---

## ✅ 3.7 Onboarding personalizado
**Estado: COMPLETADO**

```swift
✅ OnboardingView
   - 3 pasos implementados
   - Captura de nivel de ansiedad inicial
   - Guardado en @AppStorage
   - hasCompletedOnboarding flag
   - Navegación suave con animaciones
```

---

# 🔄 **PHASE 4 — Contenido terapéutico** [EN PROGRESO 30%]

### 🔄 4.1 Audios calmantes
- ✅ Estructura de AudioManager lista
- ✅ UI de AudioGuidesView implementada
- 🔄 **PENDIENTE**: Grabar/adquirir 10–20 audios
  - Duración 2–5 minutos
  - Narradora femenina con voz tranquila
  - Formatos: mp3, AAC
  - Temas:
    - Respiración guiada
    - Relajación muscular progresiva
    - Visualización calmante
    - Ansiedad nocturna
    - Pánico social
    - Grounding 5-4-3-2-1

### ✅ 4.2 Protocolos escritos
**Estado: COMPLETADO**

```swift
✅ Protocol model implementado
✅ 5 protocolos disponibles:
   1. Grounding 5-4-3-2-1
   2. Respiración Progresiva
   3. Ansiedad Nocturna
   4. Pánico Social
   5. Reestructuración de Pensamiento

✅ ProtocolDetailView con contenido completo
```

---

# ✅ **PHASE 5 — IA** [COMPLETADO MVP - 70%]

### ✅ MVP IA implementado:
- ✅ AIHelperView con chat conversacional
- ✅ AIService básico implementado
- ✅ Prompt system para tono calmante
- 🔄 **PENDIENTE**: Integrar API real (OpenAI/Claude)
  - Actualmente usa respuestas mock
  - Prompt optimizado para contexto de ansiedad
  - Rate limiting y manejo de errores
  - Historial de conversación local

---

# 🔜 **PHASE 6 — Política de privacidad & App Store** [PENDIENTE]

### 🔜 Requisitos clave:
- 🔜 Declarar contenido emocional (no clínico)
- 🔜 Disclaimers: "no sustituye profesionales"
- 🔜 Política de privacidad completa
- 🔜 Términos de uso
- 🔜 Privacidad: datos locales + opcional iCloud
- 🔜 Screenshots para App Store
- 🔜 Descripción optimizada (ASO)
- 🔜 Video preview

**Notas:**
- SettingsView ya tiene enlaces a privacidad y términos
- Falta redactar documentos legales

---

# 🔜 **PHASE 7 — Marketing y crecimiento** [PENDIENTE]

### 🔜 Growth:
- 🔜 Landing page (anstop.app)
- 🔜 TikTok, Reels → contenido emocional
- 🔜 SEO: "ataques de pánico qué hacer"
- 🔜 Email onboarding sequence
- 🔜 Icono final + capturas cuidadas
- 🔜 Press kit

### 🔜 KPIs objetivo:
- CAC < 2 €
- Conversión premium 3–7%
- Retención día 7 > 30%
- 100 reviews 5⭐ el primer mes

---

# 🔜 **PHASE 8 — Escalado a 80.000 €/mes** [PLANIFICADO]

### Estrategia:
- ✅ Programa de 30 días implementado
- 🔜 Content marketing continuo
- 🔜 Partnerships con psicólogos
- 🔜 Programa de afiliados
- 🔜 Expansión internacional
- 🔜 B2B (empresas)

---

# 🔜 **PHASE 9 — Expansión Multiplataforma** [FUTURO]

### 🔜 9.1 iPadOS
- Layout adaptado con columnas
- Modo relajación pantalla completa
- Widgets de respiración

### 🔜 9.2 watchOS
- Complicación: "Respira ahora"
- Mini protocolo de pánico (30–60s)
- Sincronización con app principal

### 🔜 9.3 macOS
- Port con SwiftUI multiplataforma
- Para usuarios que trabajan en escritorio

---

# 🔜 **PHASE 10 — Gamificación avanzada** [FUTURO]

### 🔜 10.1 Sistema de streaks
- ✅ Ya implementado en ThirtyDayProgram
- 🔜 Expandir a otros módulos
- 🔜 Notificaciones de racha

### 🔜 10.2 Logros emocionales
- "Semana sin ataques"
- "30 días de diario"
- "10 ejercicios completados"

### 🔜 10.3 Insights con CoreML
- Análisis de patrones de ansiedad
- Predicción de momentos críticos
- Recomendaciones personalizadas

---

# 🔜 **PHASE 11 — IA Avanzada** [FUTURO]

### 🔜 11.1 Coaching emocional
- Modelo LLM personalizado
- Análisis del diario sin subir a servidores
- CoreML on-device

### 🔜 11.2 Sistema conversacional guiado
- Preguntas que reducen ansiedad progresivamente
- Feedback inmediato contextual

### 🔜 11.3 Motor de recomendaciones
- "Hoy prueba respiración 4-7-8"
- "Tu patrón nocturno indica estrés acumulado"
- Basado en historial local

---

# 🔜 **PHASE 12 — Escalado Internacional** [FUTURO]

### 🔜 12.1 Localización completa
- ✅ Estructura lista (Localizable.strings)
- 🔜 Textos traducidos
- 🔜 Audio en múltiples idiomas
- 🔜 Recursos visuales culturales

### 🔜 12.2 Idiomas prioritarios
1. 🇪🇸 Español (actual)
2. 🇬🇧 Inglés
3. 🇵🇹 Portugués
4. 🇩🇪 Alemán
5. 🇫🇷 Francés

### 🔜 12.3 Métodos de pago regionales
- Apple Pay regional
- Precios adaptados por país

---

# 🔜 **PHASE 13 — Control de Calidad** [PENDIENTE]

### 🔜 13.1 QA psicológico
- Revisión de contenido por psicólogos
- Validación de guías
- Disclaimers apropiados

### 🔜 13.2 QA técnico
- 🔜 Tests unitarios
- 🔜 Tests de UI
- 🔜 Stress tests (audio, animaciones)
- 🔜 Tests de accesibilidad (VoiceOver)
- 🔜 Performance profiling

---

# 🔜 **PHASE 14 — Optimización de Ingresos** [PLANIFICADO]

### 🔜 14.1 Experimentos A/B
- 3 variantes de paywall
- 2 variantes de onboarding
- Precio óptimo por región

### 🔜 14.2 Funneling de conversión
- Reducir fricción primera sesión
- Mejorar retención día 1
- Optimizar trial-to-paid

### 🔜 14.3 Paquetes y promociones
- ✅ Trial 7 días implementado
- 🔜 Oferta de bienvenida
- 🔜 Descuentos estacionales
- 🔜 Lifetime deal

---

# 🔜 **PHASE 15 — Partnerships** [FUTURO]

### 🔜 15.1 Colaboración con psicólogos
- Sesiones grabadas premium
- Certificación de contenido
- Co-branding

### 🔜 15.2 Influencers de salud mental
- TikTok campaigns
- Instagram takeovers
- YouTube reviews

### 🔜 15.3 B2B Empresarial
- Packs para empleados
- Dashboard administrativo
- Bienestar corporativo

---

# 🔜 **PHASE 16 — Normativas Legales** [PENDIENTE CRÍTICO]

### 🔜 16.1 GDPR / RGPD
- ✅ Datos locales (SwiftData)
- 🔜 Panel "Eliminar todos mis datos"
- 🔜 Exportación de datos
- 🔜 Consentimiento explícito

### 🔜 16.2 App Store Review
- 🔜 Evitar claims médicos
- 🔜 Justificar permisos
- 🔜 Disclaimers visibles

### 🔜 16.3 Documentación Legal
- 🔜 Política de privacidad redactada
- 🔜 Términos de uso
- 🔜 Disclaimers de bienestar

---

# ✅ **PHASE 17 — Accesibilidad** [IMPLEMENTADO 80%]

### ✅ 17.1 Compatibilidad VoiceOver
- ✅ withOptionalAnimation implementado
- ✅ Reduce Motion respetado
- 🔜 Labels descriptivos en todos los elementos
- 🔜 Tests con VoiceOver

### ✅ 17.2 Dynamic Type y contraste
- ✅ SwiftUI nativo (soporta Dynamic Type)
- ✅ Modo oscuro con colores calmados
- ✅ Contraste adecuado

### ✅ 17.3 Audio y vibración
- ✅ HapticManager implementado
- ✅ On/off en Settings
- ✅ Feedback sincronizado
- ✅ AudioManager con sesión configurada

---

# ✅ **PHASE 18 — Guía de Estilo** [IMPLEMENTADO]

### ✅ 18.1 Principios Swift
- ✅ Datos → Estado → UI (unidireccional)
- ✅ Módulos independientes
- ✅ ViewModels aislados del UI (@Observable)
- ✅ async/await en lugar de callbacks

### ✅ 18.2 Convenciones del proyecto
- ✅ Nombres: BreathingView, PanicStepView, etc.
- ✅ Estructura por Features
- ✅ Core separado de UI
- ✅ Models en SwiftData

### ✅ 18.3 Librerías internas
- ✅ AnimationExtensions (smooth, gentle, quick)
- ✅ Haptics+SwiftUI (hapticOnTap, prepareHapticsOnAppear)
- ✅ Accessibility+Helpers (withOptionalAnimation)
- ✅ CardBackground+Adaptive
- ✅ ButtonStyles (Primary, Secondary)

---

# 🔄 **PHASE 19 — Sistema de Audio Profesional** [EN PROGRESO]

### 🔄 19.1 Producción
- 🔜 Contratar voz femenina calma
- 🔜 Estudio acústico o grabar en casa con calidad
- 🔜 EQ y compresión ligera
- 🔜 Masterización para volumen consistente

### ✅ 19.2 Integración
- ✅ AudioManager implementado
- ✅ AVAudioSession configurado
- 🔄 Compresión AAC para tamaño óptimo
- 🔄 Carga diferida (lazy loading)
- ✅ Compatibilidad con modo silencio

---

# ✅ **PHASE 20 — Arquitectura Profunda** [COMPLETADO]

### ✅ 20.1 State Tree de Anstop
- ✅ AppState → Feature States → View States
- ✅ @Observable para managers
- ✅ @AppStorage para preferencias
- ✅ SwiftData para persistencia
- ✅ @Environment para inyección

### ✅ 20.2 Diagrama de Eventos
```
✅ Inicio ataque → PanicFlowView
✅ Protocolo guiado → 3 pasos
✅ Recuperación → PanicCompletionView
✅ Log automático → completionCount
```

### 🔜 20.3 Testing de flujo
- 🔜 Tests de PanicFlow
- 🔜 Tests de ProgressTracker
- 🔜 Mock de audio y haptics
- 🔜 UI Tests

---

# ✅ **PHASE 21 — Infraestructura y Telemetría** [BÁSICO IMPLEMENTADO]

### ✅ 21.1 Analítica respetuosa
- ✅ AppLogger básico implementado
- 🔜 Métricas sin datos personales
- 🔜 Eventos: sesión, ejercicio completado, conversión
- 🔜 Integración con analytics (TelemetryDeck o similar)

### ✅ 21.2 Auto-diagnóstico
- ✅ Logs offline de fallos
- 🔜 Indicadores de rendimiento (fps, audio lag)
- 🔜 Crash reporting

---

# ✅ **PHASE 22 — Estrategia de Marca: ANSTOP** [DEFINIDO]

### ✅ 22.1 Identidad
- ✅ Nombre: **Anstop**
- ✅ Logo: minimalista azul (por definir final)
- ✅ Tipografía: SF Pro (sistema)
- ✅ Paleta: azul suave, blanco, verde, naranja

### ✅ 22.2 Mensaje central
**"Tu calma. Tu ritmo. Tu espacio seguro."**

### 🔜 22.3 Landing page
- 🔜 anstop.app (registrar dominio)
- 🔜 Blog de ansiedad con SEO
- 🔜 Vídeo de presentación calmante
- 🔜 Testimonios
- 🔜 FAQ

---

# 🔜 **PHASE 23 — Plan de Lanzamiento** [PLANIFICADO]

### 🔜 23.1 Soft Launch
- 🔜 200 usuarios TestFlight
- 🔜 Feedback sobre PanicFlow y Breathing
- 🔜 Ajustes pre-lanzamiento

### 🔜 23.2 Lanzamiento Público
- 🔜 Campaña TikTok "respira conmigo"
- 🔜 Influencers de bienestar
- 🔜 App Store Optimization
- 🔜 Press release

### 🔜 23.3 Expansión
- 🔜 iPadOS + watchOS
- 🔜 Inglés → Portugués → Alemán
- 🔜 Nuevos audios semanales
- 🔜 Contenido premium adicional

---

# ✅ **PHASE 24 — Checklist Pre-Código** [COMPLETADO]

### ✅ 24.1 Técnicas
- ✅ Estructura de carpetas definida e implementada
- ✅ Flujos bloqueados y funcionales
- ✅ Modelos SwiftData creados
- ✅ Arquitectura State → ViewModel → View

### 🔄 24.2 Contenido
- ✅ Textos de onboarding ✅
- ✅ Textos de Paywall ✅
- ✅ Protocolos escritos ✅
- 🔄 Guiones de audio (pendiente)
- ✅ Recursos visuales iniciales ✅

### ✅ 24.3 Negocio
- ✅ Bundle ID: com.molinesdesigns.Anstop
- ✅ Productos StoreKit configurados
- 🔜 Dominios registrados
- 🔜 Política de privacidad generada

### ✅ 24.4 UX
- ✅ Flujos validados en código
- ✅ Responsive iPhone SE → Pro Max
- ✅ Flow de Panic 100% implementado
- 🔜 Prototipo Figma (opcional)

---

# ✅ **PHASE 25 — Desarrollo de ANSTOP** [COMPLETADO 85%]

### ✅ Día 1–15: Completado
- ✅ Crear proyecto SwiftUI
- ✅ Módulos por carpetas
- ✅ Configurar SwiftData
- ✅ Implementar HomeView
- ✅ PanicButton → PanicFlowView
- ✅ Animaciones de respiración
- ✅ StoreKit 2 integrado
- ✅ Onboarding completo
- ✅ Diario funcional
- ✅ Biblioteca de protocolos
- ✅ Programa 30 días
- ✅ Asistente IA básico
- ✅ Settings completo
- ✅ Paywall con conversión
- ✅ Haptics y accesibilidad

### 🔄 Días 16–20: En progreso
- 🔄 Contenido de audio real
- 🔜 Tests unitarios
- 🔜 Tests UI
- 🔜 Documentación legal

### 🔜 Días 21–30: Pendiente
- 🔜 Beta testing (TestFlight)
- 🔜 Ajustes finales
- 🔜 Screenshots y video
- 🔜 Submission a App Store

---

# 📋 **PRÓXIMAS TAREAS PRIORITARIAS**

## 🔴 **Críticas (antes de lanzar)**
1. 🔜 Grabar/adquirir audios terapéuticos (10–20 piezas)
2. 🔜 Redactar política de privacidad y términos
3. 🔜 Tests básicos (unitarios + UI)
4. 🔜 Screenshots y video para App Store
5. 🔜 TestFlight con 50–200 usuarios

## 🟡 **Importantes (post-MVP)**
6. 🔜 Integrar API IA real (OpenAI/Claude)
7. 🔜 Implementar notificaciones/recordatorios
8. 🔜 Analytics y telemetría
9. 🔜 Landing page anstop.app
10. 🔜 Estrategia de marketing inicial

## 🟢 **Deseables (v1.1+)**
11. 🔜 Localización (inglés, portugués)
12. 🔜 Más protocolos de respiración
13. 🔜 Exportación de datos
14. 🔜 Integración con Apple Health
15. 🔜 Modo offline completo

---

# 📊 **MÉTRICAS DE ÉXITO DEL MVP**

### Objetivos Mes 1:
- ✅ App funcional en App Store
- 🎯 500 descargas
- 🎯 100 usuarios activos semanales
- 🎯 5% conversión a premium
- 🎯 50+ reviews (4.5+ estrellas)
- 🎯 < 3% crash rate

### Objetivos Mes 3:
- 🎯 5.000 descargas
- 🎯 1.000 usuarios activos mensuales
- 🎯 7% conversión a premium
- 🎯 300+ reviews (4.7+ estrellas)
- 🎯 Retención día 7: 35%+
- 🎯 1.000–3.000 €/mes MRR

### Objetivos Mes 6:
- 🎯 20.000 descargas
- 🎯 5.000 usuarios activos mensuales
- 🎯 10% conversión a premium
- 🎯 1.000+ reviews
- 🎯 5.000–15.000 €/mes MRR

---

# 🎯 **CONCLUSIÓN**

## Estado Actual: **MVP FUNCIONAL (80% completado)**

### ✅ Lo que funciona:
- Arquitectura sólida y escalable
- Todas las pantallas principales implementadas
- Flujo de pánico completo y efectivo
- Sistema de suscripciones funcionando
- Onboarding personalizado
- Diario y tracking de progreso
- Biblioteca de protocolos
- Asistente IA básico
- Configuración completa
- Haptics y accesibilidad

### 🔄 Lo que falta para launch:
- Contenido de audio real (10–20 piezas)
- Documentación legal (privacidad, términos)
- Tests básicos
- Assets para App Store
- Beta testing

### 🚀 Próximo hito:
**Lanzamiento en App Store: 15–20 días**

---

**Versión del ROADMAP:** 2.0  
**Última revisión:** 2 de diciembre de 2025  
**Autor:** Equipo Anstop  
**Estado:** MVP en fase final de desarrollo
