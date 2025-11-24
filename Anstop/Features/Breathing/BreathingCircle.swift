//
//  BreathingCircle.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI

struct BreathingCircle: View {
    @State private var scale: CGFloat = 0.4
    @State private var opacity: Double = 0.3

    var body: some View {
        ZStack {
            Circle()
                .fill(.blue.opacity(opacity))
                .frame(width: 200, height: 200)
                .scaleEffect(scale)

            Circle()
                .stroke(.blue, lineWidth: 2)
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                scale = 1.0
                opacity = 0.7
            }
        }
    }
}

#Preview {
    BreathingCircle()
}
