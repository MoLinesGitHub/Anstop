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
    @State private var showCompletion = false
    @State private var showPaywall = false
    @Environment(\.dismiss) private var dismiss
    @State private var purchaseManager = PurchaseManager.shared
    @AppStorage("panicFlowCompletionCount") private var completionCount = 0

    var body: some View {
        VStack(spacing: 16) {
            if showCompletion {
                // Pantalla de finalización con CTA premium
                PanicCompletionView(
                    isPremium: purchaseManager.isPremium,
                    onContinue: {
                        dismiss()
                    },
                    onShowPremium: {
                        showPaywall = true
                    }
                )
            } else {
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
        }
        .anstopBackground(.panic)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private func advance() {
        if currentStep >= 2 {
            completionCount += 1
            withOptionalAnimation(.gentle) {
                showCompletion = true
            }
        } else {
            withOptionalAnimation(.gentle) { currentStep += 1 }
        }
    }
}

// MARK: - Pantalla de Completado con CTA Premium

struct PanicCompletionView: View {
    let isPremium: Bool
    let onContinue: () -> Void
    let onShowPremium: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Icono de éxito
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: "checkmark.circle.fill")
                    .font(.futura(80))
                    .foregroundStyle(.green)
                    .symbolEffect(.bounce)
            }

            Text("Lo lograste")
                .font(.futuraLargeTitle)
                .bold()

            Text("Has completado el ejercicio. Tu cuerpo y mente están más tranquilos ahora.")
                .font(.futuraBody)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Mostrar CTA premium solo a usuarios no premium
            if !isPremium {
                VStack(spacing: 16) {
                    Divider()
                        .padding(.horizontal, 40)

                    // Sugerencia Premium
                    VStack(spacing: 12) {
                        Text("🌟 ¿Quieres más herramientas?")
                            .font(.futuraHeadline)

                        Text("Con Premium tendrás acceso a 20+ guías de audio, el programa de 30 días y un asistente IA disponible 24/7.")
                            .font(.futuraSubheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button(action: onShowPremium) {
                            HStack {
                                Image(systemName: "crown.fill")
                                Text("Probar Premium 7 días gratis")
                            }
                            .font(.futuraSubheadline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }

            Spacer()

            if isPremium {
                Button(action: onContinue) {
                    Text("Volver al inicio")
                        .padding(.horizontal, 40)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.bottom, 40)
            } else {
                Button(action: onContinue) {
                    Text("Volver al inicio")
                        .padding(.horizontal, 40)
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.bottom, 40)
            }
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
                .font(.futuraLargeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text(description)
                .font(.futuraTitle3)
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
            .environment(PurchaseManager())
    }
}
