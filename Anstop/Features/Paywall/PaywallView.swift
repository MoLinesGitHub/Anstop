//
//  PaywallView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import Combine
import StoreKit
import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseManager.self) private var purchaseManager

    @State private var isPurchasing = false
    @State private var showError = false
    @State private var selectedProduct: Product?
    @State private var timeRemaining: Int = 15 * 60 // 15 minutos para urgencia

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header con oferta limitada
                    VStack(spacing: 8) {
                        // Badge de oferta
                        HStack {
                            Image(systemName: "gift.fill")
                                .foregroundStyle(.white)
                            Text("paywall_welcome_offer")
                                .font(.futuraCaption)
                                .bold()
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red.gradient)
                        .clipShape(Capsule())

                        // Countdown timer
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.futuraCaption)
                            Text(
                                String(
                                    format: String(localized: "paywall_offer_ends_in_format"),
                                    timeFormatted
                                )
                            )
                                .font(.futuraSubheadline)
                                .bold()
                        }
                        .foregroundStyle(.red)
                        .padding(.top, 4)
                    }
                    .padding(.top, 20)

                    // Main header
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.futura(70))
                            .foregroundStyle(.blue.gradient)
                            .symbolEffect(.pulse, options: .repeating)

                        Text("paywall_main_title")
                            .font(.futuraTitle)
                            .bold()
                            .multilineTextAlignment(.center)

                        Text("paywall_main_subtitle")
                            .font(.futuraSubheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    // Social proof - Testimonios
                    TestimonialsCarousel()

                    // Estadísticas
                    HStack(spacing: 20) {
                        StatBadge(value: "93%", label: String(localized: "paywall_stat_reduce_anxiety"))
                        StatBadge(value: "4.9★", label: String(localized: "paywall_stat_rating"))
                        StatBadge(value: String(localized: "paywall_simple_trial_value"), label: String(localized: "paywall_simple_trial_label"))
                    }
                    .padding(.horizontal)

                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        Text("paywall_features_title")
                            .font(.futuraHeadline)
                            .padding(.horizontal)

                        FeatureRow(
                            icon: "waveform",
                            title: String(localized: "paywall_feature_audio_title"),
                            description: String(localized: "paywall_feature_audio_description")
                        )
                        FeatureRow(
                            icon: "calendar",
                            title: String(localized: "paywall_feature_program_title"),
                            description: String(localized: "paywall_feature_program_description")
                        )
                        FeatureRow(
                            icon: "sparkles",
                            title: String(localized: "paywall_feature_personalized_title"),
                            description: String(localized: "paywall_feature_personalized_description")
                        )
                        FeatureRow(
                            icon: "cpu",
                            title: String(localized: "paywall_feature_ai_title"),
                            description: String(localized: "paywall_feature_ai_description")
                        )
                        FeatureRow(
                            icon: "paintpalette",
                            title: String(localized: "paywall_feature_ads_title"),
                            description: String(localized: "paywall_feature_ads_description")
                        )
                    }
                    .padding(.horizontal)

                    // Products con selección
                    VStack(spacing: 12) {
                        ForEach(purchaseManager.products) { product in
                            ProductCard(
                                product: product,
                                isSelected: selectedProduct?.id == product.id,
                                isPurchasing: $isPurchasing
                            ) {
                                withAnimation(.gentle) {
                                    selectedProduct = product
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        // Seleccionar el plan anual por defecto
                        if let yearly = purchaseManager.products.first(where: { $0.id.contains("yearly") }) {
                            selectedProduct = yearly
                        } else {
                            selectedProduct = purchaseManager.products.first
                        }
                    }

                    // CTA Principal
                    if let product = selectedProduct {
                        Button(action: {
                            Task { await purchase(product) }
                        }) {
                            VStack(spacing: 4) {
                                Text("paywall_start_free_trial")
                                    .font(.futuraHeadline)
                                Text(
                                    String(
                                        format: String(localized: "paywall_then_price_period_format"),
                                        product.displayPrice,
                                        product.id.contains("yearly")
                                            ? String(localized: "paywall_period_year")
                                            : String(localized: "paywall_period_month")
                                    )
                                )
                                    .font(.futuraCaption)
                                    .opacity(0.9)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.gradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .disabled(isPurchasing)
                        .padding(.horizontal)
                    }

                    // Garantía
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundStyle(.green)
                        Text("paywall_cancel_anytime")
                            .font(.futuraFootnote)
                            .foregroundStyle(.secondary)
                    }

                    // Restore
                    Button("paywall_restore_purchases") {
                        Task {
                            await purchaseManager.restorePurchases()
                            if purchaseManager.isPremium {
                                dismiss()
                            }
                        }
                    }
                    .font(.futuraFootnote)
                    .foregroundStyle(.secondary)

                    // Disclaimer
                    Text("paywall_disclaimer")
                    .font(.futuraCaption2)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
            .anstopBackground(.premium)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("close") { dismiss() }
                        .accessibilityIdentifier("paywall.close_button")
                }
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .alert("paywall_error_title", isPresented: $showError) {
            Button("ok") {}
        } message: {
            Text("paywall_error_message")
        }
    }

    private var timeFormatted: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func purchase(_ product: Product) async {
        isPurchasing = true

        do {
            let success = try await purchaseManager.purchase(product)
            if success {
                dismiss()
            }
        } catch {
            showError = true
        }

        isPurchasing = false
    }
}

// MARK: - Componentes de Monetización

struct TestimonialsCarousel: View {
    let testimonials = [
        Testimonial(textKey: "paywall_testimonial_1_text", authorKey: "paywall_testimonial_1_author", rating: 5),
        Testimonial(textKey: "paywall_testimonial_2_text", authorKey: "paywall_testimonial_2_author", rating: 5),
        Testimonial(textKey: "paywall_testimonial_3_text", authorKey: "paywall_testimonial_3_author", rating: 5),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(testimonials) { testimonial in
                    TestimonialCard(testimonial: testimonial)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct Testimonial: Identifiable {
    let id = UUID()
    let textKey: String
    let authorKey: String
    let rating: Int

    var text: String {
        String(localized: String.LocalizationValue(textKey))
    }

    var author: String {
        String(localized: String.LocalizationValue(authorKey))
    }
}

struct TestimonialCard: View {
    let testimonial: Testimonial

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                ForEach(0 ..< testimonial.rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.futuraCaption2)
                        .foregroundStyle(.yellow)
                }
            }

            Text("\"\(testimonial.text)\"")
                .font(.futuraFootnote)
                .foregroundStyle(.primary)
                .lineLimit(3)

            Text(String(format: String(localized: "paywall_testimonial_author_format"), testimonial.author))
                .font(.futuraCaption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 250)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StatBadge: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.futuraHeadline)
                .foregroundStyle(.blue)
            Text(label)
                .font(.futuraCaption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ProductCard: View {
    let product: Product
    let isSelected: Bool
    @Binding var isPurchasing: Bool
    let onSelect: () -> Void

    var isYearly: Bool {
        product.id.contains("yearly")
    }

    var savings: String? {
        if isYearly {
            return String(localized: "paywall_save_50")
        }
        return nil
    }

    var body: some View {
        Button(action: onSelect) {
            HStack {
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.futuraTitle2)
                    .foregroundStyle(isSelected ? Color("AnstopBlue") : .secondary)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.displayName)
                            .font(.futuraHeadline)
                        if let savings {
                            Text(savings)
                                .font(.futuraCaption2)
                                .bold()
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green)
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                        }
                    }

                    if isYearly {
                        Text(
                            String(
                                format: String(localized: "paywall_only_monthly_price_format"),
                                monthlyPrice
                            )
                        )
                            .font(.futuraCaption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(product.displayPrice)
                        .font(.futuraTitle3)
                        .bold()
                    Text(
                        isYearly
                            ? String(localized: "paywall_per_year")
                            : String(localized: "paywall_per_month")
                    )
                        .font(.futuraCaption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color(uiColor: .secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .disabled(isPurchasing)
    }

    private var monthlyPrice: String {
        let yearlyPrice = product.price
        let monthlyAmount = yearlyPrice / 12
        return monthlyAmount.formatted(.currency(code: product.priceFormatStyle.currencyCode))
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.futuraTitle2)
                .foregroundStyle(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.futuraHeadline)
                Text(description)
                    .font(.futuraSubheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - PaywallSimpleView

struct PaywallSimpleView: View {
    @State private var purchaseManager = PurchaseManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProduct: Product?
    @State private var isPurchasing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.futura(60))
                            .foregroundStyle(.yellow)

                        Text("paywall_simple_title")
                            .font(.prometheusLargeTitle)

                        Text("paywall_simple_subtitle")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)

                    // Estadísticas rápidas
                    HStack(spacing: 16) {
                        MiniStatBadge(value: "93%", label: String(localized: "paywall_simple_effectiveness"))
                        MiniStatBadge(value: String(localized: "paywall_simple_trial_value"), label: String(localized: "paywall_simple_trial_label"))
                    }
                    .padding(.horizontal)

                    if purchaseManager.products.isEmpty {
                        ProgressView("paywall_loading")
                            .padding()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(purchaseManager.products, id: \.id) { product in
                                SimpleProductCard(
                                    product: product,
                                    isSelected: selectedProduct?.id == product.id
                                ) {
                                    withAnimation(.gentle) {
                                        selectedProduct = product
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .onAppear {
                            if let yearly = purchaseManager.products.first(where: { $0.id.contains("yearly") }) {
                                selectedProduct = yearly
                            } else {
                                selectedProduct = purchaseManager.products.first
                            }
                        }

                        // CTA
                        if let product = selectedProduct {
                            Button(action: {
                                Task {
                                    isPurchasing = true
                                    _ = try? await purchaseManager.purchase(product)
                                    isPurchasing = false
                                    if purchaseManager.isPremium {
                                        dismiss()
                                    }
                                }
                            }) {
                                VStack(spacing: 2) {
                                    Text("paywall_start_free_trial")
                                        .font(.futuraHeadline)
                                    Text(
                                        String(
                                            format: String(localized: "paywall_simple_then_price_format"),
                                            product.displayPrice
                                        )
                                    )
                                        .font(.futuraCaption)
                                        .opacity(0.9)
                                }
                            }
                            .disabled(isPurchasing)
                            .padding(.horizontal, 40)
                            .buttonStyle(PrimaryButtonStyle(color: .orange))
                        }
                    }

                    // Garantía
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundStyle(.green)
                            .font(.futuraCaption)
                        Text("paywall_simple_cancel_anytime")
                            .font(.futuraCaption)
                            .foregroundStyle(.secondary)
                    }

                    Button("close") { dismiss() }
                        .accessibilityIdentifier("paywall.simple_close_button")
                        .padding(.horizontal, 40)
                        .buttonStyle(SecondaryButtonStyle(color: .orange))
                        .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("paywall_navigation_title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MiniStatBadge: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.futuraSubheadline)
                .foregroundStyle(.orange)
            Text(label)
                .font(.futuraCaption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SimpleProductCard: View {
    let product: Product
    let isSelected: Bool
    let onSelect: () -> Void

    var isYearly: Bool {
        product.id.contains("yearly")
    }

    var body: some View {
        Button(action: onSelect) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .orange : .secondary)

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(product.displayName)
                            .font(.futuraSubheadline)
                        if isYearly {
                            Text("paywall_50_off")
                                .font(.futuraCaption2)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .clipShape(Capsule())
                        }
                    }
                }

                Spacer()

                Text(product.displayPrice)
                    .font(.futuraSubheadline)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.orange.opacity(0.1) : Color(uiColor: .secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview("PaywallView") {
    PaywallView()
        .environment(PurchaseManager())
}

#Preview("PaywallSimpleView") {
    PaywallSimpleView()
        .environment(PurchaseManager())
}
