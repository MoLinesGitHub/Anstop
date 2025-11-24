//
//  BreathingView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI

struct BreathingView: View {
    @State private var selectedProtocol: BreathingProtocol = .fourSevenEight

    var body: some View {
        VStack(spacing: 40) {
            Picker("Protocolo", selection: $selectedProtocol) {
                ForEach(BreathingProtocol.allCases) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            BreathingCircle()

            VStack(spacing: 8) {
                Text(selectedProtocol.name)
                    .font(.title2)
                    .bold()
                Text(selectedProtocol.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
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
}

#Preview {
    NavigationStack {
        BreathingView()
    }
}
