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

                // Programa de 30 Días - Destacado con efecto líquido
                NavigationLink(destination: ThirtyDayProgramView()) {
                    CrystalLiquidCard {
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
                    }
                }
                .padding(.horizontal, 40)

                // Herramientas de bienestar con diseño glass calmante
                VStack(spacing: 16) {
                    Text("Herramientas de bienestar")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    NavigationLink(destination: BreathingView()) {
                        AdvancedGlassCard {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.cyan.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "wind")
                                        .font(.title3)
                                        .foregroundStyle(.cyan)
                                }
                                Text("Respiración")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }

                    NavigationLink(destination: GroundingView()) {
                        AdvancedGlassCard {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.green.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "hand.raised.fill")
                                        .font(.title3)
                                        .foregroundStyle(.green)
                                }
                                Text("Grounding 5-4-3-2-1")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }

                    NavigationLink(destination: AudioGuidesView()) {
                        AdvancedGlassCard {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.purple.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.title3)
                                        .foregroundStyle(.purple)
                                }
                                Text("Audio calmante")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if !purchaseManager.isPremium {
                                    Text("PRO")
                                        .font(.caption2.bold())
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.purple.gradient)
                                        .clipShape(Capsule())
                                }
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }

                    NavigationLink(destination: DailyJournalView()) {
                        AdvancedGlassCard {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.indigo.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "book.fill")
                                        .font(.title3)
                                        .foregroundStyle(.indigo)
                                }
                                Text("Diario del día")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }

                    NavigationLink(destination: LibraryView()) {
                        AdvancedGlassCard {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.teal.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "books.vertical.fill")
                                        .font(.title3)
                                        .foregroundStyle(.teal)
                                }
                                Text("Biblioteca de Recursos")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }

                    NavigationLink(destination: AIHelperView()) {
                        AdvancedGlassCard {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.pink.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "sparkles")
                                        .font(.title3)
                                        .foregroundStyle(.pink)
                                }
                                Text("Asistente IA")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if !purchaseManager.isPremium {
                                    Text("PRO")
                                        .font(.caption2.bold())
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.pink.gradient)
                                        .clipShape(Capsule())
                                }
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }

                    NavigationLink(destination: JournalHistoryView()) {
                        AdvancedGlassCard {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.title3)
                                        .foregroundStyle(.orange)
                                }
                                Text("Historial de Diario")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                    }
                }
                .prepareHapticsOnAppear()
            }
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
