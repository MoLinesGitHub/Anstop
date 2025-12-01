// PrimaryButtonStyle.swift
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = .blue
    var height: CGFloat = 55
    var cornerRadius: CGFloat = 16

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(color)
                    .opacity(configuration.isPressed ? 0.85 : 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.quick, value: configuration.isPressed)
    }
}

extension View {
    func primaryButtonStyle(color: Color = .blue) -> some View {
        buttonStyle(PrimaryButtonStyle(color: color))
    }
}

#Preview {
    VStack(spacing: 20) {
        Button("Continuar") {}
            .buttonStyle(PrimaryButtonStyle())
        Button("Acción secundaria") {}
            .buttonStyle(PrimaryButtonStyle(color: .orange))
    }
    .padding()
}
