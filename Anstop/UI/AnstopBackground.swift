//
//  AnstopBackground.swift
//  Anstop
//
//  Created on 2025-12-04.
//  Fondo unificado para todas las vistas de Anstop
//  Usa GlassKitPro: LiquidFlowBackground + CrystalParticles
//

import SwiftUI

// MARK: - Anstop Background

/// Fondo unificado para todas las vistas de Anstop.
/// Combina gradientes adaptativos, ondas líquidas y partículas cristalinas.
struct AnstopBackground: View {
    
    // MARK: - Configuration
    
    /// Color de acento para las partículas (opcional)
    var accentColor: Color
    
    /// Número de partículas (0 = sin partículas)
    var particleCount: Int
    
    /// Opacidad de las partículas
    var particleOpacity: Double
    
    /// Velocidad de las partículas
    var particleSpeed: Double
    
    /// Mostrar ondas líquidas
    var showWaves: Bool
    
    /// Intensidad del fondo (0.0 - 1.0)
    var intensity: Double
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Initializer
    
    init(
        accentColor: Color = .cyan,
        count: Int = 20,
        particleOpacity: Double = 0.15,
        particleSpeed: Double = 0.4,
        showWaves: Bool = true,
        intensity: Double = 1.0
    ) {
        self.accentColor = accentColor
        self.particleCount = count
        self.particleOpacity = particleOpacity
        self.particleSpeed = particleSpeed
        self.showWaves = showWaves
        self.intensity = intensity
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // 1. Gradiente base adaptativo
            adaptiveGradient
            
            // 2. Ondas líquidas sutiles (opcional)
            if showWaves {
                liquidWaves
            }
            
            // 3. Textura de ruido sutil
            noiseTexture
            
            // 4. Partículas cristalinas (opcional)
            if particleCount > 0 {
                SimpleParticlesView(
                    count: particleCount,
                    color: accentColor,
                    opacity: particleOpacity * intensity,
                    speed: particleSpeed
                )
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Subviews
    
    /// Gradiente que se adapta a light/dark mode
    private var adaptiveGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark ? darkGradientColors : lightGradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Colores para modo claro
    private var lightGradientColors: [Color] {
        [
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.92, green: 0.95, blue: 0.98),
            Color(red: 0.90, green: 0.94, blue: 0.97)
        ]
    }
    
    /// Colores para modo oscuro
    private var darkGradientColors: [Color] {
        [
            Color(red: 0.08, green: 0.10, blue: 0.14),
            Color(red: 0.10, green: 0.12, blue: 0.18),
            Color(red: 0.12, green: 0.14, blue: 0.20)
        ]
    }
    
    /// Ondas líquidas animadas
    private var liquidWaves: some View {
        LiquidWavesView(
            colorScheme: colorScheme,
            intensity: intensity
        )
    }
    
    /// Textura de ruido sutil para efecto glass
    private var noiseTexture: some View {
        Rectangle()
            .fill(
                colorScheme == .dark
                    ? Color.white.opacity(0.02 * intensity)
                    : Color.black.opacity(0.015 * intensity)
            )
            .background(
                Canvas { context, size in
                    // Patrón de ruido sutil
                    for _ in 0..<Int(size.width * size.height * 0.0003) {
                        let x = CGFloat.random(in: 0..<size.width)
                        let y = CGFloat.random(in: 0..<size.height)
                        let opacity = Double.random(in: 0.01...0.03) * intensity
                        
                        context.fill(
                            Path(ellipseIn: CGRect(x: x, y: y, width: 1, height: 1)),
                            with: .color(colorScheme == .dark ? .white.opacity(opacity) : .black.opacity(opacity))
                        )
                    }
                }
            )
    }
}

// MARK: - Simple Particles View

/// Partículas flotantes simples inspiradas en GlassKitPro CrystalParticles
private struct SimpleParticlesView: View {
    let count: Int
    let color: Color
    let opacity: Double
    let speed: Double
    
    @State private var particles: [Particle] = []
    @State private var animationTrigger: Bool = false
    
    private struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var speedX: CGFloat
        var speedY: CGFloat
    }
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 1/30)) { timeline in
                Canvas { context, size in
                    let date = timeline.date.timeIntervalSinceReferenceDate
                    
                    for particle in particles {
                        // Calcular posición basada en tiempo
                        let timeOffset = date.truncatingRemainder(dividingBy: 1000)
                        let x = (particle.x + particle.speedX * timeOffset * 30).truncatingRemainder(dividingBy: size.width)
                        let y = (particle.y + particle.speedY * timeOffset * 30).truncatingRemainder(dividingBy: size.height)
                        
                        let adjustedX = x < 0 ? x + size.width : x
                        let adjustedY = y < 0 ? y + size.height : y
                        
                        let rect = CGRect(
                            x: adjustedX,
                            y: adjustedY,
                            width: particle.size,
                            height: particle.size
                        )
                        context.fill(
                            Path(ellipseIn: rect),
                            with: .color(color.opacity(particle.opacity * opacity))
                        )
                    }
                }
            }
            .onAppear {
                initializeParticles(in: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                initializeParticles(in: newSize)
            }
        }
    }
    
    private func initializeParticles(in size: CGSize) {
        particles = (0..<count).map { _ in
            Particle(
                x: CGFloat.random(in: 0..<size.width),
                y: CGFloat.random(in: 0..<size.height),
                size: CGFloat.random(in: 2...6),
                opacity: Double.random(in: 0.3...1.0),
                speedX: CGFloat.random(in: -0.5...0.5) * speed,
                speedY: CGFloat.random(in: -0.3...0.1) * speed
            )
        }
    }
}

// MARK: - Liquid Waves View

/// Ondas líquidas animadas inspiradas en GlassKitPro
private struct LiquidWavesView: View {
    let colorScheme: ColorScheme
    let intensity: Double
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            Canvas { context, size in
                let phase = timeline.date.timeIntervalSinceReferenceDate * 0.5 * intensity
                drawWaves(context: context, size: size, phase: phase)
            }
        }
    }
    
    private func drawWaves(context: GraphicsContext, size: CGSize, phase: Double) {
        let waveColor = colorScheme == .dark
            ? Color.white.opacity(0.04 * intensity)
            : Color.black.opacity(0.02 * intensity)
        
        // Primera onda
        var path1 = Path()
        path1.move(to: CGPoint(x: 0, y: size.height * 0.6))
        
        for x in stride(from: 0, through: size.width, by: 2) {
            let relativeX = x / size.width
            let sine = sin(relativeX * 6 + phase)
            let y = size.height * 0.6 + sine * 20 * intensity
            path1.addLine(to: CGPoint(x: x, y: y))
        }
        
        path1.addLine(to: CGPoint(x: size.width, y: size.height))
        path1.addLine(to: CGPoint(x: 0, y: size.height))
        path1.closeSubpath()
        
        context.fill(path1, with: .color(waveColor))
        
        // Segunda onda (más lenta)
        var path2 = Path()
        path2.move(to: CGPoint(x: 0, y: size.height * 0.7))
        
        for x in stride(from: 0, through: size.width, by: 2) {
            let relativeX = x / size.width
            let sine = sin(relativeX * 4 + phase * 0.7)
            let y = size.height * 0.7 + sine * 30 * intensity
            path2.addLine(to: CGPoint(x: x, y: y))
        }
        
        path2.addLine(to: CGPoint(x: size.width, y: size.height))
        path2.addLine(to: CGPoint(x: 0, y: size.height))
        path2.closeSubpath()
        
        context.fill(path2, with: .color(waveColor.opacity(0.7)))
    }
}

// MARK: - Preset Backgrounds

extension AnstopBackground {
    
    /// Fondo para la pantalla principal (Home)
    static var home: AnstopBackground {
        AnstopBackground(
            accentColor: .cyan,
            count: 25,
            particleOpacity: 0.15,
            particleSpeed: 0.4,
            showWaves: true
        )
    }
    
    /// Fondo para ejercicios de respiración
    static var breathing: AnstopBackground {
        AnstopBackground(
            accentColor: .cyan,
            count: 15,
            particleOpacity: 0.12,
            particleSpeed: 0.3,
            showWaves: true,
            intensity: 0.8
        )
    }
    
    /// Fondo para grounding
    static var grounding: AnstopBackground {
        AnstopBackground(
            accentColor: .green,
            count: 20,
            particleOpacity: 0.12,
            particleSpeed: 0.35,
            showWaves: true
        )
    }
    
    /// Fondo para el diario
    static var journal: AnstopBackground {
        AnstopBackground(
            accentColor: .indigo,
            count: 15,
            particleOpacity: 0.10,
            particleSpeed: 0.3,
            showWaves: false,
            intensity: 0.7
        )
    }
    
    /// Fondo para audio/meditación
    static var audio: AnstopBackground {
        AnstopBackground(
            accentColor: .purple,
            count: 12,
            particleOpacity: 0.10,
            particleSpeed: 0.25,
            showWaves: true,
            intensity: 0.6
        )
    }
    
    /// Fondo para AI Helper
    static var aiHelper: AnstopBackground {
        AnstopBackground(
            accentColor: Color(red: 0.6, green: 0.4, blue: 0.8),
            count: 15,
            particleOpacity: 0.08,
            particleSpeed: 0.3,
            showWaves: false,
            intensity: 0.8
        )
    }
    
    /// Fondo para biblioteca
    static var library: AnstopBackground {
        AnstopBackground(
            accentColor: .teal,
            count: 18,
            particleOpacity: 0.10,
            particleSpeed: 0.35,
            showWaves: true
        )
    }
    
    /// Fondo para configuración
    static var settings: AnstopBackground {
        AnstopBackground(
            accentColor: .gray,
            count: 10,
            particleOpacity: 0.05,
            particleSpeed: 0.2,
            showWaves: false,
            intensity: 0.5
        )
    }
    
    /// Fondo para pánico (calma urgente)
    static var panic: AnstopBackground {
        AnstopBackground(
            accentColor: Color(red: 0.3, green: 0.6, blue: 0.9),
            count: 20,
            particleOpacity: 0.15,
            particleSpeed: 0.35,
            showWaves: true
        )
    }
    
    /// Fondo para programa de 30 días
    static var program: AnstopBackground {
        AnstopBackground(
            accentColor: .mint,
            count: 18,
            particleOpacity: 0.12,
            particleSpeed: 0.35,
            showWaves: true
        )
    }
    
    /// Fondo para paywall/premium
    static var premium: AnstopBackground {
        AnstopBackground(
            accentColor: Color(red: 0.85, green: 0.65, blue: 0.2),
            count: 25,
            particleOpacity: 0.15,
            particleSpeed: 0.4,
            showWaves: true
        )
    }
    
    /// Fondo mínimo (sin partículas ni ondas)
    static var minimal: AnstopBackground {
        AnstopBackground(
            count: 0,
            showWaves: false,
            intensity: 0.3
        )
    }
}

// MARK: - View Extension

extension View {
    /// Aplica el fondo Anstop a la vista
    func anstopBackground(_ background: AnstopBackground = .home) -> some View {
        ZStack {
            background
            self
        }
    }
    
    /// Aplica el fondo Anstop con configuración personalizada
    func anstopBackground(
        accentColor: Color = .cyan,
        count: Int = 20,
        particleOpacity: Double = 0.15,
        particleSpeed: Double = 0.4,
        showWaves: Bool = true,
        intensity: Double = 1.0
    ) -> some View {
        ZStack {
            AnstopBackground(
                accentColor: accentColor,
                count: count,
                particleOpacity: particleOpacity,
                particleSpeed: particleSpeed,
                showWaves: showWaves,
                intensity: intensity
            )
            self
        }
    }
    
    /// Aplica el fondo Anstop a un ScrollView o List haciendo el background transparente
    func anstopScrollBackground(_ background: AnstopBackground = .home) -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(background)
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    VStack {
        Text("Anstop Background")
            .font(.largeTitle)
            .fontWeight(.bold)
        Text("Light Mode")
            .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .anstopBackground(.home)
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    VStack {
        Text("Anstop Background")
            .font(.largeTitle)
            .fontWeight(.bold)
        Text("Dark Mode")
            .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .anstopBackground(.home)
    .preferredColorScheme(.dark)
}

#Preview("Breathing") {
    VStack {
        Text("Breathing")
            .font(.largeTitle)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .anstopBackground(.breathing)
}

#Preview("Settings") {
    VStack {
        Text("Settings")
            .font(.largeTitle)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .anstopBackground(.settings)
}
