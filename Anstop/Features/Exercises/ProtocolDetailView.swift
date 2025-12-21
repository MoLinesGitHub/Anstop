//
//  ProtocolDetailView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI

struct ProtocolDetailView: View {
    let protocolData: Protocol
    @State private var currentStep = 0

    var body: some View {
        VStack {
            // Header
            VStack(spacing: 20) {
                Image(systemName: protocolData.icon)
                    .font(.futura(60))
                    .foregroundStyle(protocolData.color.gradient)
                    .padding(.top, 40)

                Text(protocolData.title)
                    .font(.prometheusTitle)
                    .multilineTextAlignment(.center)

                Text(protocolData.description)
                    .font(.futuraBody)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)

            // Steps
            TabView(selection: $currentStep) {
                ForEach(Array(protocolData.steps.enumerated()), id: \.element.id) { index, step in
                    ProtocolStepCard(
                        step: step, index: index, total: protocolData.steps.count,
                        color: protocolData.color
                    )
                    .tag(index)
                    .padding()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct ProtocolStepCard: View {
    let step: ProtocolStep
    let index: Int
    let total: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Paso \(index + 1)/\(total)")
                    .font(.futuraCaption)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                    .padding(8)
                    .background(color.opacity(0.1))
                    .clipShape(Capsule())

                Spacer()
            }

            Text(step.title)
                .font(.futuraTitle2)
                .bold()

            Text(step.content)
                .font(.futuraBody)
                .foregroundStyle(.secondary)
                .lineSpacing(6)

            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ProtocolDetailView(protocolData: Protocol.all[0])
}
