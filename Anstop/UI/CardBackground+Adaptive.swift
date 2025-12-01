// CardBackground+Adaptive.swift
import SwiftUI

extension View {
    /// Applies a card-like background that respects Reduce Transparency.
    func cardBackgroundAdaptive() -> some View {
        self.background(
            ZStack {
                if AccessibilitySettings.reduceTransparencyEnabled {
                    Color(uiColor: .secondarySystemGroupedBackground)
                } else {
                    Rectangle().fill(.ultraThinMaterial)
                }
            }
        )
    }

    /// Rounded card background that respects Reduce Transparency.
    func roundedCardBackgroundAdaptive(cornerRadius: CGFloat = 12) -> some View {
        self.background(
            ZStack {
                if AccessibilitySettings.reduceTransparencyEnabled {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color(uiColor: .secondarySystemGroupedBackground))
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
            }
        )
    }
}
