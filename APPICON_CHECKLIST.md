# ✅ CHECKLIST DE VERIFICACIÓN VISUAL EN XCODE

## 🎯 Cómo verificar que el AppIcon está correctamente configurado

### 1️⃣ Abrir el Asset Catalog
1. En el navegador de Xcode (panel izquierdo), expandir:
   ```
   Anstop
   ├─ Resources
   │  └─ Assets.xcassets
   │     └─ AppIcon  ← CLIC AQUÍ
   ```

### 2️⃣ Verificar iOS (Universal)
Debes ver **TODAS** estas casillas llenas (sin espacios en blanco):

```
iOS AppIcon:
┌─────────────────────────────────────────────────────┐
│ iPhone Notification      20pt    [●] @2x  [●] @3x  │
│ iPhone Settings          29pt    [●] @2x  [●] @3x  │
│ iPhone Spotlight         40pt    [●] @2x  [●] @3x  │
│ iPhone App               60pt    [●] @2x  [●] @3x  │
│ iPad Notifications       20pt    [●] @2x            │
│ iPad Settings            29pt    [●] @2x            │
│ iPad Spotlight           40pt    [●] @2x            │
│ iPad App                 76pt    [●] @2x            │
│ iPad Pro (12.9-inch)     83.5pt  [●] @2x            │
│ App Store                1024pt  [●]                │
└─────────────────────────────────────────────────────┘
```

### 3️⃣ Verificar watchOS (si aparece)
Si hay una sección watchOS, verificar que las casillas principales están llenas:

```
watchOS AppIcon:
┌─────────────────────────────────────────────────────┐
│ Notification Center      24pt, 27.5pt, 29pt         │
│ Home Screen              40pt, 44pt, 50pt           │
│ Short Look               86pt, 98pt, 108pt          │
│ App Store                1024pt                      │
└─────────────────────────────────────────────────────┘
```

### 4️⃣ Verificar macOS (si aparece)
Si hay una sección macOS:

```
macOS AppIcon:
┌─────────────────────────────────────────────────────┐
│ 16pt, 32pt, 128pt, 256pt, 512pt                    │
│ Con @1x y @2x según corresponda                     │
└─────────────────────────────────────────────────────┘
```

### 5️⃣ Verificar que NO hay warnings
En la parte superior del editor del AppIcon **NO** debe aparecer:

❌ **INCORRECTO**:
```
⚠️ The app icon set "AppIcon" has XX unassigned children
⚠️ A 60x60@2x app icon is required for iPhone apps targeting iOS 18.0
```

✅ **CORRECTO**:
```
(Sin mensajes de advertencia)
```

### 6️⃣ Compilar el proyecto
Presionar `Cmd + B` y verificar que:
- ✅ Build succeed (sin errores)
- ✅ Sin warnings de "Missing app icon"
- ✅ Sin errores de asset catalog

### 7️⃣ Ejecutar en simulador
1. Seleccionar un simulador (iPhone 16 Pro, por ejemplo)
2. Presionar `Cmd + R` para ejecutar
3. Cuando la app se instale, **SALIR** de la app (Home button)
4. Verificar que el **icono aparece correctamente** en el home screen

### 8️⃣ Verificar Dark Mode
1. En el simulador, ir a: Settings → Developer → Dark Appearance
2. Activar/desactivar y verificar que el icono se adapta

---

## ❌ Problemas Comunes y Soluciones

### "The app icon set has unassigned children"
**Solución**: Este mensaje NO debería aparecer. Si aparece:
1. Cerrar Xcode
2. Borrar DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
3. Reabrir Xcode
4. Limpiar build: `Cmd + Shift + K`
5. Compilar: `Cmd + B`

### "A 60x60@2x app icon is required"
**Solución**: Este error NO debería aparecer porque `120-light 1.png` está asignado.
Si aparece, verificar que el archivo existe:
```bash
ls -lh "Anstop/Resources/Assets.xcassets/AppIcon.appiconset/120-light 1.png"
```

### El icono no aparece en el simulador
**Solución**:
1. Borrar la app del simulador (long press → Delete)
2. En Xcode: Product → Clean Build Folder (`Cmd + Shift + K`)
3. Compilar y ejecutar nuevamente

---

## ✅ Todo Correcto Si...

- [x] No hay casillas vacías en AppIcon
- [x] No hay warnings amarillos ⚠️
- [x] El build compila sin errores
- [x] El icono aparece en el simulador
- [x] El icono se adapta a dark mode
- [x] El icono de 1024x1024 está presente (App Store)

---

## 📄 Archivos de Referencia

Para más detalles, consultar:
- **Reporte completo**: `/Volumes/SSD/xCode_Projects/Anstop/APPICON_REPORT.md`
- **Resumen de iconos**: `AppIcon.appiconset/ICONS_SUMMARY.txt`
- **Contents.json**: `AppIcon.appiconset/Contents.json`

---

**Última actualización**: 2 de diciembre de 2025
