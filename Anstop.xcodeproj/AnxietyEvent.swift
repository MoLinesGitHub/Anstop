// AnxietyEvent.swift
import Foundation
import SwiftData

@Model
final class AnxietyEvent {
    @Attribute(.unique) var id: UUID
    var date: Date
    var intensity: Int
    var notes: String?

    init(id: UUID = UUID(), date: Date = Date(), intensity: Int = 5, notes: String? = nil) {
        self.id = id
        self.date = date
        self.intensity = intensity
        self.notes = notes
    }
}
