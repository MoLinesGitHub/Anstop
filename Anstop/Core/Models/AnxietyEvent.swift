//
//  AnxietyEvent.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import Foundation
import SwiftData

@Model
final class AnxietyEvent {
    @Attribute(.unique) var id: UUID
    var date: Date
    var intensity: Int

    init(id: UUID = UUID(), date: Date = Date(), intensity: Int = 5) {
        self.id = id
        self.date = date
        self.intensity = intensity
    }
}
