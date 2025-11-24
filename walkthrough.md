# Anstop - Walkthrough del Proyecto

## Estado Actual

El proyecto **Anstop** es una aplicación iOS nativa (SwiftUI) diseñada para ayudar a usuarios con ansiedad y ataques de pánico.
Actualmente, el proyecto está en una **fase avanzada de MVP**, con todas las features core implementadas y compilando exitosamente.

## Features Implementadas

### 1. Core & Arquitectura

- **`AnstopApp.swift`**: Punto de entrada. Gestiona el flujo inicial (Onboarding vs Home) y configura SwiftData y PurchaseManager.
- **`AudioManager.swift`**: Gestor de reproducción de audio con `AVFoundation`.
- **`PurchaseManager.swift`**: Gestión de suscripciones con StoreKit 2 (`premium.monthly`, `premium.yearly`).
- **Persistencia**: SwiftData para `JournalEntry` y `AnxietyEvent`.

### 2. Flujos de Usuario

- **Onboarding (`OnboardingView`)**:
  - 3 pantallas de bienvenida empática.
  - Evaluación inicial de ansiedad (1-10).
  - Personalización (nombre).
  - Persistencia de estado con `AppStorage`.
- **Home (`HomeView`)**:
  - Botón de pánico (navegación a `PanicFlowView`).
  - Accesos rápidos a: Respiración, Grounding, Audio, Diario, Biblioteca, IA.
  - Icono de configuración en la barra de navegación.

### 3. Herramientas de Ansiedad

- **Panic Flow (`PanicFlowView`)**: Guía paso a paso para ataques de pánico.
- **Respiración (`BreathingView`)**:
  - Animación visual `BreathingCircle`.
  - Protocolos: 4-7-8, 4-4, 3-3-3.
- **Grounding (`GroundingView`)**:
  - Técnica 5-4-3-2-1 interactiva.
  - Guía sensorial paso a paso.
- **Audio Guías (`AudioGuidesView`)**:
  - Lista de audios calmantes.
  - Bloqueo de contenido Premium.
- **Diario (`DailyJournalView`)**:
  - Registro de estado de ánimo y notas.
  - Historial persistente.

### 4. Contenido Terapéutico & IA

- **Biblioteca (`LibraryView`)**:
  - Lista de protocolos escritos (`Protocol.swift`).
  - Detalle paso a paso (`ProtocolDetailView`).
  - Contenido inicial: Reestructuración Cognitiva, Ansiedad Nocturna, Pánico Social.
- **AI Helper (`AIHelperView`)**:
  - Chatbot de apoyo emocional.
  - Servicio Mock (`AIService`) con respuestas empáticas predefinidas.
  - UI de chat moderna con indicador de escritura.

### 5. Legal & Privacidad

- **Settings (`SettingsView`)**:
  - Política de Privacidad (Enfoque: datos locales, sin servidores).
  - Términos de Uso con disclaimer médico claro.
  - Gestión de datos: Botón "Borrar todos mis datos" (GDPR).
  - Información de la app.
- **`LegalData.swift`**: Textos legales completos y listos para revisión profesional.

### 6. Monetización

- **Paywall (`PaywallView`)**:
  - Diseño empático, no intrusivo.
  - Lista de beneficios.
  - Botones de compra y restauración.
- **Configuración**: Archivo `Configuration.storekit` para testing local.

## Verificación Técnica

- **Compilación**: ✅ Exitosa (Xcode 16.0+).
- **Simulador**: Probado en iPhone 16e.
- **Tests**: Manuales de navegación y flujos principales.

## Estado del Roadmap

### ✅ Completado

- **Fase 1**: Arquitectura del proyecto
- **Fase 2**: Diseño de experiencia (Onboarding, Home, Panic Flow, etc.)
- **Fase 3**: Implementación del MVP (Core Data, Panic Protocol, Breathing, Audio, Suscripciones)
- **Fase 4**: Contenido terapéutico (Biblioteca de protocolos)
- **Fase 5**: IA Helper (MVP con Mock)
- **Fase 6**: Legal y Privacidad (Políticas, Términos, GDPR)

### 📋 Pendiente (Próximas Fases)

- **Fase 7**: Marketing y crecimiento
- **Fase 8**: Programa de 30 Días
- **Contenido Real**: Reemplazar placeholders de audio con grabaciones profesionales

## Próximos Pasos Recomendados

1. **Testing Manual Exhaustivo**: Probar todos los flujos en el simulador.
2. **Programa de 30 Días (Fase 8)**: Implementar estructura de curso diario.
3. **Contenido de Audio**: Grabar o adquirir audios profesionales.
4. **TestFlight**: Preparar para beta testing con usuarios reales.
