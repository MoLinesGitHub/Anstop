// ProgramContent.swift
import Foundation

struct ProgramDayContent {
    let day: Int
    let objectives: [String]
    let tip: String
}

enum ProgramContent {
    static func content(for day: Int) -> ProgramDayContent {
        let d = max(1, min(day, 30))
        switch d % 5 {
        case 1:
            return ProgramDayContent(
                day: d,
                objectives: [
                    "Respiración 4-7-8 (4 repeticiones)",
                    "Escribe 3 pensamientos y reevalúalos",
                    "Camina 10 minutos al aire libre",
                ],
                tip: "Tip: Si notas tensión, prueba el ejercicio de grounding 5-4-3-2-1."
            )
        case 2:
            return ProgramDayContent(
                day: d,
                objectives: [
                    "Diario: 5 minutos de escritura libre",
                    "Respiración 4-4 (5 minutos)",
                    "Agradecimientos: anota 2 cosas positivas",
                ],
                tip: "Tip: Una pausa breve y consciente puede cambiar tu estado."
            )
        case 3:
            return ProgramDayContent(
                day: d,
                objectives: [
                    "Mindfulness: observar 3 sonidos",
                    "Escaneo corporal (5 minutos)",
                    "Planifica una acción amable contigo mismo",
                ],
                tip: "Tip: El cuerpo es tu ancla. Respira y vuelve al presente."
            )
        case 4:
            return ProgramDayContent(
                day: d,
                objectives: [
                    "Reestructuración cognitiva: 1 situación",
                    "Respiración discreta en contexto real",
                    "Contacta a un amigo o familiar",
                ],
                tip: "Tip: Hablarlo en voz alta puede aliviar la carga."
            )
        default:
            return ProgramDayContent(
                day: d,
                objectives: [
                    "Grounding 5-4-3-2-1",
                    "Paseo consciente (10 minutos)",
                    "Diario: 3 líneas sobre cómo te sientes",
                ],
                tip: "Tip: Celebra los pequeños avances, suman mucho."
            )
        }
    }
}
