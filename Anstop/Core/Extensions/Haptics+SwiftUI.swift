// Haptics+SwiftUI.swift
#if canImport(UIKit)
    import SwiftUI
    import UIKit

    enum HapticEvent {
        case impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium, intensity: CGFloat? = nil)
        case notification(UINotificationFeedbackGenerator.FeedbackType)
        case selection
    }

    extension HapticManager {
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

    extension View {
        /// Triggers a haptic when the view is tapped.
        func hapticOnTap(_ event: HapticEvent = .impact()) -> some View {
            onTapGesture {
                HapticManager.shared.trigger(event)
            }
        }

        /// Triggers a haptic when the view appears.
        func hapticOnAppear(_ event: HapticEvent) -> some View {
            onAppear {
                HapticManager.shared.trigger(event)
            }
        }

        /// Triggers a haptic when the given value changes.
        func hapticOnChange(of value: some Equatable, event: HapticEvent) -> some View {
            onChange(of: value) { _, _ in
                HapticManager.shared.trigger(event)
            }
        }

        /// Prepares haptic generators on appear to reduce first-use latency.
        func prepareHapticsOnAppear() -> some View {
            onAppear {
                HapticManager.shared.warmUp()
            }
        }
    }
#endif
