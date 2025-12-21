import SwiftUI

struct HomeView: View {
    @State private var showPanicFlow = false
    @State private var isPanicButtonPressed = false
    @State private var showPaywall = false
    @State private var purchaseManager = PurchaseManager.shared

    @State private var textRotation: Double = 0
    @State private var selectedQuickAccess: QuickAccessItem?
    @State private var isQuickAccessExpanded = false
    @State private var lotusScale: CGFloat = 1.0
    
    enum QuickAccessItem: String, CaseIterable, Identifiable {
        case breathing = "Respiración"
        case grounding = "Grounding 5-4-3-2-1"
        case audio = "Audio calmante"
        case journal = "Diario del día"
        case library = "Biblioteca de Recursos"
        case ai = "Asistente IA"
        case history = "Historial de Diario"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .breathing: return "wind"
            case .grounding: return "hand.raised.fill"
            case .audio: return "speaker.wave.2.fill"
            case .journal: return "book.fill"
            case .library: return "books.vertical.fill"
            case .ai: return "sparkles"
            case .history: return "clock.arrow.circlepath"
            }
        }
        
        var isPremium: Bool {
            switch self {
            case .audio, .ai: return true
            default: return false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo
                Color.clear
                    .anstopBackground(.home)
                
                // Panel de accesos rápidos FIJO debajo del botón de pánico
                VStack {
                    Spacer()
                        .frame(height: 500)
                    
                    // Panel de cristal con todos los iconos
                    CrystalQuickAccessPanel(
                        selectedItem: $selectedQuickAccess,
                        isExpanded: $isQuickAccessExpanded,
                        isPremium: purchaseManager.isPremium
                    )
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Banner Premium (solo si no es premium)
                    if !purchaseManager.isPremium {
                        PremiumBanner {
                            showPaywall = true
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                    }
                }
                
                // Botón FIJO en el centro (siempre visible, capa superior)
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 80)
                    
                    // Botón Programa de 30 Días - Liquid Glass estilo Dock macOS
                    NavigationLink(destination: ThirtyDayProgramView()) {
                        ZStack {
                            Circle()
                                .frame(width: 140, height: 140)
                                .background(.ultraThinMaterial, in: Circle())
                                .overlay {
                                    // Tinte arena muy sutil (como el dock)
                                    Circle()
                                        .fill(Color(red: 0.85, green: 0.75, blue: 0.55).opacity(0.15))
                                }
                                .overlay {
                                    // Reflejo superior tipo dock
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.25),
                                                    Color.clear
                                                ],
                                                startPoint: .top,
                                                endPoint: .center
                                            )
                                        )
                                }
                                .overlay {
                                    // Borde delgado tipo dock
                                    Circle()
                                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 0.5)
                                }
                            
                            // Icono central
                            Image(systemName: "calendar")
                                .font(.futura(35))
                                .foregroundStyle(.white.opacity(0.95))
                            
                            // Texto giratorio alrededor
                            ZStack {
                                ForEach(Array("PROGRAMA DE 30 DÍAS • ".enumerated()), id: \.offset) { index, char in
                                    Text(String(char))
                                        .font(.futura(10))
                                        .foregroundStyle(.white.opacity(0.9))
                                        .offset(y: -60)
                                        .rotationEffect(.degrees(Double(index) * 18 + textRotation))
                                }
                            }
                            .frame(width: 140, height: 140)
                        }
                        .shadow(color: .black.opacity(0.3), radius: 25, x: 0, y: 15)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                            textRotation = 360
                        }
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Botón principal de pánico
                    Button(action: {
                        withOptionalAnimation(.gentle) {
                            showPanicFlow = true
                        }
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "heart.circle.fill")
                                .font(.futura(50))
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
                        .background(.ultraThinMaterial, in: Circle())
                        .overlay {
                            // Tinte rojo muy sutil (como el dock)
                            Circle()
                                .fill(
                                    Color(red: 0.85, green: 0.1, blue: 0.1)
                                        .opacity(0.18)
                                )
                        }
                        .overlay {
                            // Reflejo superior tipo dock
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.25),
                                            Color.clear
                                        ],
                                        startPoint: .top,
                                        endPoint: .center
                                    )
                                )
                        }
                        .overlay {
                            // Borde delgado tipo dock
                            Circle()
                                .strokeBorder(
                                    Color.white.opacity(0.3),
                                    lineWidth: 0.5
                                )
                        }
                        .scaleEffect(isPanicButtonPressed ? 0.95 : 1.0)
                        .shadow(color: .black.opacity(0.3), radius: isPanicButtonPressed ? 10 : 25, x: 0, y: isPanicButtonPressed ? 5 : 15)
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
                    
                    Spacer()
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
            .navigationDestination(for: QuickAccessItem.self) { item in
                switch item {
                case .breathing:
                    BreathingView()
                case .grounding:
                    GroundingView()
                case .audio:
                    AudioGuidesView()
                case .journal:
                    DailyJournalView()
                case .library:
                    LibraryView()
                case .ai:
                    AIHelperView()
                case .history:
                    JournalHistoryView()
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .onChange(of: selectedQuickAccess) { _, newValue in
                if let item = newValue {
                    // Pequeño delay para permitir la animación
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        // Trigger navigation
                    }
                }
            }
        }
    }


// MARK: - Crystal Quick Access Panel

struct CrystalQuickAccessPanel: View {
    @Binding var selectedItem: HomeView.QuickAccessItem?
    @Binding var isExpanded: Bool
    let isPremium: Bool
    
    @State private var pressedIcon: HomeView.QuickAccessItem?
    
    var body: some View {
        VStack(spacing: 15) {
            // Panel circular tipo quesito
            CircularMenuPanel(
                items: HomeView.QuickAccessItem.allCases.map { item in
                    MenuItem(
                        icon: item.icon,
                        title: item.rawValue,
                        isPremium: item.isPremium && !isPremium
                    )
                }
            ) { menuItem in
                // Encontrar el QuickAccessItem correspondiente
                if let item = HomeView.QuickAccessItem.allCases.first(where: { $0.rawValue == menuItem.title }) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedItem = item
                    }
                }
            }
            .frame(width: 320, height: 320)
            
            // Etiqueta expandible debajo
            if let selected = selectedItem {
                Text(selected.rawValue)
                    .font(.prometheusHeadline)
                    .foregroundStyle(.white.opacity(0.95))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.orange.opacity(0.3),
                                        Color.orange.opacity(0.15)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay {
                                Capsule()
                                    .stroke(Color.orange.opacity(0.4), lineWidth: 1.5)
                            }
                    )
                    .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.vertical)
    }
}

struct IconButton: View {
    let item: HomeView.QuickAccessItem
    let isPressed: Bool
    let showPremiumBadge: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Icono
            Image(systemName: item.icon)
                .font(.futura(26))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color.cyan.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 55, height: 55)
                .background {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.cyan.opacity(0.15),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 30
                            )
                        )
                }
                .scaleEffect(isPressed ? 0.85 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            
            // Badge PRO
            if showPremiumBadge {
                Text("PRO")
                    .font(.futura(8))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.orange)
                    )
                    .offset(x: 8, y: -8)
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
                    .font(.futuraTitle3)
                    .foregroundStyle(.yellow)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Desbloquea todas las funciones")
                        .font(.futuraSubheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("7 días de prueba GRATIS")
                        .font(.futuraCaption)
                        .foregroundStyle(.white.opacity(0.9))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.futuraCaption)
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
                    .font(.futuraTitle3)
                Text(title)
                    .font(.futuraBody)
                if isPremium {
                    Spacer()
                    Text("PRO")
                        .font(.futuraCaption2)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .clipShape(Capsule())
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.futuraCaption)
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
