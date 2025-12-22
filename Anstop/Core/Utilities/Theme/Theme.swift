// Theme.swift
import SwiftUI

enum Theme {
    // Primary colors
    static let primary = Color("Blue")
    static let secondary = Color.orange
    static let accent = Color.purple

    // Gradients
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white.opacity(0.9), Color("Blue").opacity(0.1)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Corner radius
    static let cornerRadius: CGFloat = 12

    // Shadows
    static let lightShadow = Color.black.opacity(0.1)
    static let mediumShadow = Color.black.opacity(0.2)
    static let heavyShadow = Color.black.opacity(0.3)
    
    // Custom Fonts
    static func prometheusFont(size: CGFloat) -> Font {
        .custom("PROMETHEUS", size: size)
    }
    
    static let titleFont = prometheusFont(size: 34)
    static let largeTitleFont = prometheusFont(size: 40)
    static let headlineFont = prometheusFont(size: 24)
}
