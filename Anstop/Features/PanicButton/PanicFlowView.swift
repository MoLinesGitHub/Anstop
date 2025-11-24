//
//  PanicFlowView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI

struct PanicFlowView: View {
    @State private var currentStep = 0

    var body: some View {
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
        .navigationBarTitleDisplayMode(.inline)
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
