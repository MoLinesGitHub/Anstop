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

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(purchaseManager)
        }
        .modelContainer(for: [JournalEntry.self, AnxietyEvent.self])
    }
}
