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
                title: String(localized: "onboarding_step_safe_space_title"),
                description: String(localized: "onboarding_step_safe_space_description"),
                isLastStep: false,
                nextAction: { withAnimation { currentTab += 1 } }
            )
            .tag(0)

            // Paso 2: Check-in
            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "waveform.path.ecg")
                    .font(.futura(80))
                    .foregroundStyle(.blue.gradient)

                Text("onboarding_how_do_you_feel_today")
                    .font(.futuraLargeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("onboarding_personalize_experience")
                    .font(.futuraBody)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    Text(
                        String(
                            format: String(localized: "onboarding_anxiety_level_format"),
                            Int(initialAnxietyLevel)
                        )
                    )
                        .font(.futuraHeadline)
                        .foregroundStyle(Color("AnstopBlue"))

                    Slider(value: $initialAnxietyLevel, in: 1 ... 10, step: 1)
                        .tint(.blue)

                    HStack {
                        Text("onboarding_low")
                        Spacer()
                        Text("onboarding_high")
                    }
                    .font(.futuraCaption)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 40)

                Spacer()

                Button(action: {
                    HapticManager.shared.triggerImpact(style: .light)
                    withOptionalAnimation(.gentle) { currentTab += 1 }
                }) {
                    Text("onboarding_continue")
                        .padding(.horizontal, 40)
                }
                .buttonStyle(PrimaryButtonStyle())
                .accessibilityIdentifier("onboarding.continue_button")
                .padding(.bottom, 50)
            }
            .tag(1)

            // Paso 3: Personalización
            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "person.crop.circle.fill")
                    .font(.futura(80))
                    .foregroundStyle(.blue.gradient)

                Text("onboarding_whats_your_name")
                    .font(.futuraLargeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("onboarding_name_optional")
                    .font(.futuraBody)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                TextField("onboarding_your_name", text: $userName)
                    .textFieldStyle(.roundedBorder)
                    .font(.futuraTitle3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                Button(action: {
                    HapticManager.shared.triggerImpact(style: .light)
                    withOptionalAnimation(.gentle) { currentTab += 1 }
                }) {
                    Text("onboarding_continue")
                        .padding(.horizontal, 40)
                }
                .buttonStyle(PrimaryButtonStyle())
                .accessibilityIdentifier("onboarding.continue_button")
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
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                // Icono Premium
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color("AnstopBlue"), .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 100, height: 100)

                    Image(systemName: "crown.fill")
                        .font(.futura(45))
                        .foregroundStyle(.white)
                }

                Text("onboarding_soft_paywall_title")
                    .font(.prometheusTitle)
                    .multilineTextAlignment(.center)

                Text("onboarding_soft_paywall_subtitle")
                    .font(.futuraBody)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // Beneficios Premium
                VStack(alignment: .leading, spacing: 16) {
                    PremiumBenefitRow(icon: "checkmark.circle.fill", text: String(localized: "onboarding_soft_paywall_benefit_program"))
                    PremiumBenefitRow(icon: "checkmark.circle.fill", text: String(localized: "onboarding_soft_paywall_benefit_audio"))
                    PremiumBenefitRow(icon: "checkmark.circle.fill", text: String(localized: "onboarding_soft_paywall_benefit_ai"))
                    PremiumBenefitRow(icon: "checkmark.circle.fill", text: String(localized: "onboarding_soft_paywall_benefit_no_ads"))
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 20)

                // Oferta especial
                VStack(spacing: 8) {
                    Text("onboarding_soft_paywall_offer_badge")
                        .font(.futuraCaption)
                        .bold()
                        .foregroundStyle(.orange)

                    Text("onboarding_soft_paywall_trial")
                        .font(.futuraTitle2)
                        .bold()
                }

                Spacer(minLength: 40)

                // CTAs
                VStack(spacing: 12) {
                    Button(action: onShowPaywall) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("onboarding_soft_paywall_start_trial")
                        }
                        .padding(.horizontal, 40)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .accessibilityIdentifier("onboarding.start_trial_button")

                    Button(action: onContinueFree) {
                        Text("onboarding_soft_paywall_continue_basic")
                            .font(.futuraSubheadline)
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityIdentifier("onboarding.continue_basic_button")
                    .padding(.top, 8)
                }
                .padding(.bottom, 50)
            }
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
                .font(.futuraSubheadline)
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
                .font(.futura(80))
                .foregroundStyle(Color("AnstopBlue").gradient)
                .symbolEffect(.bounce, value: true)

            Text(title)
                .font(.futuraLargeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text(description)
                .font(.futuraBody)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Spacer()

            Button(action: {
                HapticManager.shared.triggerImpact(style: .light)
                withOptionalAnimation(.gentle) { nextAction() }
            }) {
                Text(isLastStep ? "onboarding_start" : "onboarding_next")
                    .padding(.horizontal, 40)
            }
            .buttonStyle(PrimaryButtonStyle())
            .accessibilityIdentifier(isLastStep ? "onboarding.start_button" : "onboarding.next_button")
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView()
}
