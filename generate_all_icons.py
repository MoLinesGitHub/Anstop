#!/usr/bin/env python3
"""
Script para generar todos los iconos del AppIcon desde el 1024x1024
y actualizar Contents.json con appearances (Any, Dark, Tinted)
"""

import json
import os
import subprocess
from pathlib import Path

# Directorio del AppIcon
APPICON_DIR = Path(
    "/Volumes/SSD/xCode_Projects/Anstop/Anstop/Resources/Assets.xcassets/AppIcon.appiconset"
)

# Iconos base (1024x1024)
BASE_LIGHT = APPICON_DIR / "1024-light.png"
BASE_DARK = APPICON_DIR / "1024-dark.png"

# Definir todos los tamaños necesarios para iOS, watchOS y macOS
ICON_SIZES = {
    # iOS - iPhone & iPad
    "ios": [
        {"size": "20x20", "scale": "2x", "pixels": 40, "idiom": "iphone"},
        {"size": "20x20", "scale": "3x", "pixels": 60, "idiom": "iphone"},
        {"size": "29x29", "scale": "2x", "pixels": 58, "idiom": "iphone"},
        {"size": "29x29", "scale": "3x", "pixels": 87, "idiom": "iphone"},
        {"size": "38x38", "scale": "2x", "pixels": 76, "idiom": "iphone"},
        {"size": "38x38", "scale": "3x", "pixels": 114, "idiom": "iphone"},
        {"size": "40x40", "scale": "2x", "pixels": 80, "idiom": "iphone"},
        {"size": "40x40", "scale": "3x", "pixels": 120, "idiom": "iphone"},
        {"size": "60x60", "scale": "2x", "pixels": 120, "idiom": "iphone"},
        {"size": "60x60", "scale": "3x", "pixels": 180, "idiom": "iphone"},
        {"size": "64x64", "scale": "2x", "pixels": 128, "idiom": "iphone"},
        {"size": "64x64", "scale": "3x", "pixels": 192, "idiom": "iphone"},
        {"size": "68x68", "scale": "2x", "pixels": 136, "idiom": "iphone"},
        {"size": "76x76", "scale": "2x", "pixels": 152, "idiom": "ipad"},
        {"size": "83.5x83.5", "scale": "2x", "pixels": 167, "idiom": "ipad"},
        {"size": "1024x1024", "scale": "1x", "pixels": 1024, "idiom": "ios-marketing"},
    ],
    # watchOS
    "watchos": [
        {
            "size": "24x24",
            "scale": "2x",
            "pixels": 48,
            "idiom": "watch",
            "role": "notificationCenter",
            "subtype": "38mm",
        },
        {
            "size": "27.5x27.5",
            "scale": "2x",
            "pixels": 55,
            "idiom": "watch",
            "role": "notificationCenter",
            "subtype": "42mm",
        },
        {
            "size": "29x29",
            "scale": "2x",
            "pixels": 58,
            "idiom": "watch",
            "role": "companionSettings",
        },
        {
            "size": "29x29",
            "scale": "3x",
            "pixels": 87,
            "idiom": "watch",
            "role": "companionSettings",
        },
        {
            "size": "33x33",
            "scale": "2x",
            "pixels": 66,
            "idiom": "watch",
            "role": "notificationCenter",
            "subtype": "45mm",
        },
        {
            "size": "40x40",
            "scale": "2x",
            "pixels": 80,
            "idiom": "watch",
            "role": "appLauncher",
            "subtype": "38mm",
        },
        {
            "size": "44x44",
            "scale": "2x",
            "pixels": 88,
            "idiom": "watch",
            "role": "appLauncher",
            "subtype": "40mm",
        },
        {
            "size": "46x46",
            "scale": "2x",
            "pixels": 92,
            "idiom": "watch",
            "role": "appLauncher",
            "subtype": "41mm",
        },
        {
            "size": "50x50",
            "scale": "2x",
            "pixels": 100,
            "idiom": "watch",
            "role": "appLauncher",
            "subtype": "44mm",
        },
        {
            "size": "51x51",
            "scale": "2x",
            "pixels": 102,
            "idiom": "watch",
            "role": "appLauncher",
            "subtype": "45mm",
        },
        {
            "size": "54x54",
            "scale": "2x",
            "pixels": 108,
            "idiom": "watch",
            "role": "appLauncher",
            "subtype": "49mm",
        },
        {
            "size": "86x86",
            "scale": "2x",
            "pixels": 172,
            "idiom": "watch",
            "role": "quickLook",
            "subtype": "38mm",
        },
        {
            "size": "98x98",
            "scale": "2x",
            "pixels": 196,
            "idiom": "watch",
            "role": "quickLook",
            "subtype": "42mm",
        },
        {
            "size": "108x108",
            "scale": "2x",
            "pixels": 216,
            "idiom": "watch",
            "role": "quickLook",
            "subtype": "44mm",
        },
        {
            "size": "117x117",
            "scale": "2x",
            "pixels": 234,
            "idiom": "watch",
            "role": "quickLook",
            "subtype": "45mm",
        },
        {
            "size": "129x129",
            "scale": "2x",
            "pixels": 258,
            "idiom": "watch",
            "role": "quickLook",
            "subtype": "49mm",
        },
        {
            "size": "1024x1024",
            "scale": "1x",
            "pixels": 1024,
            "idiom": "watch-marketing",
        },
    ],
    # macOS
    "macos": [
        {"size": "16x16", "scale": "1x", "pixels": 16, "idiom": "mac"},
        {"size": "16x16", "scale": "2x", "pixels": 32, "idiom": "mac"},
        {"size": "32x32", "scale": "1x", "pixels": 32, "idiom": "mac"},
        {"size": "32x32", "scale": "2x", "pixels": 64, "idiom": "mac"},
        {"size": "128x128", "scale": "1x", "pixels": 128, "idiom": "mac"},
        {"size": "128x128", "scale": "2x", "pixels": 256, "idiom": "mac"},
        {"size": "256x256", "scale": "1x", "pixels": 256, "idiom": "mac"},
        {"size": "256x256", "scale": "2x", "pixels": 512, "idiom": "mac"},
        {"size": "512x512", "scale": "1x", "pixels": 512, "idiom": "mac"},
        {"size": "512x512", "scale": "2x", "pixels": 1024, "idiom": "mac"},
    ],
}


def resize_image(source, output, size):
    """Redimensiona una imagen usando sips"""
    try:
        subprocess.run(
            ["sips", "-z", str(size), str(size), str(source), "--out", str(output)],
            check=True,
            capture_output=True,
        )
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error redimensionando {output}: {e}")
        return False


def adjust_brightness(source, output, brightness_factor):
    """Ajusta el brillo de una imagen para crear variante Tinted"""
    try:
        # Tinted = versión ligeramente más clara/desaturada
        subprocess.run(
            [
                "sips",
                "-s",
                "brightness",
                str(brightness_factor),
                str(source),
                "--out",
                str(output),
            ],
            check=True,
            capture_output=True,
        )
        return True
    except subprocess.CalledProcessError:
        # Si falla, copiar el archivo
        subprocess.run(["cp", str(source), str(output)], check=True)
        return True


def generate_all_icons():
    """Genera todos los iconos necesarios desde el 1024x1024"""
    print("🎨 Generando iconos desde 1024x1024...")

    if not BASE_LIGHT.exists():
        print(f"❌ No existe {BASE_LIGHT}")
        return False

    if not BASE_DARK.exists():
        print(f"❌ No existe {BASE_DARK}")
        return False

    generated_count = 0

    # Recopilar todos los tamaños únicos
    all_sizes = set()
    for platform in ICON_SIZES.values():
        for icon in platform:
            all_sizes.add(icon["pixels"])

    all_sizes = sorted(all_sizes)

    print(f"📊 Tamaños únicos a generar: {len(all_sizes)}")
    print(f"   {all_sizes}")

    for size in all_sizes:
        # Generar versión Any (desde light)
        filename_any = f"{size}.png"
        filepath_any = APPICON_DIR / filename_any

        if not filepath_any.exists():
            print(f"  Generando {filename_any}...")
            if resize_image(BASE_LIGHT, filepath_any, size):
                generated_count += 1

        # Generar versión Light
        filename_light = f"{size}-light.png"
        filepath_light = APPICON_DIR / filename_light

        if not filepath_light.exists():
            print(f"  Generando {filename_light}...")
            if resize_image(BASE_LIGHT, filepath_light, size):
                generated_count += 1

        # Generar versión Dark
        filename_dark = f"{size}-dark.png"
        filepath_dark = APPICON_DIR / filename_dark

        if not filepath_dark.exists():
            print(f"  Generando {filename_dark}...")
            if resize_image(BASE_DARK, filepath_dark, size):
                generated_count += 1

        # Generar versión Tinted (brightness +0.1 desde light)
        filename_tinted = f"{size}-tinted.png"
        filepath_tinted = APPICON_DIR / filename_tinted

        if not filepath_tinted.exists():
            print(f"  Generando {filename_tinted}...")
            if adjust_brightness(
                filepath_light if filepath_light.exists() else filepath_any,
                filepath_tinted,
                0.1,
            ):
                generated_count += 1

    print(f"✅ Generados {generated_count} iconos nuevos")
    return True


def create_contents_json():
    """Crea el Contents.json con todas las appearances"""
    print("\n📝 Creando Contents.json con appearances...")

    images = []

    # Procesar cada plataforma
    for platform, icons in ICON_SIZES.items():
        for icon in icons:
            size = icon["size"]
            scale = icon["scale"]
            pixels = icon["pixels"]
            idiom = icon["idiom"]

            # Información adicional para watchOS
            extra_attrs = {}
            if "role" in icon:
                extra_attrs["role"] = icon["role"]
            if "subtype" in icon:
                extra_attrs["subtype"] = icon["subtype"]

            # Crear entrada para cada appearance
            appearances = [
                {"appearance": "luminosity", "value": "light"},
                {"appearance": "luminosity", "value": "dark"},
            ]

            # iOS también soporta tinted
            if platform == "ios":
                appearances.append({"appearance": "luminosity", "value": "tinted"})

            # 1. Versión Light
            entry_light = {
                "filename": f"{pixels}-light.png",
                "idiom": idiom,
                "scale": scale,
                "size": size,
                "appearances": [appearances[0]],  # light
            }
            entry_light.update(extra_attrs)
            images.append(entry_light)

            # 2. Versión Dark
            entry_dark = {
                "filename": f"{pixels}-dark.png",
                "idiom": idiom,
                "scale": scale,
                "size": size,
                "appearances": [appearances[1]],  # dark
            }
            entry_dark.update(extra_attrs)
            images.append(entry_dark)

            # 3. Versión Tinted (solo iOS)
            if platform == "ios":
                entry_tinted = {
                    "filename": f"{pixels}-tinted.png",
                    "idiom": idiom,
                    "scale": scale,
                    "size": size,
                    "appearances": [appearances[2]],  # tinted
                }
                entry_tinted.update(extra_attrs)
                images.append(entry_tinted)

            # 4. Versión Any (sin appearances)
            entry_any = {
                "filename": f"{pixels}.png",
                "idiom": idiom,
                "scale": scale,
                "size": size,
            }
            entry_any.update(extra_attrs)
            images.append(entry_any)

    contents = {"images": images, "info": {"author": "xcode", "version": 1}}

    # Guardar Contents.json
    contents_path = APPICON_DIR / "Contents.json"
    backup_path = (
        APPICON_DIR / f"Contents.json.backup.{int(os.path.getmtime(contents_path))}"
    )

    # Crear backup
    if contents_path.exists():
        subprocess.run(["cp", str(contents_path), str(backup_path)])
        print(f"💾 Backup creado: {backup_path.name}")

    with open(contents_path, "w") as f:
        json.dump(contents, f, indent=2)

    print(f"✅ Contents.json actualizado con {len(images)} entradas")
    return True


def verify_all_files():
    """Verifica que todos los archivos referenciados existan"""
    print("\n🔍 Verificando archivos...")

    contents_path = APPICON_DIR / "Contents.json"
    with open(contents_path, "r") as f:
        contents = json.load(f)

    missing = []
    existing = []

    for image in contents["images"]:
        filename = image.get("filename")
        if filename:
            filepath = APPICON_DIR / filename
            if filepath.exists():
                existing.append(filename)
            else:
                missing.append(filename)

    print(f"✅ Archivos existentes: {len(existing)}")

    if missing:
        print(f"❌ Archivos faltantes: {len(missing)}")
        for f in missing[:10]:  # Mostrar solo los primeros 10
            print(f"   - {f}")
        if len(missing) > 10:
            print(f"   ... y {len(missing) - 10} más")
        return False
    else:
        print("✅ Todos los archivos referenciados existen")
        return True


def main():
    print("=" * 70)
    print("🚀 GENERADOR DE ICONOS COMPLETO PARA ANSTOP")
    print("=" * 70)
    print()

    # Paso 1: Generar iconos
    if not generate_all_icons():
        print("\n❌ Error generando iconos")
        return 1

    # Paso 2: Crear Contents.json
    if not create_contents_json():
        print("\n❌ Error creando Contents.json")
        return 1

    # Paso 3: Verificar
    if not verify_all_files():
        print("\n⚠️  Algunos archivos faltan, generando...")
        generate_all_icons()
        verify_all_files()

    print("\n" + "=" * 70)
    print("✅ PROCESO COMPLETADO EXITOSAMENTE")
    print("=" * 70)
    print()
    print("📊 Resumen:")
    print(
        f"   - Iconos iOS: {len(ICON_SIZES['ios'])} tamaños × 4 appearances = {len(ICON_SIZES['ios']) * 4} archivos"
    )
    print(
        f"   - Iconos watchOS: {len(ICON_SIZES['watchos'])} tamaños × 3 appearances = {len(ICON_SIZES['watchos']) * 3} archivos"
    )
    print(
        f"   - Iconos macOS: {len(ICON_SIZES['macos'])} tamaños × 3 appearances = {len(ICON_SIZES['macos']) * 3} archivos"
    )
    print()
    print("🎯 Próximos pasos:")
    print("   1. Abre Xcode")
    print("   2. Ve a Assets.xcassets → AppIcon")
    print("   3. Verifica que todos los iconos aparecen correctamente")
    print("   4. Compila el proyecto")
    print()

    return 0


if __name__ == "__main__":
    exit(main())
