import SwiftUI

struct CircularMenuPanel: View {
    let items: [MenuItem]
    let onSelect: (MenuItem) -> Void
    
    @State private var selectedIndex: Int? = nil
    @State private var pressedIndex: Int? = nil
    @State private var rotation: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo circular glass con efecto naranja
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.orange.opacity(0.25),
                                Color.orange.opacity(0.12),
                                Color.orange.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: geometry.size.width / 2
                        )
                    )
                    .overlay {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                    }
                    .overlay {
                        // Highlight superior
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                            .blendMode(.overlay)
                    }
                    .overlay {
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.5),
                                        Color.orange.opacity(0.4),
                                        Color.white.opacity(0.3),
                                        Color.orange.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    }
                    .shadow(color: Color.orange.opacity(0.3), radius: 30, x: 0, y: 15)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                
                // Centro decorativo
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.orange.opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay {
                        Circle()
                            .strokeBorder(Color.orange.opacity(0.3), lineWidth: 1)
                    }
                
                // Divisores tipo quesito con efecto sutil
                ForEach(items.indices, id: \.self) { index in
                    dividerLine(
                        at: index,
                        total: items.count,
                        in: geometry.size
                    )
                }
                
                // Slices interactivos
                ForEach(items.indices, id: \.self) { index in
                    sliceButton(
                        item: items[index],
                        index: index,
                        total: items.count,
                        size: geometry.size
                    )
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    // MARK: - Divisor de línea
    
    private func dividerLine(at index: Int, total: Int, in size: CGSize) -> some View {
        let angle = angleForSlice(index: index, total: total)
        
        return Path { path in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let innerRadius: CGFloat = 50 // Radio del círculo central
            let outerRadius = min(size.width, size.height) / 2
            
            let startPoint = CGPoint(
                x: center.x + cos(angle) * innerRadius,
                y: center.y + sin(angle) * innerRadius
            )
            
            let endPoint = CGPoint(
                x: center.x + cos(angle) * outerRadius,
                y: center.y + sin(angle) * outerRadius
            )
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        .stroke(
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.orange.opacity(0.3),
                    Color.orange.opacity(0.2),
                    Color.clear
                ],
                startPoint: .center,
                endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: 1.2, lineCap: .round)
        )
    }
    
    // MARK: - Slice Button
    
    private func sliceButton(item: MenuItem, index: Int, total: Int, size: CGSize) -> some View {
        let startAngle = angleForSlice(index: index, total: total)
        let endAngle = angleForSlice(index: index + 1, total: total)
        let midAngle = (startAngle + endAngle) / 2
        
        let radius = min(size.width, size.height) / 2
        let iconDistance = radius * 0.68 // Posición del icono
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let iconPosition = CGPoint(
            x: center.x + cos(midAngle) * iconDistance,
            y: center.y + sin(midAngle) * iconDistance
        )
        
        let isPressed = pressedIndex == index
        let isSelected = selectedIndex == index
        
        return Button {
            HapticManager.shared.triggerImpact(style: .medium)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedIndex = index
            }
            onSelect(item)
        } label: {
            ZStack {
                // Fondo del botón con glow
                if isPressed || isSelected {
                    Circle()
                        .fill(Color.orange.opacity(isPressed ? 0.4 : 0.2))
                        .frame(width: 60, height: 60)
                        .blur(radius: 8)
                }
                
                // Icono
                Image(systemName: item.icon)
                    .font(.futura(isSelected ? 32 : 28))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color.orange.opacity(isSelected ? 0.9 : 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(isPressed ? 0.85 : 1.0)
                    .scaleEffect(isSelected ? 1.15 : 1.0)
                    .shadow(color: Color.orange.opacity(isSelected ? 0.6 : 0.3), radius: isSelected ? 10 : 5, x: 0, y: isSelected ? 5 : 2)
                
                // Badge PRO si es premium
                if item.isPremium {
                    VStack {
                        HStack {
                            Spacer()
                            Text("premium_badge")
                                .font(.futura(7))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 1.5)
                                .background(
                                    Capsule()
                                        .fill(Color.orange)
                                        .shadow(color: Color.orange.opacity(0.5), radius: 3, x: 0, y: 1)
                                )
                        }
                        Spacer()
                    }
                    .frame(width: 50, height: 50)
                }
            }
            .frame(width: 50, height: 50)
            .position(iconPosition)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.quick) {
                        pressedIndex = index
                    }
                }
                .onEnded { _ in
                    withAnimation(.quick) {
                        pressedIndex = nil
                    }
                }
        )
    }
    
    // MARK: - Helpers
    
    private func angleForSlice(index: Int, total: Int) -> CGFloat {
        let sliceAngle = (2 * .pi) / CGFloat(total)
        // Empezar desde -90 grados (arriba)
        return sliceAngle * CGFloat(index) - .pi / 2
    }
}

// MARK: - MenuItem Model

struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let isPremium: Bool
    
    init(icon: String, title: String, isPremium: Bool = false) {
        self.icon = icon
        self.title = title
        self.isPremium = isPremium
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            CircularMenuPanel(
                items: [
                    MenuItem(icon: "wind", title: String(localized: "home_quick_access_breathing")),
                    MenuItem(icon: "hand.raised.fill", title: String(localized: "home_quick_access_grounding")),
                    MenuItem(icon: "speaker.wave.2.fill", title: String(localized: "home_quick_access_audio"), isPremium: true),
                    MenuItem(icon: "book.fill", title: String(localized: "home_quick_access_journal")),
                    MenuItem(icon: "books.vertical.fill", title: String(localized: "home_quick_access_library")),
                    MenuItem(icon: "sparkles", title: String(localized: "home_quick_access_ai"), isPremium: true),
                    MenuItem(icon: "clock.arrow.circlepath", title: String(localized: "home_quick_access_history"))
                ]
            ) { item in
                print("Selected: \(item.title)")
            }
            .frame(width: 320, height: 320)
            .padding()
        }
    }
}
