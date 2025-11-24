//
//  PanicFlowView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI

// Note: Transitions/animations should use withOptionalAnimation where state changes are added in the future.

struct PanicFlowView: View {
    @State private var currentStep = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            TabView(selection: $currentStep) {
                PanicStepView(
                    title: "Respira conmigo",
                    description: "Tu cuerpo está a salvo. Vamos a respirar juntos.",
                    showBreathing: true
                )
                .tag(0)

                PanicStepView(
                    title: "Tu cuerpo está a salvo",
                    description: "Lo que sientes es incómodo, pero no es peligroso.",
                    showBreathing: false
                )
                .tag(1)

                PanicStepView(
                    title: "Vamos a bajar tu ritmo",
                    description: "Estás haciendo un gran trabajo. Sigue respirando.",
                    showBreathing: true
                )
                .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button(action: advance) {
                Text(currentStep >= 2 ? "Finalizar" : "Continuar")
                    .padding(.horizontal, 40)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.bottom, 12)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func advance() {
        if currentStep >= 2 {
            dismiss()
        } else {
            withOptionalAnimation(.gentle) { currentStep += 1 }
        }
    }
}

struct PanicStepView: View {
    let title: String
    let description: String
    let showBreathing: Bool

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            if showBreathing {
                BreathingCircle()
            }

            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text(description)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        PanicFlowView()
    }
}
