//
//  AnstopBackground.swift
//  Anstop
//
//  Created on 2025-12-04.
//  Fondo unificado para todas las vistas de Anstop
//

import SwiftUI

// MARK: - Anstop Background

struct AnstopBackground: View {
    var accentColor: Color
    var particleCount: Int
    var particleOpacity: Double
    var particleSpeed: Double
    var showWaves: Bool
    var intensity: Double

    @Environment(\.colorScheme) private var colorScheme

    init(
        accentColor: Color = .yellow,
        count: Int = 20,
        particleOpacity: Double = 0.15,
        particleSpeed: Double = 0.5,
        showWaves: Bool = true,
        intensity: Double = 1.0
    ) {
        self.accentColor = accentColor
        particleCount = count
        self.particleOpacity = particleOpacity
        self.particleSpeed = particleSpeed
        self.showWaves = showWaves
        self.intensity = intensity
    }

    var body: some View {
        ZStack {
            adaptiveGradient

            if showWaves {
                liquidWaves
            }

            noiseTexture

            if particleCount > 0 {
                SimpleParticlesView(
                    count: particleCount,
                    color: accentColor,
                    opacity: particleOpacity * intensity * (colorScheme == .dark ? 1.0 : 2.0),
                    speed: particleSpeed,
                    colorScheme: colorScheme
                )
            }
        }
        .ignoresSafeArea()
    }

    private var adaptiveGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark ? darkGradientColors : lightGradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Colores para modo claro - usando AccentColor
    private var lightGradientColors: [Color] {
        [
            Color.accentColor.opacity(0.12),
            Color.accentColor.opacity(0.18),
            Color.accentColor.opacity(0.22),
        ]
    }

    private var darkGradientColors: [Color] {
        [
            Color(red: 0.08, green: 0.10, blue: 0.14),
            Color(red: 0.10, green: 0.12, blue: 0.18),
            Color(red: 0.12, green: 0.14, blue: 0.20),
        ]
    }

    private var liquidWaves: some View {
        LiquidWavesView(
            colorScheme: colorScheme,
            intensity: intensity
        )
    }

    private var noiseTexture: some View {
        Rectangle()
            .fill(.clear)
            .background(
                Canvas { context, size in
                    guard size.width > 1, size.height > 1 else { return }

                    let noiseCount = max(1, Int(size.width * size.height * 0.0003))
                    for _ in 0 ..< noiseCount {
                        let xPosition = CGFloat.random(in: 1 ... size.width)
                        let yPosition = CGFloat.random(in: 1 ... size.height)
                        let opacity = Double.random(in: 0.01 ... 0.03) * intensity
                        let baseOpacity = colorScheme == .dark ? 0.02 : 0.04

                        context.fill(
                            Path(ellipseIn: CGRect(x: xPosition, y: yPosition, width: 1, height: 1)),
                            with: .color(colorScheme == .dark ? .white.opacity(opacity) : .black.opacity(opacity * baseOpacity))
                        )
                    }
                }
            )
    }
}

// MARK: - Simple Particles View

private struct SimpleParticlesView: View {
    let count: Int
    let color: Color
    let opacity: Double
    let speed: Double
    let colorScheme: ColorScheme

    @State private var particles: [Particle] = []

    private struct Particle: Identifiable {
        let id = UUID()
        var xPos: CGFloat
        var yPos: CGFloat
        var size: CGFloat
        var opacity: Double
        var speedX: CGFloat
        var speedY: CGFloat
        var hasGlow: Bool
        var glowIntensity: Double
    }

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                Canvas { context, size in
                    guard size.width > 1, size.height > 1 else { return }

                    let date = timeline.date.timeIntervalSinceReferenceDate

                    for particle in particles {
                        let timeOffset = date.truncatingRemainder(dividingBy: 1000)
                        var xPosition = (particle.xPos + particle.speedX * timeOffset * 30)
                            .truncatingRemainder(dividingBy: size.width)
                        var yPosition = (particle.yPos + particle.speedY * timeOffset * 30)
                            .truncatingRemainder(dividingBy: size.height)

                        if xPosition < 0 { xPosition += size.width }
                        if yPosition < 0 { yPosition += size.height }

                        // Efecto de parpadeo suave (luciérnaga)
                        let twinkle = sin(date * 2.0 + Double(particle.id.hashValue % 100)) * 0.3 + 0.7
                        
                        // Color de luz mágica (blanco-dorado)
                        let lightColor = Color(
                            red: 1.0,
                            green: 0.98,
                            blue: 0.85
                        )
                        
                        let rect = CGRect(x: xPosition, y: yPosition, width: particle.size, height: particle.size)
                        
                        // Núcleo brillante de la luciérnaga
                        context.fill(
                            Path(ellipseIn: rect),
                            with: .color(lightColor.opacity(particle.opacity * opacity * twinkle))
                        )
                        
                        // Halo de luz (todas las partículas tienen brillo)
                        if particle.hasGlow {
                            let glowRect1 = rect.insetBy(dx: -particle.size * 0.4, dy: -particle.size * 0.4)
                            let glowRect2 = rect.insetBy(dx: -particle.size * 0.8, dy: -particle.size * 0.8)
                            
                            context.fill(
                                Path(ellipseIn: glowRect1),
                                with: .color(lightColor.opacity(particle.opacity * opacity * twinkle * 0.5 * particle.glowIntensity))
                            )
                            
                            context.fill(
                                Path(ellipseIn: glowRect2),
                                with: .color(lightColor.opacity(particle.opacity * opacity * twinkle * 0.2 * particle.glowIntensity))
                            )
                        }
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
        guard size.width > 1, size.height > 1, count != 0 else {
            particles = []
            return
        }

        particles = (0 ..< count).map { _ in
            Particle(
                xPos: CGFloat.random(in: 1 ... size.width),
                yPos: CGFloat.random(in: 1 ... size.height),
                size: CGFloat.random(in: 2 ... 5),
                opacity: Double.random(in: 0.5 ... 1.0),
                speedX: CGFloat.random(in: -0.5 ... 0.5) * speed,
                speedY: CGFloat.random(in: -0.3 ... 0.1) * speed,
                hasGlow: Double.random(in: 0 ... 1) < 0.7, // 70% con brillo intenso
                glowIntensity: Double.random(in: 0.6 ... 1.0)
            )
        }
    }
}

// MARK: - Liquid Waves View

private struct LiquidWavesView: View {
    let colorScheme: ColorScheme
    let intensity: Double

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
            Canvas { context, size in
                guard size.width > 1, size.height > 1 else { return }
                let phase = timeline.date.timeIntervalSinceReferenceDate * 0.5 * intensity
                drawWaves(context: context, size: size, phase: phase)
            }
        }
    }

    private func drawWaves(context: GraphicsContext, size: CGSize, phase: Double) {
        let waveOpacity = colorScheme == .dark ? 0.04 : 0.08
        let waveColor = colorScheme == .dark
            ? Color.white.opacity(waveOpacity * intensity)
            : Color.black.opacity(waveOpacity * intensity)

        var path1 = Path()
        path1.move(to: CGPoint(x: 0, y: size.height * 0.6))

        for xPos in stride(from: 0, through: size.width, by: 2) {
            let relativeX = xPos / size.width
            let sine = sin(relativeX * 6 + phase)
            let yPos = size.height * 0.6 + sine * 20 * intensity
            path1.addLine(to: CGPoint(x: xPos, y: yPos))
        }

        path1.addLine(to: CGPoint(x: size.width, y: size.height))
        path1.addLine(to: CGPoint(x: 0, y: size.height))
        path1.closeSubpath()

        context.fill(path1, with: .color(waveColor))

        var path2 = Path()
        path2.move(to: CGPoint(x: 0, y: size.height * 0.7))

        for xPos in stride(from: 0, through: size.width, by: 2) {
            let relativeX = xPos / size.width
            let sine = sin(relativeX * 4 + phase * 0.7)
            let yPos = size.height * 0.7 + sine * 30 * intensity
            path2.addLine(to: CGPoint(x: xPos, y: yPos))
        }

        path2.addLine(to: CGPoint(x: size.width, y: size.height))
        path2.addLine(to: CGPoint(x: 0, y: size.height))
        path2.closeSubpath()

        context.fill(path2, with: .color(waveColor.opacity(0.7)))
    }
}

// MARK: - Preset Backgrounds

extension AnstopBackground {
    static var home: AnstopBackground {
        AnstopBackground(accentColor: .red, count: 30, particleOpacity: 0.18, particleSpeed: 0.4, showWaves: true)
    }

    static var breathing: AnstopBackground {
        AnstopBackground(accentColor: .yellow, count: 20, particleOpacity: 0.15, particleSpeed: 0.3, showWaves: true, intensity: 0.8)
    }

    static var grounding: AnstopBackground {
        AnstopBackground(accentColor: .green, count: 25, particleOpacity: 0.15, particleSpeed: 0.35, showWaves: true)
    }

    static var journal: AnstopBackground {
        AnstopBackground(accentColor: .indigo, count: 20, particleOpacity: 0.12, particleSpeed: 0.3, showWaves: true, intensity: 0.7)
    }

    static var audio: AnstopBackground {
        AnstopBackground(accentColor: .purple, count: 18, particleOpacity: 0.12, particleSpeed: 0.25, showWaves: true, intensity: 0.6)
    }

    static var aiHelper: AnstopBackground {
        AnstopBackground(accentColor: Color(red: 0.6, green: 0.4, blue: 0.8), count: 20, particleOpacity: 0.10, particleSpeed: 0.3, showWaves: true, intensity: 0.8)
    }

    static var library: AnstopBackground {
        AnstopBackground(accentColor: .teal, count: 22, particleOpacity: 0.12, particleSpeed: 0.35, showWaves: true)
    }

    static var settings: AnstopBackground {
        AnstopBackground(accentColor: .gray, count: 15, particleOpacity: 0.08, particleSpeed: 0.2, showWaves: true, intensity: 0.5)
    }

    static var panic: AnstopBackground {
        AnstopBackground(accentColor: Color(red: 0.3, green: 0.6, blue: 0.9), count: 25, particleOpacity: 0.18, particleSpeed: 0.35, showWaves: true)
    }

    static var program: AnstopBackground {
        AnstopBackground(accentColor: .mint, count: 22, particleOpacity: 0.15, particleSpeed: 0.35, showWaves: true)
    }

    static var premium: AnstopBackground {
        AnstopBackground(accentColor: Color(red: 0.85, green: 0.65, blue: 0.2), count: 30, particleOpacity: 0.18, particleSpeed: 0.4, showWaves: true)
    }

    static var minimal: AnstopBackground {
        AnstopBackground(count: 0, showWaves: false, intensity: 0.3)
    }
}

// MARK: - View Extension

extension View {
    func anstopBackground(_ background: AnstopBackground = .home) -> some View {
        ZStack {
            background
            self
        }
    }

    func anstopBackground(
        accentColor: Color = .yellow,
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

    func anstopScrollBackground(_ background: AnstopBackground = .home) -> some View {
        scrollContentBackground(.hidden)
            .background(background)
    }
}
