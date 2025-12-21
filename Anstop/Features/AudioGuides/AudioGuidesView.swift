//
//  AudioGuidesView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import GlassKitPro
import SwiftUI

struct AudioGuidesView: View {
    @State private var purchaseManager = PurchaseManager.shared
    @State private var audioManager = AudioManager()
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo Anstop con partículas púrpura
                AnstopBackground.audio

                List {
                    Section("Gratis") {
                        ForEach(AudioGuide.freeGuides) { guide in
                            AudioGuideRow(guide: guide, audioManager: audioManager)
                        }
                    }

                    Section {
                        ForEach(AudioGuide.premiumGuides) { guide in
                            AudioGuideRow(
                                guide: guide,
                                audioManager: audioManager,
                                isPremium: true,
                                isLocked: !purchaseManager.isPremium
                            ) {
                                showPaywall = true
                            }
                        }
                    } header: {
                        HStack {
                            Text("Premium")
                            Spacer()
                            if !purchaseManager.isPremium {
                                Image(systemName: "lock.fill")
                                    .font(.futuraCaption)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Guías de Audio")
            .sheet(isPresented: $showPaywall) {
                PaywallSimpleView()
            }
        }
    }
}

struct AudioGuideRow: View {
    let guide: AudioGuide
    let audioManager: AudioManager
    var isPremium: Bool = false
    var isLocked: Bool = false
    var onLockTap: (() -> Void)?

    var isPlaying: Bool {
        audioManager.currentAudio == guide.fileName && audioManager.isPlaying
    }

    var body: some View {
        Button(action: {
            if isLocked {
                onLockTap?()
            } else {
                togglePlay()
            }
        }) {
            HStack {
                Image(systemName: guide.icon)
                    .font(.futuraTitle2)
                    .foregroundStyle(isPremium ? .orange : .blue)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(guide.title)
                        .font(.futuraHeadline)
                    Text(guide.description)
                        .font(.futuraSubheadline)
                        .foregroundStyle(.secondary)
                    Text(guide.duration)
                        .font(.futuraCaption)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.secondary)
                } else {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.futuraTitle2)
                        .foregroundStyle(Color("Blue"))
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func togglePlay() {
        if isPlaying {
            audioManager.pause()
        } else {
            audioManager.play(guide.fileName)
        }
    }
}

struct AudioGuide: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let fileName: String
    let duration: String
    let icon: String
    let isPremium: Bool

    static let freeGuides: [AudioGuide] = [
        AudioGuide(
            title: "Respiración básica",
            description: "Ejercicio de respiración 4-7-8",
            fileName: "breathing_basic",
            duration: "3 min",
            icon: "wind",
            isPremium: false
        ),
        AudioGuide(
            title: "Primer auxilio emocional",
            description: "Guía rápida para momentos de crisis",
            fileName: "emergency_calm",
            duration: "5 min",
            icon: "cross.circle",
            isPremium: false
        ),
    ]

    static let premiumGuides: [AudioGuide] = [
        AudioGuide(
            title: "Relajación profunda",
            description: "Meditación guiada completa",
            fileName: "deep_relaxation",
            duration: "15 min",
            icon: "moon.stars",
            isPremium: true
        ),
        AudioGuide(
            title: "Ansiedad nocturna",
            description: "Ejercicio especial para dormir",
            fileName: "night_anxiety",
            duration: "20 min",
            icon: "bed.double",
            isPremium: true
        ),
        AudioGuide(
            title: "Técnicas avanzadas",
            description: "Mindfulness y reestructuración cognitiva",
            fileName: "advanced_techniques",
            duration: "12 min",
            icon: "brain.head.profile",
            isPremium: true
        ),
    ]
}

#Preview {
    AudioGuidesView()
        .environment(PurchaseManager())
}
