// AnimationExtensions.swift
import SwiftUI

extension Animation {
    /// A smooth, slightly longer animation for subtle UI changes
    static var smooth: Animation {
        .easeInOut(duration: 0.4)
    }

    /// A gentle, medium‑speed animation for view entrances
    static var gentle: Animation {
        .easeInOut(duration: 0.25)
    }

    /// A quick, snappy animation for button taps
    static var quick: Animation {
        .easeIn(duration: 0.15)
    }
}
