//
//  GroundingView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

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
                title: "Cosas que ves",
                description: "Mira a tu alrededor. Encuentra 5 objetos que no habías notado antes.",
                color: .blue,
                action: { withOptionalAnimation(.gentle) { currentStep += 1 } }
            )
            .tag(0)

            // Paso 2: Tacto (4 cosas)
            GroundingStepView(
                number: "4",
                icon: "hand.raised.fill",
                title: "Cosas que tocas",
                description: "Siente la textura de tu ropa, la silla o el aire en tu piel.",
                color: .green,
                action: { withOptionalAnimation(.gentle) { currentStep += 1 } }
            )
            .tag(1)

            // Paso 3: Oído (3 cosas)
            GroundingStepView(
                number: "3",
                icon: "ear.fill",
                title: "Cosas que oyes",
                description:
                    "Escucha atentamente. ¿Puedes oír el tráfico, el viento o tu respiración?",
                color: .orange,
                action: { withOptionalAnimation(.gentle) { currentStep += 1 } }
            )
            .tag(2)

            // Paso 4: Olfato (2 cosas)
            GroundingStepView(
                number: "2",
                icon: "nose.fill",
                title: "Cosas que hueles",
                description: "Intenta percibir aromas sutiles en el ambiente.",
                color: .purple,
                action: { withOptionalAnimation(.gentle) { currentStep += 1 } }
            )
            .tag(3)

            // Paso 5: Gusto (1 cosa)
            GroundingStepView(
                number: "1",
                icon: "mouth.fill",
                title: "Cosa que saboreas",
                description: "Concéntrate en el sabor de tu boca o toma un sorbo de agua.",
                color: .red,
                isLast: true,
                action: { dismiss() }
            )
            .tag(4)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle("Grounding 5-4-3-2-1")
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
                        .font(.system(size: 60))
                        .foregroundStyle(color)

                    Text(number)
                        .font(.system(size: 80, weight: .bold))
                        .foregroundStyle(color)
                }
            }
            .symbolEffect(.bounce, value: true)

            VStack(spacing: 16) {
                Text(title)
                    .font(.largeTitle)
                    .bold()

                Text(description)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }

            Spacer()

            Button(action: action) {
                Text(isLast ? "Finalizar" : "Siguiente")
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
