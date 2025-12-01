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
            VStack(spacing: 30) {
                // Banner Premium (solo para usuarios no premium)
                if !purchaseManager.isPremium {
                    PremiumBanner {
                        showPaywall = true
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                Spacer()

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

                // Accesos rápidos
                VStack(spacing: 15) {
                    NavigationLink(destination: BreathingView()) {
                        QuickAccessButton(title: "Respiración", icon: "wind")
                    }

                    NavigationLink(destination: GroundingView()) {
                        QuickAccessButton(title: "Grounding 5-4-3-2-1", icon: "hand.raised.fill")
                    }

                    NavigationLink(destination: AudioGuidesView()) {
                        QuickAccessButton(title: "Audio calmante", icon: "speaker.wave.2.fill", isPremium: !purchaseManager.isPremium)
                    }

                    NavigationLink(destination: DailyJournalView()) {
                        QuickAccessButton(title: "Diario del día", icon: "book.fill")
                    }

                    NavigationLink(destination: LibraryView()) {
                        QuickAccessButton(
                            title: "Biblioteca de Recursos", icon: "books.vertical.fill")
                    }

                    NavigationLink(destination: AIHelperView()) {
                        QuickAccessButton(title: "Asistente IA", icon: "sparkles", isPremium: !purchaseManager.isPremium)
                    }

                    NavigationLink(destination: JournalHistoryView()) {
                        QuickAccessButton(title: "Historial de Diario", icon: "clock.arrow.circlepath")
                    }
                }
                .padding(.horizontal, 40)

                Spacer()
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
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: "crown.fill")
                    .font(.title3)
                    .foregroundStyle(.yellow)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Desbloquea todas las funciones")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    Text("7 días de prueba GRATIS")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

struct QuickAccessButton: View {
    let title: String
    let icon: String
    var isPremium: Bool = false

    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.body)
                if isPremium {
                    Spacer()
                    Text("PRO")
                        .font(.caption2)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .clipShape(Capsule())
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .foregroundStyle(.primary)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background.opacity(0.5))
            )
        }
    }
}

#Preview {
    HomeView()
        .environment(PurchaseManager())
}
