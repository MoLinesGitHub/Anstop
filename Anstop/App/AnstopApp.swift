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

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView()
                    .environment(purchaseManager)
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: [JournalEntry.self, AnxietyEvent.self, ProgramProgress.self])
    }
}
