//
//  GroundingView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import GlassKitPro
import SwiftUI

struct GroundingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0

    var body: some View {
        TabView(selection: $currentStep) {
            // Paso 1: Vista (5 cosas)
            GroundingStepView(
                number: "5",
                icon: "eye.fill",
                title: String(localized: "grounding_step_5_title"),
                description: String(localized: "grounding_step_5_description"),
                color: .blue,
                action: { withOptionalAnimation(.gentle) { currentStep += 1 } }
            )
            .tag(0)

            // Paso 2: Tacto (4 cosas)
            GroundingStepView(
                number: "4",
                icon: "hand.raised.fill",
                title: String(localized: "grounding_step_4_title"),
                description: String(localized: "grounding_step_4_description"),
                color: .green,
                action: { withOptionalAnimation(.gentle) { currentStep += 1 } }
            )
            .tag(1)

            // Paso 3: Oído (3 cosas)
            GroundingStepView(
                number: "3",
                icon: "ear.fill",
                title: String(localized: "grounding_step_3_title"),
                description: String(localized: "grounding_step_3_description"),
                color: .orange,
                action: { withOptionalAnimation(.gentle) { currentStep += 1 } }
            )
            .tag(2)

            // Paso 4: Olfato (2 cosas)
            GroundingStepView(
                number: "2",
                icon: "nose.fill",
                title: String(localized: "grounding_step_2_title"),
                description: String(localized: "grounding_step_2_description"),
                color: .purple,
                action: { withOptionalAnimation(.gentle) { currentStep += 1 } }
            )
            .tag(3)

            // Paso 5: Gusto (1 cosa)
            GroundingStepView(
                number: "1",
                icon: "mouth.fill",
                title: String(localized: "grounding_step_1_title"),
                description: String(localized: "grounding_step_1_description"),
                color: .red,
                isLast: true,
                action: { dismiss() }
            )
            .tag(4)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle("grounding_title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GroundingStepView: View {
    let number: String
    let icon: String
    let title: String
    let description: String
    let color: Color
    var isLast: Bool = false
    let action: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 200, height: 200)

                VStack {
                    Image(systemName: icon)
                        .font(.futura(60))
                        .foregroundStyle(color)

                    Text(number)
                        .font(.futura(80))
                        .foregroundStyle(color)
                }
            }
            .symbolEffect(.bounce, value: true)

            VStack(spacing: 16) {
                Text(title)
                    .font(.prometheusLargeTitle)

                Text(description)
                    .font(.futuraTitle3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }

            Spacer()

            Button(action: action) {
                Text(isLast ? "grounding_finish" : "grounding_next")
                    .padding(.horizontal, 40)
            }
            .buttonStyle(PrimaryButtonStyle(color: color))
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    NavigationStack {
        GroundingView()
    }
}
