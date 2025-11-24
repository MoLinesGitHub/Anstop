//
//  ProgramProgress.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import Foundation
import SwiftData

@Model
final class ProgramProgress {
    @Attribute(.unique) var id: UUID
    var completedDays: [Int]
    var currentStreak: Int
    var lastCompletedDate: Date?

    init() {
        self.id = UUID()
        self.completedDays = []
        self.currentStreak = 0
        self.lastCompletedDate = nil
    }

    func markDayCompleted(_ day: Int) {
        guard !completedDays.contains(day) else { return }

        completedDays.append(day)
        completedDays.sort()

        // Actualizar racha
        if let lastDate = lastCompletedDate {
            let calendar = Calendar.current
            if calendar.isDateInYesterday(lastDate) || calendar.isDateInToday(lastDate) {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        lastCompletedDate = Date()
    }

    func isDayCompleted(_ day: Int) -> Bool {
        completedDays.contains(day)
    }

    func isDayUnlocked(_ day: Int) -> Bool {
        // El día 1 siempre está desbloqueado
        if day == 1 { return true }

        // Los demás días se desbloquean si el anterior está completado
        return completedDays.contains(day - 1)
    }

    var progressPercentage: Double {
        Double(completedDays.count) / 30.0
    }
}
