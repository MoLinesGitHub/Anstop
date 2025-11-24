// HapticManager.swift
import SwiftUI
import UIKit

@MainActor
final class HapticManager {
    static let shared = HapticManager()
    /// UserDefaults key for enabling/disabling haptics app-wide.
    static let userDefaultsKey = "HapticManager.isEnabled"

    private init() {}

    // Cache for impact generators by style
    private var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    private lazy var notificationGenerator = UINotificationFeedbackGenerator()
    private lazy var selectionGenerator = UISelectionFeedbackGenerator()
    
    private var canPlayHaptics: Bool {
        // Only depend on the app-level toggle
        return isEnabled
    }

    /// Global on/off switch for haptics. Defaults to true when not set.
    var isEnabled: Bool {
        get {
            if let value = UserDefaults.standard.object(forKey: Self.userDefaultsKey) as? Bool {
                return value
            }
            return true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Self.userDefaultsKey)
        }
    }

    /// Prepares commonly used generators to reduce latency on first use.
    func warmUp() {
        guard canPlayHaptics else { return }
        _ = impactGenerator(for: .medium)
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }

    /// Returns a cached UIImpactFeedbackGenerator for the given style, creating it if needed.
    private func impactGenerator(for style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator {
        if let generator = impactGenerators[style] {
            return generator
        }
        let generator = UIImpactFeedbackGenerator(style: style)
        impactGenerators[style] = generator
        return generator
    }

    /// Simple impact feedback
    /// - Parameters:
    ///   - style: The impact style to use (default .medium).
    ///   - intensity: Optional intensity (0.0...1.0). Uses `impactOccurred(intensity:)` on iOS 13+.
    func triggerImpact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium, intensity: CGFloat? = nil) {
        guard canPlayHaptics else { return }
        let generator = impactGenerator(for: style)
        generator.prepare()
        if let intensity = intensity {
            if #available(iOS 13.0, *) {
                let clamped = min(max(intensity, 0), 1)
                generator.impactOccurred(intensity: clamped)
            } else {
                generator.impactOccurred()
            }
        } else {
            generator.impactOccurred()
        }
    }

    /// Notification feedback (success, warning, error)
    func triggerNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard canPlayHaptics else { return }
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(type)
    }

    /// Selection feedback (e.g., for toggles)
    func triggerSelection() {
        guard canPlayHaptics else { return }
        selectionGenerator.prepare()
        selectionGenerator.selectionChanged()
    }
}
