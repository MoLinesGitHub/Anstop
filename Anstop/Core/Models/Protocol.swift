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
    let title: String
    let description: String
    let icon: String
    let color: Color
    let steps: [ProtocolStep]

    static let all: [Protocol] = [
        Protocol(
            title: "Reestructuración Cognitiva",
            description: "Cuestiona tus pensamientos negativos automáticos.",
            icon: "brain.head.profile",
            color: .purple,
            steps: [
                ProtocolStep(
                    title: "Identifica el pensamiento",
                    content: "¿Qué estás pensando exactamente ahora? Escríbelo mentalmente."),
                ProtocolStep(
                    title: "Analiza la evidencia",
                    content: "¿Qué pruebas reales tienes de que esto sea 100% cierto?"),
                ProtocolStep(
                    title: "Busca alternativas",
                    content: "¿Hay otra forma de ver esta situación? ¿Qué le dirías a un amigo?"),
                ProtocolStep(
                    title: "Reevalúa",
                    content: "¿Cómo te sientes ahora respecto a ese pensamiento inicial?"),
            ]
        ),
        Protocol(
            title: "Ansiedad Nocturna",
            description: "Técnicas para calmar la mente antes de dormir.",
            icon: "moon.stars.fill",
            color: .indigo,
            steps: [
                ProtocolStep(
                    title: "Desconexión",
                    content:
                        "Deja el móvil y cualquier pantalla. La luz azul interfiere con tu sueño."),
                ProtocolStep(
                    title: "Descarga mental",
                    content:
                        "Si te preocupan las tareas de mañana, anótalas en un papel y olvídalas por hoy."
                ),
                ProtocolStep(
                    title: "Respiración 4-7-8",
                    content: "Inhala en 4, retén en 7, exhala en 8. Repite 4 veces."),
                ProtocolStep(
                    title: "Escaneo corporal",
                    content: "Relaja tus músculos desde los pies hasta la cabeza, poco a poco."),
            ]
        ),
        Protocol(
            title: "Pánico Social",
            description: "Gestión de la ansiedad en situaciones sociales.",
            icon: "person.3.fill",
            color: .orange,
            steps: [
                ProtocolStep(
                    title: "Anclaje",
                    content: "Siente tus pies firmes en el suelo. Estás aquí y ahora."),
                ProtocolStep(
                    title: "Foco externo",
                    content:
                        "Deja de mirar hacia adentro. Observa los colores y objetos de la habitación."
                ),
                ProtocolStep(
                    title: "Respiración discreta",
                    content: "Respira lento y profundo por la nariz. Nadie lo notará."),
                ProtocolStep(
                    title: "Pequeños pasos",
                    content:
                        "No necesitas ser el centro de atención. Solo estar presente es suficiente."
                )
            ]
        )
    ]
}

struct ProtocolStep: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}
