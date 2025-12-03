//
//  HomeView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI

struct HomeView: View {
    @State private var showPanicFlow = false
    @State private var isPanicButtonPressed = false
    @State private var showPaywall = false
    @Environment(PurchaseManager.self) private var purchaseManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Banner Premium (solo para usuarios no premium)
                    if !purchaseManager.isPremium {
                        PremiumBanner {
                            showPaywall = true
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }

                    // Botón principal de pánico
                Button(action: {
                    withOptionalAnimation(.gentle) {
                        showPanicFlow = true
                    }
                }) {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 60))
                        Text("Estoy teniendo ansiedad")
                            .font(.title2)
                            .bold()
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue.gradient)
                            .shadow(
                                color: .blue.opacity(0.3), radius: isPanicButtonPressed ? 8 : 15,
                                x: 0, y: isPanicButtonPressed ? 2 : 8)
                    )
                    .scaleEffect(isPanicButtonPressed ? 0.95 : 1.0)
                    .padding(.horizontal, 40)
                }
                .buttonStyle(.plain)
                .hapticOnTap(.impact(style: .heavy))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withOptionalAnimation(.quick) {
                                isPanicButtonPressed = true
                            }
                        }
                        .onEnded { _ in
                            withOptionalAnimation(.quick) {
                                isPanicButtonPressed = false
                            }
                        }
                )

                // Programa de 30 Días - Destacado
                NavigationLink(destination: ThirtyDayProgramView()) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundStyle(.orange)
                                Text("Programa de 30 Días")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                if !purchaseManager.isPremium {
                                    Text("PRO")
                                        .font(.caption2)
                                        .bold()
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.orange)
                                        .clipShape(Capsule())
                                }
                            }
                            Text("Transforma tu relación con la ansiedad")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.orange.opacity(0.1))
                    )
                }
                .padding(.horizontal, 40)

                // Accesos rápidos con diseño glass calmante
                VStack(spacing: 12) {
                    Text("Herramientas de bienestar")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    NavigationLink(destination: BreathingView()) {
                        GlassQuickAccessButton(
                            title: "Respiración",
                            icon: "wind",
                            accentColor: .cyan
                        )
                    }

                    NavigationLink(destination: GroundingView()) {
                        GlassQuickAccessButton(
                            title: "Grounding 5-4-3-2-1",
                            icon: "hand.raised.fill",
                            accentColor: .green
                        )
                    }

                    NavigationLink(destination: AudioGuidesView()) {
                        GlassQuickAccessButton(
                            title: "Audio calmante",
                            icon: "speaker.wave.2.fill",
                            accentColor: .purple,
                            isPremium: !purchaseManager.isPremium
                        )
                    }

                    NavigationLink(destination: DailyJournalView()) {
                        GlassQuickAccessButton(
                            title: "Diario del día",
                            icon: "book.fill",
                            accentColor: .indigo
                        )
                    }

                    NavigationLink(destination: LibraryView()) {
                        GlassQuickAccessButton(
                            title: "Biblioteca de Recursos",
                            icon: "books.vertical.fill",
                            accentColor: .teal
                        )
                    }

                    NavigationLink(destination: AIHelperView()) {
                        GlassQuickAccessButton(
                            title: "Asistente IA",
                            icon: "sparkles",
                            accentColor: .pink,
                            isPremium: !purchaseManager.isPremium
                        )
                    }

                    NavigationLink(destination: JournalHistoryView()) {
                        GlassQuickAccessButton(
                            title: "Historial de Diario",
                            icon: "clock.arrow.circlepath",
                            accentColor: .orange
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                }
            }
            .prepareHapticsOnAppear()
            .navigationTitle("Anstop")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.blue)
                    }
                }
            }
            .navigationDestination(isPresented: $showPanicFlow) {
                PanicFlowView()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}

// MARK: - Premium Banner Component

struct PremiumBanner: View {
    let onTap: () -> Void
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.yellow.opacity(0.3), .orange.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Desbloquea todas las funciones")
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text("7 días de prueba GRATIS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(16)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .yellow.opacity(0.1),
                                    .orange.opacity(0.08),
                                    .purple.opacity(0.06)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.yellow.opacity(0.4), .orange.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            }
            .shadow(color: .yellow.opacity(0.2), radius: 15, y: 8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Glass Quick Access Button

struct GlassQuickAccessButton: View {
    let title: String
    let icon: String
    let accentColor: Color
    var isPremium: Bool = false
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(accentColor)
            }
            
            Text(title)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
            if isPremium {
                Text("PRO")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(accentColor.gradient)
                    .clipShape(Capsule())
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.08),
                                accentColor.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(accentColor.opacity(0.2), lineWidth: 0.5)
            }
        }
    }
}

// Legacy button - mantener para compatibilidad
struct QuickAccessButton: View {
    let title: String
    let icon: String
    var isPremium: Bool = false

    var body: some View {
        GlassQuickAccessButton(
            title: title,
            icon: icon,
            accentColor: .blue,
            isPremium: isPremium
        )
    }
}

#Preview {
    HomeView()
        .environment(PurchaseManager())
}
