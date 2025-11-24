//
//  PaywallView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import StoreKit
import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseManager.self) private var purchaseManager

    @State private var isPurchasing = false
    @State private var showError = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.blue.gradient)

                        Text("Tu calma, siempre contigo")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)

                        Text("Ayuda inmediata cuando más la necesitas")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)

                    // Features
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(
                            icon: "waveform", title: "Guías completas de audio",
                            description: "Acceso a todos los ejercicios de respiración y relajación"
                        )
                        FeatureRow(
                            icon: "calendar", title: "Programa de 30 días",
                            description: "Plan estructurado para gestionar tu ansiedad")
                        FeatureRow(
                            icon: "sparkles", title: "Ejercicios personalizados",
                            description: "Adaptados a tus necesidades específicas")
                        FeatureRow(
                            icon: "cpu", title: "Asistente IA",
                            description: "Apoyo emocional disponible 24/7")
                        FeatureRow(
                            icon: "paintpalette", title: "Personalización",
                            description: "Temas y sonidos premium")
                    }
                    .padding(.horizontal)

                    // Products
                    VStack(spacing: 15) {
                        ForEach(purchaseManager.products) { product in
                            ProductButton(product: product, isPurchasing: $isPurchasing) {
                                await purchase(product)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Restore
                    Button("Restaurar compras") {
                        Task {
                            await purchaseManager.restorePurchases()
                            if purchaseManager.isPremium {
                                dismiss()
                            }
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                    // Disclaimer
                    Text("No sustituye ayuda profesional. Cancela cuando quieras.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text("No se pudo completar la compra. Inténtalo de nuevo.")
        }
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

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ProductButton: View {
    let product: Product
    @Binding var isPurchasing: Bool
    let action: () async -> Void

    var isYearly: Bool {
        product.id.contains("yearly")
    }

    var body: some View {
        Button(action: { Task { await action() } }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.displayName)
                            .font(.headline)
                        if isYearly {
                            Text("MEJOR PRECIO")
                                .font(.caption2)
                                .bold()
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green)
                                .foregroundStyle(.white)
                                .cornerRadius(4)
                        }
                    }
                    Text(product.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(product.displayPrice)
                    .font(.title3)
                    .bold()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isYearly ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isYearly ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .disabled(isPurchasing)
        .buttonStyle(.plain)
    }
}

#Preview {
    PaywallView()
        .environment(PurchaseManager())
}
