# Anstop - Walkthrough del Proyecto

## Estado Actual

El proyecto **Anstop** es una aplicación iOS nativa (SwiftUI) diseñada para ayudar a usuarios con ansiedad y ataques de pánico.
Actualmente, el proyecto está en una fase avanzada de MVP, con las features core implementadas y compilando exitosamente.

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

### 5. Monetización

- **Paywall (`PaywallView`)**:
  - Diseño empático, no intrusivo.
  - Lista de beneficios.
  - Botones de compra y restauración.
- **Configuración**: Archivo `Configuration.storekit` para testing local.

## Verificación Técnica

- **Compilación**: ✅ Exitosa (Xcode 16.0+).
- **Simulador**: Probado en iPhone 16e.
- **Tests**: Manuales de navegación y flujos principales.

## Próximos Pasos (Roadmap)

1. **Fase 6: Legal & Privacidad**: Preparar textos y vistas para GDPR/Privacidad.
2. **Fase 8: Programa 30 Días**: Implementar estructura de curso diario.
3. **Contenido Real**: Reemplazar placeholders de audio y textos finales.
