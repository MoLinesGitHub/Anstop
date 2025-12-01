// Accessibility+Helpers.swift
import SwiftUI
import UIKit

enum AccessibilitySettings {
    static var reduceMotionEnabled: Bool { UIAccessibility.isReduceMotionEnabled }
    static var reduceTransparencyEnabled: Bool { UIAccessibility.isReduceTransparencyEnabled }
}

/// Global helper to conditionally animate based on Reduce Motion accessibility setting.
func withOptionalAnimation(_ animation: Animation? = .default, _ body: @escaping () -> Void) {
    if AccessibilitySettings.reduceMotionEnabled {
        body()
    } else {
        withAnimation(animation) { body() }
    }
}
