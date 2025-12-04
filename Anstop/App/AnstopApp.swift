//
//  AnstopApp.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftData
import SwiftUI

@main
struct AnstopApp: App {
    @State private var purchaseManager = PurchaseManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    static let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            JournalEntry.self,
            AnxietyEvent.self,
            ProgramProgress.self,
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("No se pudo crear ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
            .environment(purchaseManager)
        }
        .modelContainer(Self.sharedModelContainer)
    }
}
