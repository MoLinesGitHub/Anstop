// ProgramProgress.swift
import Foundation
import SwiftData

@Model
final class ProgramProgress {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var dayCompleted: Int

    init(id: UUID = UUID(), startDate: Date = Date(), dayCompleted: Int = 0) {
        self.id = id
        self.startDate = startDate
        self.dayCompleted = dayCompleted
    }
}
