// PaywallView.swift
import SwiftUI
import StoreKit

struct PaywallSimpleView: View {
    @Environment(PurchaseManager.self) private var purchaseManager
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
                            .font(.system(size: 60))
                            .foregroundStyle(.yellow)

                        Text("Desbloquea Premium")
                            .font(.largeTitle).bold()

                        Text("Accede a todas las guías de audio y contenido exclusivo.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Estadísticas rápidas
                    HStack(spacing: 16) {
                        MiniStatBadge(value: "93%", label: "Eficacia")
                        MiniStatBadge(value: "7 días", label: "Prueba gratis")
                    }
                    .padding(.horizontal)

                    if purchaseManager.products.isEmpty {
                        ProgressView("Cargando...")
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
                                    Text("Comenzar 7 días GRATIS")
                                        .font(.headline)
                                    Text("Luego \(product.displayPrice)")
                                        .font(.caption)
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
                            .font(.caption)
                        Text("Cancela cuando quieras")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Button("Cerrar") { dismiss() }
                        .padding(.horizontal, 40)
                        .buttonStyle(SecondaryButtonStyle(color: .orange))
                        .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("Premium")
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
                .font(.subheadline.bold())
                .foregroundStyle(.orange)
            Text(label)
                .font(.caption2)
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
                            .font(.subheadline.bold())
                        if isYearly {
                            Text("50% OFF")
                                .font(.caption2)
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
                    .font(.subheadline.bold())
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

#Preview {
    PaywallSimpleView()
        .environment(PurchaseManager())
}
