// BreathingCircle.swift
import SwiftUI

struct BreathingCircle: View {
    @State private var scale: CGFloat = 0.9

    var body: some View {
        Circle()
            .fill(.blue.opacity(0.2))
            .frame(width: 200, height: 200)
            .overlay(
                Circle()
                    .stroke(.blue, lineWidth: 4)
                    .scaleEffect(scale)
                    .opacity(0.8)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    scale = 1.1
                }
            }
            .accessibilityLabel("Círculo de respiración animado")
    }
}

#Preview {
    BreathingCircle()
}
