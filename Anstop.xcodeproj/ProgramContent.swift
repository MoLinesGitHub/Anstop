// ProgramContent.swift
import Foundation

struct ProgramDayContent {
    let day: Int
    let objectives: [String]
    let tip: String
}

enum ProgramContent {
    static func content(for day: Int) -> ProgramDayContent {
        let dayNumber = max(1, min(day, 30))
        switch dayNumber % 5 {
        case 1: return contentForCaseOne(day: dayNumber)
        case 2: return contentForCaseTwo(day: dayNumber)
        case 3: return contentForCaseThree(day: dayNumber)
        case 4: return contentForCaseFour(day: dayNumber)
        default: return contentForDefault(day: dayNumber)
        }
    }

    private static func contentForCaseOne(day: Int) -> ProgramDayContent {
        ProgramDayContent(
            day: day,
            objectives: [
                "Respiración 4-7-8 (4 repeticiones)",
                "Escribe 3 pensamientos y reevalúalos",
                "Camina 10 minutos al aire libre"
            ],
            tip: "Tip: Si notas tensión, prueba el ejercicio de grounding 5-4-3-2-1."
        )
    }

    private static func contentForCaseTwo(day: Int) -> ProgramDayContent {
        ProgramDayContent(
            day: day,
            objectives: [
                "Diario: 5 minutos de escritura libre",
                "Respiración 4-4 (5 minutos)",
                "Agradecimientos: anota 2 cosas positivas"
            ],
            tip: "Tip: Una pausa breve y consciente puede cambiar tu estado."
        )
    }

    private static func contentForCaseThree(day: Int) -> ProgramDayContent {
        ProgramDayContent(
            day: day,
            objectives: [
                "Mindfulness: observar 3 sonidos",
                "Escaneo corporal (5 minutos)",
                "Planifica una acción amable contigo mismo"
            ],
            tip: "Tip: El cuerpo es tu ancla. Respira y vuelve al presente."
        )
    }

    private static func contentForCaseFour(day: Int) -> ProgramDayContent {
        ProgramDayContent(
            day: day,
            objectives: [
                "Reestructuración cognitiva: 1 situación",
                "Respiración discreta en contexto real",
                "Contacta a un amigo o familiar"
            ],
            tip: "Tip: Hablarlo en voz alta puede aliviar la carga."
        )
    }

    private static func contentForDefault(day: Int) -> ProgramDayContent {
        ProgramDayContent(
            day: day,
            objectives: [
                "Grounding 5-4-3-2-1",
                "Paseo consciente (10 minutos)",
                "Diario: 3 líneas sobre cómo te sientes"
            ],
            tip: "Tip: Celebra los pequeños avances, suman mucho."
        )
    }
}
