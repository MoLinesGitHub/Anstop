//
//  BreathingView.swift
//  Anstop
//
//  Created on 2025-11-24.
//  Updated with GlassKitPro - 2025-12-03
//

import SwiftUI
import GlassKitPro

struct BreathingView: View {
    @State private var selectedProtocol: BreathingProtocol = .fourSevenEight

    var body: some View {
        ZStack {
            // Fondo suave con partículas para transmitir calma
            GlassKit.CrystalParticles()
                .opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Selector de protocolo con diseño glass
                VStack(spacing: 16) {
                    Text("Elige tu técnica")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Picker("Protocolo", selection: $selectedProtocol) {
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
                                    .blue.opacity(0.05),
                                    .clear
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
                
                // Información del protocolo con diseño glass card
                GlassKit.CrystalLiquidCard(
                    title: selectedProtocol.name,
                    accentColor: .cyan,
                    intensity: 0.5
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lungs.fill")
                                .font(.title2)
                                .foregroundStyle(.cyan)
                            
                            Spacer()
                        }
                        
                        Text(selectedProtocol.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(selectedProtocol.benefits)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .navigationTitle("Respiración")
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
        case .fourSevenEight: return "4-7-8"
        case .fourFour: return "4-4"
        case .threeThreeThree: return "3-3-3"
        }
    }

    var description: String {
        switch self {
        case .fourSevenEight: return "Inhala 4s, mantén 7s, exhala 8s"
        case .fourFour: return "Inhala 4s, exhala 4s"
        case .threeThreeThree: return "Inhala 3s, mantén 3s, exhala 3s"
        }
    }
    
    var benefits: String {
        switch self {
        case .fourSevenEight: return "Ideal para calmar la mente y reducir la ansiedad rápidamente"
        case .fourFour: return "Perfecto para mantener la calma y el equilibrio"
        case .threeThreeThree: return "Excelente para momentos de estrés intenso"
        }
    }
}

#Preview {
    NavigationStack {
        BreathingView()
    }
}
