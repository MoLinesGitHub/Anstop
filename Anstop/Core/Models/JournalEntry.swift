//
//  JournalEntry.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftData
import Foundation

@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mood: Int
    var notes: String?
    
    init(id: UUID = UUID(), date: Date = Date(), mood: Int = 5, notes: String? = nil) {
        self.id = id
        self.date = date
        self.mood = mood
        self.notes = notes
    }
}
