//
//  HomeView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI

struct HomeView: View {
    @State private var showPanicFlow = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                // Botón principal de pánico
                Button(action: {
                    showPanicFlow = true
                }) {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 60))
                        Text("Estoy teniendo ansiedad")
                            .font(.title2)
                            .bold()
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue.gradient)
                    )
                    .padding(.horizontal, 40)
                }

                // Accesos rápidos
                VStack(spacing: 15) {
                    NavigationLink(destination: BreathingView()) {
                        QuickAccessButton(title: "Respiración", icon: "wind")
                    }

                    NavigationLink(destination: GroundingView()) {
                        QuickAccessButton(title: "Grounding 5-4-3-2-1", icon: "hand.raised.fill")
                    }

                    NavigationLink(destination: AudioGuidesView()) {
                        QuickAccessButton(title: "Audio calmante", icon: "speaker.wave.2.fill")
                    }

                    NavigationLink(destination: DailyJournalView()) {
                        QuickAccessButton(title: "Diario del día", icon: "book.fill")
                    }
                }
                .padding(.horizontal, 40)

                Spacer()
            }
            .navigationTitle("Anstop")
            .navigationDestination(isPresented: $showPanicFlow) {
                PanicFlowView()
            }
        }
    }
}

struct QuickAccessButton: View {
    let title: String
    let icon: String

    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.body)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .foregroundStyle(.primary)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background.opacity(0.5))
            )
        }
    }
}

#Preview {
    HomeView()
}
