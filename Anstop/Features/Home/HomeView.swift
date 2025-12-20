import SwiftUI

struct HomeView: View {
    @State private var showPanicFlow = false
    @State private var isPanicButtonPressed = false
    @State private var showPaywall = false
    @State private var purchaseManager = PurchaseManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Botón principal de pánico - Rojo intenso con efecto vidrio
                    Button(action: {
                        withOptionalAnimation(.gentle) {
                            showPanicFlow = true
                        }
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.95),
                                            .white.opacity(0.85),
                                            Color(red: 1.0, green: 0.9, blue: 0.9).opacity(0.7)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text("Estoy teniendo ansiedad")
                                .font(.prometheusTitle3)
                                .bold()
                                .foregroundStyle(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 249, height: 249)
                        .background {
                            ZStack {
                                // Capa base roja profunda con gradiente radial
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color(red: 0.75, green: 0.05, blue: 0.05),
                                                Color(red: 0.6, green: 0.02, blue: 0.02),
                                                Color(red: 0.45, green: 0.0, blue: 0.0)
                                            ],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 125
                                        )
                                    )
                                
                                // Sombra interna superior izquierda (relieve hundido)
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.black.opacity(0.4),
                                                Color.black.opacity(0.15),
                                                Color.clear
                                            ],
                                            center: .init(x: 0.25, y: 0.25),
                                            startRadius: 0,
                                            endRadius: 80
                                        )
                                    )
                                    .blendMode(.multiply)
                                
                                // Brillo rojo intenso superior - Vidrio moldeado
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color(red: 1.0, green: 0.4, blue: 0.4).opacity(0.9),
                                                Color(red: 0.95, green: 0.3, blue: 0.3).opacity(0.5),
                                                Color(red: 0.85, green: 0.15, blue: 0.15).opacity(0.2),
                                                Color.clear
                                            ],
                                            center: .init(x: 0.35, y: 0.25),
                                            startRadius: 5,
                                            endRadius: 100
                                        )
                                    )
                                    .blendMode(.screen)
                                
                                // Reflejo blanco superior - Highlight de vidrio
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.white.opacity(0.7),
                                                Color.white.opacity(0.3),
                                                Color.clear
                                            ],
                                            center: .init(x: 0.3, y: 0.2),
                                            startRadius: 3,
                                            endRadius: 40
                                        )
                                    )
                                    .blendMode(.overlay)
                                
                                // Borde con relieve gradiente
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.9, green: 0.2, blue: 0.2).opacity(0.8),
                                                Color(red: 0.4, green: 0.0, blue: 0.0).opacity(0.9),
                                                Color(red: 0.25, green: 0.0, blue: 0.0)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                                
                                // Sombra interna inferior derecha (profundidad)
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                Color.clear,
                                                Color.black.opacity(0.25),
                                                Color.black.opacity(0.5)
                                            ],
                                            center: .init(x: 0.7, y: 0.75),
                                            startRadius: 50,
                                            endRadius: 125
                                        )
                                    )
                                    .blendMode(.multiply)
                            }
                        }
                        .scaleEffect(isPanicButtonPressed ? 0.95 : 1.0)
                        .shadow(color: Color(red: 0.8, green: 0.0, blue: 0.0).opacity(0.5), radius: isPanicButtonPressed ? 10 : 25, x: 0, y: isPanicButtonPressed ? 5 : 12)
                        .shadow(color: .black.opacity(0.4), radius: isPanicButtonPressed ? 5 : 15, x: 0, y: isPanicButtonPressed ? 2 : 8)
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
                                        .font(.prometheusHeadline)
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
                            RoundedRectangle(cornerRadius: 26)
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
                                title: "Biblioteca de Recursos", icon: "books.vertical.fill"
                            )
                        }

                        NavigationLink(destination: AIHelperView()) {
                            QuickAccessButton(title: "Asistente IA", icon: "sparkles", isPremium: !purchaseManager.isPremium)
                        }

                        NavigationLink(destination: JournalHistoryView()) {
                            QuickAccessButton(title: "Historial de Diario", icon: "clock.arrow.circlepath")
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    // Banner Premium en la parte inferior (solo para usuarios no premium)
                    if !purchaseManager.isPremium {
                        PremiumBanner {
                            showPaywall = true
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                    }
                }
            }
            }
            .anstopBackground(.home)
            .prepareHapticsOnAppear()
            .navigationTitle("Anstop")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color("Blue"))
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
            .clipShape(RoundedRectangle(cornerRadius: 29))
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
                RoundedRectangle(cornerRadius: 29)
                    .fill(.background.opacity(0.5))
            )
        }
    }
}

#Preview {
    HomeView()
        .environment(PurchaseManager())
}
