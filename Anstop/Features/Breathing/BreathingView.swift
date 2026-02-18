//
//  BreathingView.swift
//  Anstop
//
//  Created on 2025-11-24.
//  Updated with GlassKitPro - 2025-12-03
//

import GlassKitPro
import SwiftUI

struct BreathingView: View {
    @State private var selectedProtocol: BreathingProtocol = .fourSevenEight

    var body: some View {
        ZStack {
            // Fondo Anstop con ondas líquidas y partículas cyan
            AnstopBackground.breathing

            VStack(spacing: 40) {
                // Selector de protocolo con diseño glass
                VStack(spacing: 16) {
                    Text("breathing_choose_technique")
                        .font(.futuraHeadline)
                        .foregroundStyle(.secondary)

                    Picker("breathing_protocol_picker", selection: $selectedProtocol) {
                        ForEach(BreathingProtocol.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                }

                Spacer()

                // Círculo de respiración con efecto glass
                ZStack {
                    // Círculo exterior con efecto glow suave
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .cyan.opacity(0.1),
                                    Color("AnstopBlue").opacity(0.05),
                                    .clear,
                                ],
                                center: .center,
                                startRadius: 50,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)

                    BreathingCircle()
                }

                Spacer()

                // Información del protocolo con diseño glassmorphic
                // TODO: Reactivar GlassKit.CrystalLiquidCard cuando se publique versión pública
                VStack(alignment: .leading, spacing: 16) {
                    Text(selectedProtocol.name)
                        .font(.futuraTitle2)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lungs.fill")
                                .font(.futuraTitle2)
                                .foregroundStyle(.cyan)

                            Spacer()
                        }

                        Text(selectedProtocol.description)
                            .font(.futuraSubheadline)
                            .foregroundStyle(.secondary)

                        Text(selectedProtocol.benefits)
                            .font(.futuraCaption)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 4)
                    }
                }
                .padding(24)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .navigationTitle("breathing_title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

enum BreathingProtocol: String, CaseIterable, Identifiable {
    case fourSevenEight = "4-7-8"
    case fourFour = "4-4"
    case threeThreeThree = "3-3-3"

    var id: String { rawValue }

    var name: String {
        switch self {
        case .fourSevenEight: "4-7-8"
        case .fourFour: "4-4"
        case .threeThreeThree: "3-3-3"
        }
    }

    var description: String {
        switch self {
        case .fourSevenEight: String(localized: "breathing_protocol_478_description")
        case .fourFour: String(localized: "breathing_protocol_44_description")
        case .threeThreeThree: String(localized: "breathing_protocol_333_description")
        }
    }

    var benefits: String {
        switch self {
        case .fourSevenEight: String(localized: "breathing_protocol_478_benefits")
        case .fourFour: String(localized: "breathing_protocol_44_benefits")
        case .threeThreeThree: String(localized: "breathing_protocol_333_benefits")
        }
    }
}

#Preview {
    NavigationStack {
        BreathingView()
    }
}
