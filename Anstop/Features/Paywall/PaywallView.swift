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
                            Text("OFERTA DE BIENVENIDA")
                                .font(.caption)
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
                                .font(.caption)
                            Text("Oferta termina en: \(timeFormatted)")
                                .font(.subheadline)
                                .bold()
                        }
                        .foregroundStyle(.red)
                        .padding(.top, 4)
                    }
                    .padding(.top, 20)
                    
                    // Main header
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(.blue.gradient)
                            .symbolEffect(.pulse, options: .repeating)

                        Text("Tu calma, siempre contigo")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)

                        Text("Únete a +50,000 personas que han transformado su relación con la ansiedad")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    // Social proof - Testimonios
                    TestimonialsCarousel()
                    
                    // Estadísticas
                    HStack(spacing: 20) {
                        StatBadge(value: "93%", label: "Reducen ansiedad")
                        StatBadge(value: "4.9★", label: "Valoración")
                        StatBadge(value: "7 días", label: "Prueba gratis")
                    }
                    .padding(.horizontal)

                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Todo incluido en Premium:")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        FeatureRow(
                            icon: "waveform", title: "Guías completas de audio",
                            description: "20+ ejercicios de respiración y relajación"
                        )
                        FeatureRow(
                            icon: "calendar", title: "Programa de 30 días",
                            description: "Plan estructurado que funciona")
                        FeatureRow(
                            icon: "sparkles", title: "Ejercicios personalizados",
                            description: "Adaptados a tu nivel de ansiedad")
                        FeatureRow(
                            icon: "cpu", title: "Asistente IA 24/7",
                            description: "Apoyo emocional cuando lo necesites")
                        FeatureRow(
                            icon: "paintpalette", title: "Sin publicidad",
                            description: "Experiencia tranquila y sin interrupciones")
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
                                Text("Comenzar 7 días GRATIS")
                                    .font(.headline)
                                Text("Luego \(product.displayPrice)/\(product.id.contains("yearly") ? "año" : "mes")")
                                    .font(.caption)
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
                        Text("Cancela cuando quieras • Sin compromiso")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

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
                    Text("No sustituye ayuda profesional. Los pagos se cargarán a tu cuenta de Apple. La suscripción se renueva automáticamente a menos que se cancele 24h antes del fin del período.")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 40)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text("No se pudo completar la compra. Inténtalo de nuevo.")
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
        Testimonial(text: "Esta app me salvó durante mis peores momentos de ansiedad. Ahora puedo manejarla.", author: "María G.", rating: 5),
        Testimonial(text: "El programa de 30 días cambió mi vida. Lo recomiendo 100%.", author: "Carlos R.", rating: 5),
        Testimonial(text: "Simple pero muy efectiva. Las guías de respiración son increíbles.", author: "Ana L.", rating: 5)
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
    let text: String
    let author: String
    let rating: Int
}

struct TestimonialCard: View {
    let testimonial: Testimonial
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                ForEach(0..<testimonial.rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                }
            }
            
            Text("\"\(testimonial.text)\"")
                .font(.footnote)
                .foregroundStyle(.primary)
                .lineLimit(3)
            
            Text("— \(testimonial.author)")
                .font(.caption)
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
                .font(.headline)
                .foregroundStyle(.blue)
            Text(label)
                .font(.caption2)
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
            return "Ahorra 50%"
        }
        return nil
    }
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .blue : .secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.displayName)
                            .font(.headline)
                        if let savings = savings {
                            Text(savings)
                                .font(.caption2)
                                .bold()
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green)
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                        }
                    }
                    
                    if isYearly {
                        Text("Solo \(monthlyPrice)/mes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(product.displayPrice)
                        .font(.title3)
                        .bold()
                    Text(isYearly ? "/año" : "/mes")
                        .font(.caption)
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
        return monthlyAmount.formatted(.currency(code: product.priceFormatStyle.currencyCode ?? "EUR"))
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

#Preview {
    PaywallView()
        .environment(PurchaseManager())
}
