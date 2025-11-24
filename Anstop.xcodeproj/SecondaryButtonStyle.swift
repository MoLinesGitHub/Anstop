// SecondaryButtonStyle.swift
import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    var color: Color = .blue
    var height: CGFloat = 55
    var cornerRadius: CGFloat = 16

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(color.opacity(configuration.isPressed ? 0.6 : 1.0), lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Color.clear)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.quick, value: configuration.isPressed)
    }
}

extension View {
    func secondaryButtonStyle(color: Color = .blue) -> some View {
        buttonStyle(SecondaryButtonStyle(color: color))
    }
}
