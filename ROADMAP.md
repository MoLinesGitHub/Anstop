# 🚀 **ROADMAP COMPLETO – App de Ansiedad / Ataques de Pánico**
### *Objetivo: MVP en 6–8 semanas, escalable a 2.500–80.000 €/mes*

---

# PHASE 0 — **Fundamentos del negocio (1–2 días)**

### 0.1 Definir la propuesta de valor
- App que ayuda al usuario **en tiempo real** durante ansiedad o ataques de pánico.
- Contenido terapéutico: audio guías, respiración, grounding, técnicas instantáneas.
- Función estrella: **“Botón rojo”** → activación inmediata de protocolos guiados.

### 0.2 Modelo de monetización
- **Freemium**:
  - Gratis: herramientas básicas, respiración, diario, 1 guía de pánico.
  - Premium (5–10 €/mes o 60 €/año):  
    - Guías completas  
    - Programa de 30 días  
    - Ejercicios personalizados  
    - Asistente IA  
    - Sonidos + herramientas avanzadas  
    - Temas y personalización  

### 0.3 Identidad del producto
- Nombre corto, calmante, memorable: **Calma**, **Respira**, **Anxia**, **Alivia**, **PanicGo**…
- Paleta: azul suave, blanco, transparencias.
- Tono: seguro, amable, directo (nunca clínico).

---

# PHASE 1 — **Arquitectura del proyecto (1–2 días)**

### 1.1 Stack técnico
- **Swift 6.2**
- **SwiftUI**
- **Observation API (@Observable)**
- **NavigationStack**
- **Core Data + @Query** (diario + progreso)
- **StoreKit 2** (suscripciones)
- **AVFoundation** (audio)
- **BackgroundTasks** (recordatorio diario opcional)
- **CloudKit** para sincronización (v2)

### 1.2 Estructura modular
```
App/
 ├── Features/
 │    ├── PanicButton/
 │    ├── Breathing/
 │    ├── AudioGuides/
 │    ├── DailyJournal/
 │    ├── Exercises/
 │    ├── AIHelper/
 │    ├── Settings/
 │    └── Paywall/
 ├── Core/
 │    ├── Models/
 │    ├── DataStore/
 │    ├── PurchaseManager/
 │    └── Analytics/
 ├── UI/
 │    ├── Components/
 │    └── Theme/
 └── Resources/
```

### 1.3 Flujo principal
- HomeView  
  ↓  
- Panic Protocol (guía inmediata)  
  ↓  
- Ejercicios calmantes (respiración, grounding, audio)  
  ↓  
- Diario + Progreso  
  ↓  
- Paywall Premium  

---

# PHASE 2 — **Diseño de experiencia (3–5 días)**

### 2.1 Pantallas esenciales del MVP
1. **Onboarding**  
   - 3 pantallas, suaves, empáticas  
   - Preguntas sobre nivel de ansiedad → personalización inicial  

2. **HomeView**  
   - Botón grande: **“Estoy teniendo ansiedad”**  
   - Acceso rápido a:  
     - Respiración  
     - Grounding 5–4–3–2–1  
     - Audio calmante  
     - Diario del día  

3. **Panic Flow (la estrella)**  
   - Guía paso a paso:  
     - “Respira conmigo” (UI animada)  
     - “Tu cuerpo está a salvo”  
     - “Vamos a bajar tu ritmo”  
   - Tiempo estimado: 60–180 segundos  

4. **BreathingView**  
   - Círculo animado con easing  
   - Protocolos: 4–7–8, 4–4, 3–3–3  

5. **AudioGuidesView**  
   - Lista de audios  
   - Contenido freemium/premium  

6. **DailyJournalView**  
   - 1 pregunta por día (muy simple)  
   - Track: estrés, sueño, triggers  

7. **Paywall**  
   - Página evitando texto clínico  
   - “Ayuda inmediata cuando más la necesitas”  

### 2.2 Animaciones clave
- Pulsación calmada (scale con spring de 0.3)
- Ondas de respiración (trim + timing curves)
- Blur y degradados suaves

---

# PHASE 3 — **Implementación del MVP (3–4 semanas)**  
Arquitectura declarativa basada en datos.

---

## 3.1 **Core Data + @Query**
Modelos:
```swift
@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mood: Int
    var notes: String?
}

@Model
final class AnxietyEvent {
    @Attribute(.unique) var id: UUID
    var date: Date
    var intensity: Int
}
```

---

## 3.2 **Panic Protocol (flujo guiado)**
Estructura:
```swift
@Observable
final class PanicViewModel {
    var step: Int = 0
    var steps = PanicStep.all
}

struct PanicFlowView: View {
    @StateObject private var vm = PanicViewModel()

    var body: some View {
        TabView(selection: $vm.step) {
            ForEach(vm.steps) { step in
                PanicStepView(step: step)
            }
        }
        .tabViewStyle(.page)
    }
}
```

---

## 3.3 **Animación de respiración**
```swift
struct BreathingCircle: View {
    @State private var scale: CGFloat = 0.4

    var body: some View {
        Circle()
            .fill(.blue.opacity(0.3))
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    scale = 1.0
                }
            }
    }
}
```

---

## 3.4 **Audio Player**
```swift
final class AudioManager: ObservableObject {
    private var player: AVAudioPlayer?

    func play(_ name: String) {
        let url = Bundle.main.url(forResource: name, withExtension: "mp3")!
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}
```

---

## 3.5 **Suscripciones (StoreKit 2)**
```swift
@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchased: Set<Product.ID> = []

    func load() async throws {
        products = try await Product.products(for: ["premium.monthly", "premium.yearly"])
    }

    func buy(_ product: Product) async throws {
        let result = try await product.purchase()
        // Actualizar estado
    }
}
```

---

## 3.6 **Bloqueo de contenido → Premium**
```swift
struct PremiumLockView: View {
    @Environment(PurchaseManager.self) var pm

    var body: some View {
        if pm.isPremium {
            content
        } else {
            PaywallView()
        }
    }
}
```

---

## 3.7 **Onboarding personalizado**
- Guardar nivel inicial de ansiedad
- Ajustar recomendaciones de audio/respiración

---

# PHASE 4 — **Contenido terapéutico (1–2 semanas en paralelo)**

### 4.1 Audios calmantes
- 10–20 audios pendientes (gratis + premium)
- Duración 2–5 minutos
- Narradora femenina con voz tranquila

### 4.2 Protocolos escritos
- 5–6 mini rutinas guiadas:
  - Respiración
  - Grounding
  - Reestructuración inmediata
  - Ansiedad nocturna
  - Pánico social

---

# PHASE 5 — **IA (versión posterior, opcional)**

### MVP IA:
- Bot simple: “¿Cómo te sientes ahora?”
- Modelo: usar API OpenAI / Claude
- Prompt fijo para tono calmante

---

# PHASE 6 — **Política de privacidad & App Store (2 días)**

### Requisitos clave:
- Declarar contenido emocional (no clínico)
- No posicionarse como tratamiento médico
- Añadir disclaimers (“no sustituye profesionales”)
- Privacidad estricta (datos solo en local o en iCloud)

---

# PHASE 7 — **Marketing y crecimiento (continuo)**

### Growth:
- TikTok, Reels → contenido emocional
- SEO: “ataques de pánico qué hacer”
- Email onboarding
- Icono calmante + capturas cuidadas

### KPIs:
- CAC < 2 €
- Conversión premium 3–7%
- Retención día 7 > 30%
- 100 reviews 5⭐ el primer mes

---

# PHASE 8 — **Escalado a 80.000 €/mes**
- Lanzar **programa de 30 días** →

---

# PHASE 9 — **Expansión Multiplataforma (2–4 semanas)**  
### 9.1 iPadOS  
- Layout adaptado con columnas  
- Modo relajación con pantalla completa  
- Widgets de respiración  

### 9.2 watchOS  
- Complicación: “Respira ahora”  
- Mini protocolo de pánico (30–60s)  
- Sincronización con la app principal  

### 9.3 macOS  
- Port con SwiftUI multiplataforma  
- Ideal para usuarios que trabajan en escritorio  

---

# PHASE 10 — **Gamificación y Engagement (2 semanas)**  
### 10.1 Sistema de streaks  
- Días seguidos usando ejercicios  
- Recompensas visuales suaves (nada infantil)  

### 10.2 Logros emocionales  
- “Semana sin ataques”  
- “30 días de diario”  

### 10.3 Modo progreso  
- Visualización lineal y circular  
- Insights generados localmente con CoreML  

---

# PHASE 11 — **Integración con IA Avanzada (3–5 semanas)**  
### 11.1 Coaching emocional  
- Modelo LLM con tono calmante  
- Análisis del diario sin subir a servidores  

### 11.2 Sistema conversacional guiado  
- Preguntas que reducen ansiedad progresivamente  
- Feedback inmediato  

### 11.3 Motor de recomendaciones  
- “Hoy prueba respiración 4-7-8”  
- “Tu patrón nocturno indica estrés acumulado”  

---

# PHASE 12 — **Escalado Internacional (2–4 semanas por idioma)**  
### 12.1 Localización completa  
- Textos  
- Audio  
- Recursos visuales  

### 12.2 Idiomas con mayor demanda  
- Inglés  
- Portugués  
- Alemán  
- Francés  

### 12.3 Métodos de pago regionales  
- Apple Pay regional  
- Precios adaptados  

---

# PHASE 13 — **Control de Calidad + Certificaciones (continuo)**  
### 13.1 QA psicológico  
- Revisión de contenido por psicólogos  
- Validación de guías para evitar efectos no deseados  

### 13.2 QA técnico  
- Tests unitarios  
- Tests de UI  
- Stress tests para audio y animaciones  

---

# PHASE 14 — **Optimización de Ingresos (continuo)**  
### 14.1 Experimentos A/B  
- 3 variantes de paywall  
- 2 variantes de onboarding  

### 14.2 Funneling de conversión  
- Reducir fricción en primera sesión  
- Mejorar retención del día 1  

### 14.3 Paquetes y promociones  
- Oferta de bienvenida  
- Descuento por anual  

---

# PHASE 15 — **Partnerships & Ecosistema (2–6 semanas)**  
### 15.1 Colaboración con psicólogos  
- Sesiones grabadas premium  

### 15.2 Alianzas con influencers de salud mental  
- TikTok  
- Instagram  
- YouTube  

### 15.3 Integración con empresas (B2B)  
- Packs para empleados  
- Bienestar emocional empresarial  

---

# PHASE 16 — **Normativas Legales y Cumplimiento (1–2 semanas)**  
### 16.1 GDPR / RGPD  
- Minimizar recogida de datos  
- Solo datos locales o iCloud con protección  
- No almacenar datos de salud en servidores externos  
- Panel interno de “Eliminar todos mis datos”  

### 16.2 App Store Review Guidelines  
- Evitar claims médicos  
- Afirmaciones empáticas no terapéuticas  
- Justificar uso de audio, vibración y notificaciones  

### 16.3 Documentación Legal  
- Política de privacidad  
- Términos de uso  
- Disclaimers de bienestar  

---

# PHASE 17 — **Accesibilidad Avanzada (2 semanas)**  
### 17.1 Compatibilidad total con VoiceOver  
- Secuencia de enfoque correcta en PanicFlow  
- Botón rojo etiquetado como “Ayuda inmediata”  

### 17.2 Dynamic Type y alto contraste  
- Contenido adaptado a todas las escalas  
- Modo oscuro con colores calmados  

### 17.3 Audio y vibración  
- Feedback háptico suave sincronizado  
- Alternativas para usuarios sensibles a vibración  

---

# PHASE 18 — **Guía de Estilo y Estándares de Código (continuo)**  
### 18.1 Principios Swift  
- Datos → Estado → UI (unidireccional)  
- Módulos independientes  
- Evitar lógica en las Views  

### 18.2 Convenciones del proyecto  
- Nombres: BreathingView, PanicStepView, etc.  
- ViewModels aislados del UI  
- Reducir side-effects con async/await  

### 18.3 Librerías internas  
- Helpers de animación  
- Wrapper para AVAudioSession  
- Gestor unificado de haptics  

---

# PHASE 19 — **Sistema de Audio Profesional (2–4 semanas)**  
### 19.1 Producción  
- Voz femenina calma  
- Estudio acústico básico  
- EQ y compresión ligera  

### 19.2 Integración  
- Compresión AAC para tamaño óptimo  
- Carga diferida (lazy loading)  
- Compatibilidad con modo silencio del iPhone  

---

# PHASE 20 — **Arquitectura Profunda (2 semanas)**  
### 20.1 State Tree de Anstop  
- “AppState” → “FeatureState” → “ViewState”  
- Estados guardables y restaurables  

### 20.2 Diagrama de Eventos  
- Inicio del ataque → Protocolo guiado → Recuperación  
- Log automático de episodio (privado local)  

### 20.3 Testing de flujo  
- Tests de PanicFlow  
- Tests de ProgressTracker  
- Mock de audio y haptics  

---

# PHASE 21 — **Infraestructura y Telemetría Ética (1 semana)**  
### 21.1 Analítica respetuosa  
- Métricas sin datos personales  
- Eventos: sesión iniciada, ejercicio completado, conversión premium  

### 21.2 Auto-diagnóstico  
- Logs offline de fallos  
- Indicadores de rendimiento (fps, audio lag)  

---

# PHASE 22 — **Estrategia de Marca: ANSTOP (2 semanas)**  
### 22.1 Identidad  
- Logo minimalista azul/verde  
- Tipografía SF Pro + variantes suaves  

### 22.2 Mensaje central  
“Tu calma. Tu ritmo. Tu espacio seguro.”  

### 22.3 Landing page de lanzamiento  
- anstop.app  
- Blog de ansiedad con SEO  
- Vídeo de presentación calmante  

---

# PHASE 23 — **Plan de Lanzamiento en 3 Niveles**  
### 23.1 Suave (Soft Launch)  
- 200 usuarios TestFlight  
- Feedback sobre PanicFlow y Breathing  

### 23.2 Lanzamiento Público  
- Campaña TikTok “respira conmigo”  
- Influencers de bienestar  
- App Store Optimization  

### 23.3 Expansión  
- iPadOS + watchOS  
- Inglés → Portugués → Alemán  
- Añadir nuevos audios semanales  

---

# PHASE 24 — **Checklist Final Antes de Escribir Una Sola Línea de Código**  
### 24.1 Técnicas  
- Estructura de carpetas definida  
- Flujos bloqueados  
- Modelos Core Data creados  
- Arquitectura lista (State → ViewModel → View)  

### 24.2 Contenido  
- Guiones de audio del Panic Kit  
- Textos de onboarding  
- Textos de Paywall  
- Recursos visuales iniciales  

### 24.3 Negocio  
- ID del bundle: com.anstop.app  
- Productos StoreKit configurados  
- Página web y dominios  
- Política de privacidad generada  

### 24.4 UX  
- Prototipo completo en Figma  
- Versiones para iPhone SE → Pro Max  
- Flow de Panic 100% validado  

---

# PHASE 25 — **Inicio del Desarrollo de ANSTOP (Día 1)**  
- Crear nuevo proyecto SwiftUI  
- Añadir módulos por carpetas  
- Configurar Core Data  
- Implementar HomeView minimal  
- Crear PanicButton → navegación directa  
- Ensayo de primeras animaciones  

---
