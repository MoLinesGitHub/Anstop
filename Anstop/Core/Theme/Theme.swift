// Theme.swift
import SwiftUI

struct Theme {
    // Primary colors
    static let primary = Color.blue
    static let secondary = Color.orange
    static let accent = Color.purple

    // Gradients
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white.opacity(0.9), Color.blue.opacity(0.1)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Corner radius
    static let cornerRadius: CGFloat = 12

    // Shadows
    static let lightShadow = Color.black.opacity(0.1)
    static let mediumShadow = Color.black.opacity(0.2)
    static let heavyShadow = Color.black.opacity(0.3)
}
