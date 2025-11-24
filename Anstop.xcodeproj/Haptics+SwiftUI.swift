// Haptics+SwiftUI.swift
#if canImport(UIKit)
import SwiftUI
import UIKit

public enum HapticEvent {
    case impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium, intensity: CGFloat? = nil)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection
}

public extension HapticManager {
    /// Triggers a haptic using a unified event type.
    func trigger(_ event: HapticEvent) {
        switch event {
        case let .impact(style, intensity):
            triggerImpact(style: style, intensity: intensity)
        case let .notification(type):
            triggerNotification(type)
        case .selection:
            triggerSelection()
        }
    }
}

public extension View {
    /// Triggers a haptic when the view is tapped.
    func hapticOnTap(_ event: HapticEvent = .impact()) -> some View {
        self.onTapGesture {
            HapticManager.shared.trigger(event)
        }
    }

    /// Triggers a haptic when the view appears.
    func hapticOnAppear(_ event: HapticEvent) -> some View {
        self.onAppear {
            HapticManager.shared.trigger(event)
        }
    }

    /// Triggers a haptic when the given value changes.
    func hapticOnChange<T: Equatable>(of value: T, event: HapticEvent) -> some View {
        self.onChange(of: value) { _ in
            HapticManager.shared.trigger(event)
        }
    }

    /// Prepares haptic generators on appear to reduce first-use latency.
    func prepareHapticsOnAppear() -> some View {
        self.onAppear {
            HapticManager.shared.warmUp()
        }
    }
}
#endif
