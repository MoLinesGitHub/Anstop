# 🧘‍♂️ Anstop - App de Gestión de Ansiedad

Aplicación iOS para ayudar en tiempo real durante ataques de ansiedad y pánico.

## 📱 Estado Actual

✅ **MVP FUNCIONAL COMPLETADO (80%)**

### Características Implementadas:
- ✅ Estructura modular completa
- ✅ Modelos SwiftData (JournalEntry, AnxietyEvent, ProgramProgress, Protocol)
- ✅ HomeView con navegación completa
- ✅ PanicFlowView con 3 pasos guiados + pantalla de completado
- ✅ BreathingCircle con animación suave
- ✅ OnboardingView personalizado (3 pantallas)
- ✅ DailyJournalView con historial
- ✅ ThirtyDayProgramView con sistema de rachas
- ✅ LibraryView con 5 protocolos terapéuticos
- ✅ AIHelperView (chat conversacional básico)
- ✅ SettingsView completo
- ✅ PaywallView con dos variantes (completa y simple)
- ✅ PurchaseManager (StoreKit 2)
- ✅ AudioManager completo
- ✅ HapticManager con accesibilidad
- ✅ Sistema de extensiones (AnimationExtensions, Haptics+SwiftUI, etc.)

### 🔄 En Progreso:
- 🔄 Contenido de audio terapéutico (10-20 piezas)
- 🔄 Integración de IA real (OpenAI/Claude)

### 🔜 Pendiente para Launch:
- 🔜 Documentación legal (privacidad, términos)
- 🔜 Tests unitarios y UI
- 🔜 Screenshots y video para App Store
- 🔜 Beta testing (TestFlight)

## 🏗️ Estructura del Proyecto

```
/Volumes/SSD/xCode_Projects/Anstop/
├── ROADMAP.md                    # Roadmap completo del proyecto
├── SETUP_GUIDE.md                # Guía de configuración
├── README.md                     # Este archivo
└── Anstop/                       # Código fuente
    ├── App/
    │   └── AnstopApp.swift      # ✅ Entry point con SwiftData
    ├── Resources/
    │   └── Assets.xcassets/      # ✅ Iconos y colores
    ├── Features/                 # Módulos de funcionalidad
    │   ├── Home/                # ✅ Vista principal con banner premium
    │   ├── PanicButton/         # ✅ Flujo de pánico completo
    │   ├── Breathing/           # ✅ Animación de respiración
    │   ├── AudioGuides/         # ✅ Lista de audios
    │   ├── DailyJournal/        # ✅ Diario con historial
    │   ├── Exercises/           # ✅ Biblioteca de protocolos
    │   ├── AIHelper/            # ✅ Chat conversacional
    │   ├── ThirtyDayProgram/    # ✅ Programa con rachas
    │   ├── Onboarding/          # ✅ 3 pasos personalizados
    │   ├── Settings/            # ✅ Configuración completa
    │   └── Paywall/             # ✅ Dos variantes implementadas
    ├── Core/                     # Lógica central
    │   ├── Models/              # ✅ JournalEntry, AnxietyEvent, ProgramProgress, Protocol
    │   ├── AudioManager.swift   # ✅ Reproducción de audio
    │   ├── AppLogger.swift      # ✅ Sistema de logs
    │   ├── PurchaseManager/     # ✅ StoreKit 2 completo
    │   ├── Services/            # ✅ AIService
    │   ├── Managers/            # ✅ HapticManager
    │   ├── Extensions/          # ✅ AnimationExtensions, Haptics+SwiftUI, Accessibility
    │   └── Theme/               # ✅ Sistema de diseño
    └── UI/                       # Componentes UI reutilizables
        ├── PrimaryButtonStyle.swift       # ✅
        ├── SecondaryButtonStyle.swift     # ✅
        └── CardBackground+Adaptive.swift  # ✅
```

## 🚀 Cómo Abrir el Proyecto

### Opción 1: Configuración Manual en Xcode

1. **Abre Xcode 16.1+**
2. **File → Open**
3. **Selecciona:** `/Volumes/SSD/xCode_Projects/Anstop/Anstop.xcodeproj`
4. **Selecciona el simulador** iOS 18.0+
5. **⌘ + R** para ejecutar

### Opción 2: Script Automatizado

```bash
cd /Volumes/SSD/xCode_Projects/Anstop
open Anstop.xcodeproj
```

## ⚙️ Configuración Técnica

- **Swift:** 6.0
- **iOS Target:** 18.0+
- **Framework UI:** SwiftUI
- **Persistencia:** SwiftData (@Model)
- **Navegación:** NavigationStack
- **Arquitectura:** Modular MVVM con @Observable
- **Bundle ID:** com.molinesdesigns.anstop
- **Productos IAP:** premium.monthly, premium.yearly

## 🎯 Características Implementadas

### ✅ Pantallas Principales

#### 1. HomeView
- Botón principal "Estoy teniendo ansiedad"
- Banner premium para usuarios no premium
- Accesos rápidos a:
  - Respiración guiada
  - Grounding 5-4-3-2-1
  - Audio calmante
  - Diario del día
- Navegación completa a todas las secciones

#### 2. PanicFlowView (Estrella del MVP)
Flujo guiado en 3 pasos con animaciones suaves:
1. "Respira conmigo" (con BreathingCircle animado)
2. "Tu cuerpo está a salvo" (texto tranquilizador)
3. "Vamos a bajar tu ritmo" (con respiración)
- Pantalla de completado con CTA premium contextual
- Contador de completados persistente

#### 3. OnboardingView
- 3 pantallas empáticas y personalizadas
- Captura de nivel de ansiedad inicial (slider 1-10)
- Guardado en @AppStorage
- Navegación suave con animaciones

#### 4. DailyJournalView
- Nueva entrada por día
- Track de: estado de ánimo, nivel de estrés, calidad de sueño, notas
- Historial completo con SwiftData
- Eliminación de entradas con swipe
- Navegación a vista de historial completo

#### 5. ThirtyDayProgramView
- Grid visual de 30 días
- Sistema de rachas (streaks) automático
- Barra de progreso
- Navegación a contenido diario (DayDetailView)
- Progreso persistente con SwiftData

#### 6. LibraryView
- 5 protocolos terapéuticos completos:
  1. Grounding 5-4-3-2-1
  2. Respiración Progresiva
  3. Ansiedad Nocturna
  4. Pánico Social
  5. Reestructuración de Pensamiento
- Navegación a detalle con contenido completo

#### 7. AIHelperView
- Chat conversacional con IA
- Mensajes del usuario y asistente
- Indicador de "escribiendo..."
- Scroll automático
- Prompt optimizado para tono calmante

#### 8. SettingsView
- Gestión de suscripción premium
- Toggle de haptics
- Configuración de recordatorios (UI preparada)
- Gestión de datos (exportar, eliminar)
- Enlaces a privacidad y términos
- Información de la app

#### 9. PaywallView
- Dos variantes: completa (con countdown) y simple
- Testimonios de usuarios
- Estadísticas de eficacia
- Trial de 7 días destacado
- Integración completa con StoreKit 2
- Precios dinámicos

### ✅ Componentes y Sistemas

#### BreathingCircle
- Animación suave de respiración
- Ciclo de 4 segundos (inhalar/exhalar)
- Efecto visual calmante con degradado azul
- Scale animation con easeInOut

#### AudioManager (@Observable)
- play(_:) - reproducir audio
- pause() - pausar
- stop() - detener
- resume() - reanudar
- Tracking de tiempo actual y duración
- AVAudioSession configurado
- Compatible con modo silencio

#### PurchaseManager (@Observable)
- loadProducts() async
- purchase(_:) async throws
- restorePurchases() async
- isPremium computed property
- Verificación de transacciones
- Tracking de entitlements

#### HapticManager
- triggerImpact(style:intensity:)
- triggerNotification(type:)
- triggerSelection()
- warmUp() para reducir latencia
- Toggle global en Settings
- Respeta accesibilidad (Reduce Motion)

#### Extensiones y Helpers
- **AnimationExtensions**: .smooth, .gentle, .quick
- **Haptics+SwiftUI**: hapticOnTap, hapticOnAppear, prepareHapticsOnAppear
- **Accessibility+Helpers**: withOptionalAnimation
- **CardBackground+Adaptive**: fondo adaptativo con blur
- **ButtonStyles**: PrimaryButtonStyle, SecondaryButtonStyle

### ✅ Modelos SwiftData

```swift
@Model JournalEntry
- id: UUID
- date: Date
- mood: Int (1-5)
- stressLevel: Int (1-10)
- sleepQuality: Int (1-5)
- notes: String

@Model AnxietyEvent
- id: UUID
- date: Date
- intensity: Int (1-10)

@Model ProgramProgress
- id: UUID
- completedDays: [Int]
- startDate: Date
- lastCompletionDate: Date?
- currentStreak: Int

struct Protocol (Identifiable)
- id: UUID
- title: String
- description: String
- icon: String
- color: Color
- content: [String]
```

## 📋 Próximos Pasos (según README.md)

### 🔴 Críticos (antes de lanzar)
1. **Contenido de audio real** - Grabar/adquirir 10-20 audios terapéuticos
2. **Documentación legal** - Política de privacidad y términos de uso
3. **Tests** - Unitarios y UI básicos
4. **Assets para App Store** - Screenshots, video preview, descripción
5. **Beta testing** - TestFlight con 50-200 usuarios

### 🟡 Importantes (post-MVP)
6. **Integración de IA real** - OpenAI o Claude API
7. **Notificaciones** - Recordatorios diarios personalizados
8. **Analytics** - TelemetryDeck o similar (respetando privacidad)
9. **Landing page** - anstop.app con contenido SEO
10. **Marketing inicial** - Redes sociales, influencers

### 🟢 Deseables (v1.1+)
11. **Localización** - Inglés, portugués, alemán
12. **Más protocolos de respiración** - 4-7-8, box breathing
13. **Exportación de datos** - PDF del diario
14. **Apple Health** - Sincronización de mindfulness minutes
15. **Modo offline completo** - Todos los recursos descargables

## 🎨 Paleta de Colores

Según identidad de marca:

- **Principal:** Azul suave (#007AFF - system blue)
- **Secundario:** Verde para éxito (#34C759)
- **Acento:** Naranja para urgencia (#FF9500)
- **Fondo:** Blanco/Negro adaptativo (Light/Dark mode)
- **Tono:** Seguro, amable, directo (nunca clínico)

## 🧪 Testing

### Tests Implementados:
- 🔜 Unitarios (pendiente)
- 🔜 UI (pendiente)

### Tests Planificados:
- PanicFlowView: flujo completo
- PurchaseManager: compras mock
- AudioManager: reproducción
- ThirtyDayProgram: cálculo de rachas
- Accesibilidad: VoiceOver

## 📄 Licencia

Proyecto privado - En desarrollo

## 📞 Contacto

Para feedback o colaboración, contactar al equipo de desarrollo.

---

**Creado:** 24 de noviembre de 2025  
**Última actualización:** 2 de diciembre de 2025  
**Versión:** 1.0.0 (MVP en desarrollo - 80% completado)  
**Estado:** Listo para contenido y testing final

---

**Próximo hito:** Lanzamiento en App Store (15-20 días)
