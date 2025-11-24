// PaywallView.swift
import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(PurchaseManager.self) private var purchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)

                Text("Desbloquea Premium")
                    .font(.largeTitle).bold()

                Text("Accede a todas las guías de audio y contenido exclusivo.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if purchaseManager.products.isEmpty {
                    ProgressView("Cargando...")
                } else {
                    ForEach(purchaseManager.products, id: \.id) { product in
                        Button(action: { Task { _ = try? await purchaseManager.purchase(product) } }) {
                            HStack {
                                Text(product.displayName)
                                Spacer()
                                Text(product.displayPrice)
                            }
                            .padding(.horizontal, 40)
                        }
                        .buttonStyle(PrimaryButtonStyle(color: .orange))
                    }
                }

                Button("Cerrar") { dismiss() }
                    .padding(.horizontal, 40)
                    .buttonStyle(SecondaryButtonStyle(color: .orange))
                    .padding(.top, 8)
            }
            .padding()
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PaywallView()
        .environment(PurchaseManager())
}
