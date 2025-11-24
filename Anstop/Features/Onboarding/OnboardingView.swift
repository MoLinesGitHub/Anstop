//
//  OnboardingView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userName") private var userName = ""
    @AppStorage("initialAnxietyLevel") private var initialAnxietyLevel = 5.0

    @State private var currentTab = 0

    var body: some View {
        TabView(selection: $currentTab) {
            // Paso 1: Bienvenida
            OnboardingStepView(
                image: "heart.text.square.fill",
                title: "Tu espacio seguro",
                description:
                    "Anstop está aquí para ayudarte a recuperar la calma, a tu propio ritmo.",
                isLastStep: false,
                nextAction: { withAnimation { currentTab += 1 } }
            )
            .tag(0)

            // Paso 2: Check-in
            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue.gradient)

                Text("¿Cómo te sientes hoy?")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("Esto nos ayuda a personalizar tu experiencia.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    Text("Nivel de ansiedad: \(Int(initialAnxietyLevel))")
                        .font(.headline)
                        .foregroundStyle(.blue)

                    Slider(value: $initialAnxietyLevel, in: 1...10, step: 1)
                        .tint(.blue)

                    HStack {
                        Text("Baja")
                        Spacer()
                        Text("Alta")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 40)

                Spacer()

                Button(action: { withAnimation { currentTab += 1 } }) {
                    Text("Continuar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.blue))
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
            .tag(1)

            // Paso 3: Personalización
            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue.gradient)

                Text("¿Cómo te llamas?")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("Opcional. Solo para dirigirnos a ti.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                TextField("Tu nombre", text: $userName)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                Button(action: {
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text("Comenzar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.blue))
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
            .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingStepView: View {
    let image: String
    let title: String
    let description: String
    let isLastStep: Bool
    let nextAction: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: image)
                .font(.system(size: 80))
                .foregroundStyle(.blue.gradient)
                .symbolEffect(.bounce, value: true)

            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text(description)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Spacer()

            Button(action: nextAction) {
                Text(isLastStep ? "Comenzar" : "Siguiente")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(RoundedRectangle(cornerRadius: 16).fill(.blue))
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView()
}
