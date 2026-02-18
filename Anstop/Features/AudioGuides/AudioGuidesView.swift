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
                    Section("audio_guides_section_free") {
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
                            Text("audio_guides_section_premium")
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
            .navigationTitle("audio_guides_navigation_title")
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
                        .foregroundStyle(Color("AnstopBlue"))
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
    let titleKey: String
    let descriptionKey: String
    let fileName: String
    let durationKey: String
    let icon: String
    let isPremium: Bool

    var title: String {
        NSLocalizedString(titleKey, comment: "")
    }

    var description: String {
        NSLocalizedString(descriptionKey, comment: "")
    }

    var duration: String {
        NSLocalizedString(durationKey, comment: "")
    }

    static let freeGuides: [AudioGuide] = [
        AudioGuide(
            titleKey: "audio_guide_basic_breathing_title",
            descriptionKey: "audio_guide_basic_breathing_description",
            fileName: "breathing_basic",
            durationKey: "audio_guide_duration_3_min",
            icon: "wind",
            isPremium: false
        ),
        AudioGuide(
            titleKey: "audio_guide_emotional_first_aid_title",
            descriptionKey: "audio_guide_emotional_first_aid_description",
            fileName: "emergency_calm",
            durationKey: "audio_guide_duration_5_min",
            icon: "cross.circle",
            isPremium: false
        ),
    ]

    static let premiumGuides: [AudioGuide] = [
        AudioGuide(
            titleKey: "audio_guide_deep_relaxation_title",
            descriptionKey: "audio_guide_deep_relaxation_description",
            fileName: "deep_relaxation",
            durationKey: "audio_guide_duration_15_min",
            icon: "moon.stars",
            isPremium: true
        ),
        AudioGuide(
            titleKey: "audio_guide_night_anxiety_title",
            descriptionKey: "audio_guide_night_anxiety_description",
            fileName: "night_anxiety",
            durationKey: "audio_guide_duration_20_min",
            icon: "bed.double",
            isPremium: true
        ),
        AudioGuide(
            titleKey: "audio_guide_advanced_techniques_title",
            descriptionKey: "audio_guide_advanced_techniques_description",
            fileName: "advanced_techniques",
            durationKey: "audio_guide_duration_12_min",
            icon: "brain.head.profile",
            isPremium: true
        ),
    ]
}

#Preview {
    AudioGuidesView()
        .environment(PurchaseManager())
}
