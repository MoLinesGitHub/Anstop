# 🧘‍♂️ Anstop - App de Gestión de Ansiedad

Aplicación iOS para ayudar en tiempo real durante ataques de ansiedad y pánico.

## 📱 Estado Actual

✅ **PHASE 25 del ROADMAP completada:**

- Estructura modular de carpetas implementada
- Modelos SwiftData (JournalEntry, AnxietyEvent)
- HomeView con botón de pánico
- PanicFlowView con flujo guiado paso a paso
- BreathingCircle con animación suave

## 🏗️ Estructura del Proyecto

```
/Volumes/SSD/xCode_Projects/Anstop/
├── ROADMAP.md                    # Roadmap completo del proyecto
├── SETUP_GUIDE.md                # Guía de configuración
├── README.md                     # Este archivo
└── Anstop/                       # Código fuente
    ├── AnstopApp.swift          # ✅ Entry point con SwiftData
    ├── Assets.xcassets/          # ✅ Iconos y colores
    ├── Info.plist               # ✅ Configuración de la app
    ├── Features/                 # Módulos de funcionalidad
    │   ├── Home/                # ✅ Vista principal
    │   ├── PanicButton/         # ✅ Flujo de pánico
    │   ├── Breathing/           # ✅ Animación de respiración
    │   ├── AudioGuides/         # 🔜 Próximamente
    │   ├── DailyJournal/        # 🔜 Próximamente
    │   ├── Exercises/           # 🔜 Próximamente
    │   ├── AIHelper/            # 🔜 Próximamente
    │   ├── Settings/            # 🔜 Próximamente
    │   └── Paywall/             # 🔜 Próximamente
    ├── Core/                     # Lógica central
    │   ├── Models/              # ✅ JournalEntry, AnxietyEvent
    │   ├── DataStore/           # 🔜 Gestión de datos
    │   ├── PurchaseManager/     # 🔜 StoreKit 2
    │   └── Analytics/           # 🔜 Telemetría
    ├── UI/                       # Componentes UI reutilizables
    │   ├── Components/          # 🔜 Componentes compartidos
    │   └── Theme/               # 🔜 Sistema de diseño
    └── Resources/                # Recursos estáticos
```

## 🚀 Cómo Abrir el Proyecto

### Opción 1: Configuración Manual en Xcode

1. **Abre Xcode 16.1+**
2. **File → New → Project**
3. **Selecciona:** iOS → App
4. **Configura:**
   - Product Name: `Anstop`
   - Organization Identifier: `com.molinesdesigns`
   - Bundle Identifier: `com.molinesdesigns.anstop`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `None`
5. **Guarda en:** `/Volumes/SSD/xCode_Projects/Anstop`
6. **Elimina** los archivos auto-generados (ContentView.swift, etc.)
7. **Arrastra** la carpeta `Anstop/` al navegador de proyectos
8. **Marca:** "Create groups" y añade al target "Anstop"
9. **Asegúrate** que el Deployment Target sea iOS 18.0

### Opción 2: Script Automatizado

```bash
cd /Volumes/SSD/xCode_Projects/Anstop
./open_xcode.scpt
```

## ⚙️ Configuración Técnica

- **Swift:** 6.0
- **iOS Target:** 18.0+
- **Framework UI:** SwiftUI
- **Persistencia:** SwiftData (@Model)
- **Navegación:** NavigationStack
- **Arquitectura:** Modular MVVM
- **Bundle ID:** com.anstop.app

## 🎯 Características Implementadas

### ✅ HomeView

- Botón principal "Estoy teniendo ansiedad"
- Accesos rápidos a:
  - Respiración
  - Grounding 5-4-3-2-1
  - Audio calmante
  - Diario del día

### ✅ PanicFlowView

Flujo guiado en 3 pasos:

1. "Respira conmigo" (con animación)
2. "Tu cuerpo está a salvo"
3. "Vamos a bajar tu ritmo"

### ✅ BreathingCircle

- Animación suave de respiración
- Ciclo de 4 segundos
- Efecto visual calmante con degradado azul

### ✅ Modelos SwiftData

- `JournalEntry`: Diario de emociones
- `AnxietyEvent`: Registro de episodios de ansiedad

## 📋 Próximos Pasos (según ROADMAP)

1. **Implementar AudioManager** (PHASE 3.4)
2. **Crear DailyJournalView** (PHASE 2.1.6)
3. **Configurar StoreKit 2** (PHASE 3.5)
4. **Implementar Paywall** (PHASE 2.1.7)
5. **Añadir contenido terapéutico** (PHASE 4)

## 🎨 Paleta de Colores

Según PHASE 0.3:

- **Principal:** Azul suave, calmante
- **Secundario:** Blanco, transparencias
- **Tono:** Seguro, amable, directo

## 📄 Licencia

Proyecto privado - En desarrollo

---

**Creado:** 2025-11-24  
**Versión:** 1.0.0 (MVP en desarrollo)
