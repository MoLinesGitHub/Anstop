//
//  Protocol.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import Foundation
import SwiftUI

struct Protocol: Identifiable {
    let id = UUID()
    let titleKey: String
    let descriptionKey: String
    let icon: String
    let color: Color
    let steps: [ProtocolStep]

    var title: String {
        NSLocalizedString(titleKey, comment: "")
    }

    var description: String {
        NSLocalizedString(descriptionKey, comment: "")
    }

    static let all: [Protocol] = [
        Protocol(
            titleKey: "protocol_1_title",
            descriptionKey: "protocol_1_description",
            icon: "brain.head.profile",
            color: .purple,
            steps: [
                ProtocolStep(titleKey: "protocol_1_step_1_title", contentKey: "protocol_1_step_1_content"),
                ProtocolStep(titleKey: "protocol_1_step_2_title", contentKey: "protocol_1_step_2_content"),
                ProtocolStep(titleKey: "protocol_1_step_3_title", contentKey: "protocol_1_step_3_content"),
                ProtocolStep(titleKey: "protocol_1_step_4_title", contentKey: "protocol_1_step_4_content"),
            ]
        ),
        Protocol(
            titleKey: "protocol_2_title",
            descriptionKey: "protocol_2_description",
            icon: "moon.stars.fill",
            color: .indigo,
            steps: [
                ProtocolStep(titleKey: "protocol_2_step_1_title", contentKey: "protocol_2_step_1_content"),
                ProtocolStep(titleKey: "protocol_2_step_2_title", contentKey: "protocol_2_step_2_content"),
                ProtocolStep(titleKey: "protocol_2_step_3_title", contentKey: "protocol_2_step_3_content"),
                ProtocolStep(titleKey: "protocol_2_step_4_title", contentKey: "protocol_2_step_4_content"),
            ]
        ),
        Protocol(
            titleKey: "protocol_3_title",
            descriptionKey: "protocol_3_description",
            icon: "person.3.fill",
            color: .orange,
            steps: [
                ProtocolStep(titleKey: "protocol_3_step_1_title", contentKey: "protocol_3_step_1_content"),
                ProtocolStep(titleKey: "protocol_3_step_2_title", contentKey: "protocol_3_step_2_content"),
                ProtocolStep(titleKey: "protocol_3_step_3_title", contentKey: "protocol_3_step_3_content"),
                ProtocolStep(titleKey: "protocol_3_step_4_title", contentKey: "protocol_3_step_4_content"),
            ]
        ),
    ]
}

struct ProtocolStep: Identifiable {
    let id = UUID()
    let titleKey: String
    let contentKey: String

    var title: String {
        NSLocalizedString(titleKey, comment: "")
    }

    var content: String {
        NSLocalizedString(contentKey, comment: "")
    }
}
