# 📋 Tareas Pendientes para Lanzamiento de Anstop
## Basado en README.md y ROADMAP.md
## Fecha: 2 de diciembre de 2025

---

## 🔴 CRÍTICAS - Antes de Lanzar (15-20 días)

### 1. Contenido de Audio Terapéutico (5-7 días)
**Prioridad:** MÁXIMA  
**Estado:** 0/20 audios

**Acciones:**
- [ ] Definir guiones para 20 audios (temas):
  - [ ] Respiración guiada básica (3-5 min)
  - [ ] Relajación muscular progresiva (5-7 min)
  - [ ] Visualización calmante (4-6 min)
  - [ ] Ansiedad nocturna (6-8 min)
  - [ ] Pánico social - preparación (3-5 min)
  - [ ] Grounding 5-4-3-2-1 guiado (4-5 min)
  - [ ] Meditación de escaneo corporal (7-10 min)
  - [ ] Técnica 4-7-8 (3 min)
  - [ ] Mindfulness para ansiedad (5-7 min)
  - [ ] Auto-compasión (5-6 min)
  - [ ] Gestión de pensamiento catastrófico (5 min)
  - [ ] Ejercicio de ancla al presente (3-4 min)
  - [ ] Relajación con respiración diafragmática (4-5 min)
  - [ ] Reducción de síntomas físicos (5 min)
  - [ ] Pre-sueño anti-ansiedad (8-10 min)
  - [ ] Manejo de anticipación ansiosa (4-5 min)
  - [ ] Desactivación del sistema nervioso (6-8 min)
  - [ ] Confianza y seguridad (5 min)
  - [ ] Aceptación de la ansiedad (6 min)
  - [ ] Cierre del día tranquilo (5-7 min)

- [ ] Contratar voz profesional (voz femenina calmante)
  - Opciones: Fiverr, Upwork, Voices.com
  - Presupuesto estimado: 300-500€ por 20 audios
- [ ] Grabar audios en estudio o con equipo profesional
- [ ] Masterización y normalización de audio
- [ ] Compresión a AAC (256kbps) para balance calidad/tamaño
- [ ] Integrar audios en app (AudioManager)
- [ ] Crear metadatos (título, duración, descripción, premium/free)
- [ ] Testing de reproducción en todos los dispositivos

**Tiempo estimado:** 5-7 días  
**Bloqueo:** CRÍTICO - sin esto no hay propuesta de valor completa

---

### 2. Documentación Legal (1 día)
**Prioridad:** CRÍTICA  
**Estado:** Pendiente

**Acciones:**
- [ ] Redactar Política de Privacidad:
  - [ ] Datos que se recopilan (locales con SwiftData)
  - [ ] Uso de datos (análisis de patrones local)
  - [ ] No compartimos datos con terceros
  - [ ] Derecho a eliminar datos
  - [ ] Cumplimiento GDPR/RGPD
  - [ ] Uso de StoreKit (compras)
  - [ ] Uso futuro de analytics (anónimo)

- [ ] Redactar Términos de Uso:
  - [ ] Disclaimers: no sustituye ayuda profesional
  - [ ] Contenido emocional, no clínico
  - [ ] Edad mínima (13+ o 17+ según App Store)
  - [ ] Condiciones de suscripción
  - [ ] Cancelación y reembolsos
  - [ ] Limitación de responsabilidad

- [ ] Crear página web simple para hosting:
  - anstop.app/privacy
  - anstop.app/terms
  - Opción: GitHub Pages, Netlify, o Notion público

- [ ] Integrar enlaces en SettingsView (ya preparado)
- [ ] Añadir disclaimer visible en Onboarding

**Tiempo estimado:** 1 día  
**Herramientas:** Plantillas de Termly, iubenda, o TermsFeed + adaptación

---

### 3. Tests Básicos (2-3 días)
**Prioridad:** ALTA  
**Estado:** 0% implementado

**Tests Unitarios a implementar:**
- [ ] PurchaseManager:
  - [ ] Test de isPremium con mock transactions
  - [ ] Test de loadProducts
  - [ ] Test de purchase flow

- [ ] AudioManager:
  - [ ] Test de play/pause/stop
  - [ ] Test de tracking de tiempo
  - [ ] Mock de AVAudioPlayer

- [ ] ProgramProgress:
  - [ ] Test de cálculo de racha
  - [ ] Test de completedDays
  - [ ] Test de progressPercentage

- [ ] HapticManager:
  - [ ] Test de trigger con diferentes tipos
  - [ ] Test de isEnabled toggle
  - [ ] Mock de haptic generators

**Tests de UI a implementar:**
- [ ] PanicFlowView:
  - [ ] Navegación entre pasos
  - [ ] Botón de avanzar funciona
  - [ ] Pantalla de completado se muestra
  - [ ] Contador incrementa

- [ ] OnboardingView:
  - [ ] Navegación completa
  - [ ] Guardado de preferencias
  - [ ] Slider funciona

- [ ] ThirtyDayProgramView:
  - [ ] Grid se renderiza
  - [ ] Días completados muestran checkmark
  - [ ] Navegación a DayDetailView

**Tiempo estimado:** 2-3 días  
**Framework:** XCTest (built-in)

---

### 4. Assets para App Store (1-2 días)
**Prioridad:** ALTA  
**Estado:** Pendiente

**Screenshots necesarios:**
- [ ] iPhone 17 Pro Max (6.9")
  - [ ] 1. HomeView con botón de pánico
  - [ ] 2. PanicFlowView paso 1 (respiración)
  - [ ] 3. ThirtyDayProgramView con progreso
  - [ ] 4. DailyJournalView con entradas
  - [ ] 5. LibraryView con protocolos
  - [ ] 6. AIHelperView con conversación

- [ ] iPhone SE (4.7") - opcional pero recomendado
  - [ ] Mismo set de screenshots

**Video Preview (opcional pero recomendado):**
- [ ] 15-30 segundos
- [ ] Mostrar flujo de pánico completo
- [ ] Música calmante de fondo
- [ ] Texto: "Tu calma, a un toque de distancia"
- [ ] Herramienta: iMovie o Keynote + QuickTime

**Icono de App:**
- [ ] Verificar que funciona en todos los tamaños
- [ ] Probar en fondos claros y oscuros
- [ ] Asegurar que es minimalista y reconocible

**Descripción de App Store:**
- [ ] Título: "Anstop - Ayuda para Ansiedad"
- [ ] Subtítulo: "Calma inmediata en momentos difíciles"
- [ ] Keywords: ansiedad, pánico, respiración, calma, mindfulness, meditación
- [ ] Descripción larga (4000 caracteres max):
  - Problema que resuelve
  - Características principales
  - Beneficios
  - Contenido premium
  - Disclaimer médico

**Tiempo estimado:** 1-2 días  
**Herramientas:** Simulator, Screenshot Framer, App Store Connect

---

### 5. Beta Testing con TestFlight (5-7 días)
**Prioridad:** ALTA  
**Estado:** No iniciado

**Preparación:**
- [ ] Crear build de release
- [ ] Configurar TestFlight en App Store Connect
- [ ] Preparar notas de release para testers
- [ ] Definir qué feedback necesitamos

**Reclutamiento de testers (50-200):**
- [ ] Familia y amigos (10-20)
- [ ] Reddit: r/anxiety, r/mentalhealth (español)
- [ ] Twitter/X: buscar comunidad de ansiedad
- [ ] Foros de salud mental en español
- [ ] Grupos de Facebook

**Testing focus:**
- [ ] Flow de pánico: ¿ayuda realmente?
- [ ] Onboarding: ¿es claro?
- [ ] Paywall: ¿convence?
- [ ] Bugs: crashes, audio, animaciones
- [ ] Usabilidad general
- [ ] ¿Falta algo crítico?

**Métricas a trackear:**
- [ ] % completado onboarding
- [ ] % usa PanicFlow al menos 1 vez
- [ ] % llega a paywall
- [ ] Crash rate
- [ ] Feedback cualitativo

**Tiempo estimado:** 5-7 días  
**Herramienta:** TestFlight (App Store Connect)

---

## 🟡 IMPORTANTES - Post-MVP (1-2 semanas después del launch)

### 6. Integración de IA Real
**Estado:** Mock implementado  
**Tiempo:** 2-3 días

**Acciones:**
- [ ] Elegir provider: OpenAI GPT-4o, Claude 3.5 Sonnet
- [ ] Crear cuenta y obtener API key
- [ ] Implementar cliente API en AIService
- [ ] Optimizar prompt system para ansiedad
- [ ] Añadir rate limiting (3-5 mensajes por sesión free)
- [ ] Manejo de errores (sin internet, API down)
- [ ] Testing con usuarios reales
- [ ] Premium: mensajes ilimitados

**Costo estimado:** $20-50/mes para 1000 MAU

---

### 7. Notificaciones y Recordatorios
**Estado:** UI preparada en Settings  
**Tiempo:** 2 días

**Acciones:**
- [ ] Solicitar permiso de notificaciones
- [ ] Implementar UNUserNotificationCenter
- [ ] Scheduler de recordatorios diarios
- [ ] Contenido de notificaciones personalizadas:
  - "¿Cómo te sientes hoy? Escribe en tu diario"
  - "Recuerda: 5 minutos de respiración pueden cambiar tu día"
  - "Tu racha es de X días, ¡sigue así!"
- [ ] Testing con diferentes horarios
- [ ] Opción de deshabilitar en Settings

---

### 8. Analytics y Telemetría
**Estado:** AppLogger básico  
**Tiempo:** 1-2 días

**Acciones:**
- [ ] Integrar TelemetryDeck (respetuoso con privacidad)
- [ ] Definir eventos clave:
  - App opened
  - Onboarding completed
  - Panic flow started/completed
  - Exercise completed
  - Paywall shown
  - Purchase attempted/completed
  - Feature used (journal, breathing, etc.)
- [ ] NO trackear: contenido del diario, conversaciones IA, datos personales
- [ ] Dashboard para métricas
- [ ] Análisis semanal

**Costo:** TelemetryDeck free tier (hasta 100k eventos/mes)

---

### 9. Landing Page
**Estado:** No iniciado  
**Tiempo:** 2-3 días

**Acciones:**
- [ ] Registrar dominio: anstop.app
- [ ] Diseñar landing simple (1 página):
  - Hero: "Tu calma, siempre contigo"
  - Problema: ansiedad y pánico
  - Solución: Anstop
  - Features principales
  - Screenshots
  - CTA: Download on App Store
  - Footer: Privacidad, Términos, Contacto
- [ ] SEO básico:
  - Title: "Anstop - App para Ansiedad y Ataques de Pánico"
  - Meta description
  - Keywords
  - Schema.org markup
- [ ] Hosting: Netlify, Vercel, o GitHub Pages
- [ ] Blog section (opcional): artículos sobre ansiedad

**Herramientas:** Framer, Webflow, o código HTML/CSS simple

---

### 10. Marketing Inicial
**Estado:** No iniciado  
**Tiempo:** Continuo

**Acciones:**
- [ ] Redes sociales:
  - [ ] Instagram: @anstop.app
  - [ ] TikTok: @anstop.app
  - [ ] Twitter/X: @anstop_app
- [ ] Contenido inicial (10-15 posts pre-launch):
  - Educación sobre ansiedad
  - Tips de respiración
  - Behind the scenes del desarrollo
  - Teasers de la app
- [ ] Post-launch:
  - Demo de features
  - Testimonios de usuarios
  - Casos de uso
- [ ] Influencers de salud mental (micro: 5k-50k followers)
- [ ] Community engagement: Reddit, foros

**Presupuesto:** Orgánico inicial, luego €50-100/mes en ads

---

## 🟢 DESEABLES - v1.1+ (1-3 meses post-launch)

### 11. Localización (Inglés)
**Tiempo:** 3-5 días

**Acciones:**
- [ ] Extraer todos los strings a Localizable.strings
- [ ] Traducir al inglés (profesional)
- [ ] Adaptar screenshots
- [ ] Testing con locale en_US

**Mercado potencial:** 10x más grande

---

### 12. Más Protocolos de Respiración
**Tiempo:** 1 día

**Acciones:**
- [ ] Implementar variantes:
  - 4-7-8 (Dr. Weil)
  - Box breathing (4-4-4-4)
  - 3-3-3 (rápido)
  - Coherencia cardíaca (5-5)
- [ ] Selector en BreathingView
- [ ] Animaciones ajustadas

---

### 13. Exportación de Datos
**Tiempo:** 2 días

**Acciones:**
- [ ] Exportar diario a PDF
- [ ] Incluir gráficos de progreso
- [ ] Compartir por email/mensaje
- [ ] Implementar en Settings

---

### 14. Apple Health Integration
**Tiempo:** 2-3 días

**Acciones:**
- [ ] Solicitar permiso HealthKit
- [ ] Escribir "Mindfulness Minutes" después de cada ejercicio
- [ ] Opción en Settings para habilitar/deshabilitar

---

### 15. Modo Offline Completo
**Tiempo:** 2-3 días

**Acciones:**
- [ ] Detectar conectividad
- [ ] Descargar audios premium para offline
- [ ] Cachear contenido de protocolos
- [ ] IA: mostrar mensaje "requiere internet"
- [ ] Indicador visual de modo offline

---

## 📊 Timeline Estimado

### Semana 1 (3-9 diciembre)
- **Días 1-2:** Redactar guiones de audio
- **Días 3-5:** Grabar y masterizar audios
- **Día 6:** Documentación legal
- **Día 7:** Integrar audios en app

### Semana 2 (10-16 diciembre)
- **Días 1-2:** Tests unitarios y UI
- **Día 3:** Screenshots y assets
- **Días 4-7:** Beta testing en TestFlight

### Semana 3 (17-23 diciembre)
- **Días 1-2:** Ajustes según feedback
- **Día 3:** Build final
- **Día 4:** Submission a App Store
- **Días 5-7:** Espera de review (1-3 días típico)

**🎯 Launch estimado: 20-23 de diciembre de 2025**

---

## 🎯 Prioridades Absolutas

Si solo tienes tiempo para lo mínimo:

1. **Audios terapéuticos** (al menos 10)
2. **Documentación legal** (obligatorio)
3. **Screenshots** (obligatorio para App Store)
4. **Beta testing** (aunque sea con 20 personas)

El resto se puede hacer post-launch como updates.

---

## 💡 Consejos

- **No esperes perfección:** Lanza con 10 audios, añade más en v1.1
- **Tests básicos son suficientes:** No necesitas 100% cobertura para v1.0
- **Marketing puede esperar:** Enfócate en producto sólido primero
- **Feedback es oro:** Los primeros 100 usuarios te dirán qué falta

---

**Documento creado:** 2 de diciembre de 2025  
**Próxima revisión:** Diaria durante las próximas 3 semanas  
**Owner:** Equipo Anstop
