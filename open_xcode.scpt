#!/usr/bin/osascript

-- Script para abrir Xcode y guiar al usuario en la creación del proyecto
tell application "Xcode"
	activate
	display dialog "Voy a ayudarte a crear el proyecto Anstop. 

Por favor, sigue estos pasos:

1. Ve a File → New → Project
2. Selecciona iOS → App
3. Configura:
   - Product Name: Anstop
   - Organization Identifier: com.anstop
   - Interface: SwiftUI  
   - Language: Swift
   - Storage: None
4. Guarda en: /Volumes/SSD/xCode_Projects/Anstop

Después, presiona OK para continuar con las instrucciones." buttons {"OK"} default button "OK"
	
	display dialog "Ahora realiza estos pasos en Xcode:

1. Elimina ContentView.swift (si existe)
2. Elimina cualquier archivo Assets.xcassets auto-generado
3. En el navegador de proyectos, haz clic derecho en el grupo 'Anstop'
4. Selecciona 'Add Files to Anstop...'
5. Navega a /Volumes/SSD/xCode_Projects/Anstop/Anstop
6. Selecciona TODA la carpeta Anstop
7. Asegúrate de marcar 'Create groups' y 'Add to target: Anstop'
8. Haz clic en 'Add'

El proyecto está listo para compilarse!" buttons {"Entendido"} default button "Entendido"
end tell
