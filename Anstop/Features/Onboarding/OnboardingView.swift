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
    @State private var showPaywall = false

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

                Button(action: {
                    HapticManager.shared.triggerImpact(style: .light)
                    withOptionalAnimation(.gentle) { currentTab += 1 }
                }) {
                    Text("Continuar")
                        .padding(.horizontal, 40)
                }
                .buttonStyle(PrimaryButtonStyle())
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
                    HapticManager.shared.triggerImpact(style: .light)
                    withOptionalAnimation(.gentle) { currentTab += 1 }
                }) {
                    Text("Continuar")
                        .padding(.horizontal, 40)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.bottom, 50)
            }
            .tag(2)
            
            // Paso 4: Soft Paywall - Mostrar valor premium
            SoftPaywallStep(
                onContinueFree: {
                    HapticManager.shared.triggerNotification(.success)
                    withOptionalAnimation(.gentle) {
                        hasCompletedOnboarding = true
                    }
                },
                onShowPaywall: {
                    showPaywall = true
                }
            )
            .tag(3)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}

// MARK: - Soft Paywall Step

struct SoftPaywallStep: View {
    let onContinueFree: () -> Void
    let onShowPaywall: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icono Premium
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 45))
                    .foregroundStyle(.white)
            }
            
            Text("Obtén resultados más rápidos")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("El 93% de usuarios premium reportan una reducción significativa de la ansiedad en 2 semanas")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            // Beneficios Premium
            VStack(alignment: .leading, spacing: 16) {
                PremiumBenefitRow(icon: "checkmark.circle.fill", text: "Programa completo de 30 días")
                PremiumBenefitRow(icon: "checkmark.circle.fill", text: "20+ guías de audio exclusivas")
                PremiumBenefitRow(icon: "checkmark.circle.fill", text: "Asistente IA disponible 24/7")
                PremiumBenefitRow(icon: "checkmark.circle.fill", text: "Sin anuncios ni interrupciones")
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            
            // Oferta especial
            VStack(spacing: 8) {
                Text("🎁 OFERTA DE BIENVENIDA")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.orange)
                
                Text("7 días de prueba GRATIS")
                    .font(.title2)
                    .bold()
            }
            
            Spacer()
            
            // CTAs
            VStack(spacing: 12) {
                Button(action: onShowPaywall) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Comenzar prueba gratuita")
                    }
                    .padding(.horizontal, 40)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button(action: onContinueFree) {
                    Text("Continuar con versión básica")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)
            }
            .padding(.bottom, 50)
        }
    }
}

struct PremiumBenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.green)
            Text(text)
                .font(.subheadline)
        }
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

            Button(action: {
                HapticManager.shared.triggerImpact(style: .light)
                withOptionalAnimation(.gentle) { nextAction() }
            }) {
                Text(isLastStep ? "Comenzar" : "Siguiente")
                    .padding(.horizontal, 40)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView()
}
