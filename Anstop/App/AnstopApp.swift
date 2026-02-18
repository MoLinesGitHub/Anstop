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

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        let defaults = UserDefaults.standard

        if arguments.contains("UI_TESTING_RESET") {
            defaults.removeObject(forKey: "hasCompletedOnboarding")
            defaults.removeObject(forKey: "userName")
            defaults.removeObject(forKey: "initialAnxietyLevel")
            defaults.removeObject(forKey: "panicFlowCompletionCount")
        }

        if arguments.contains("UI_TESTING_SKIP_ONBOARDING") {
            defaults.set(true, forKey: "hasCompletedOnboarding")
        }
    }

    static let sharedModelContainer: ModelContainer = {
        let isUITesting = ProcessInfo.processInfo.arguments.contains("UI_TESTING")
        let schema = Schema([
            JournalEntry.self,
            AnxietyEvent.self,
            ProgramProgress.self,
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isUITesting
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
