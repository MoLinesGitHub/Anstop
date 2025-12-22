//
//  DailyExercise.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import Foundation
import SwiftUI

struct DailyExercise: Identifiable {
    let id = UUID()
    let day: Int
    let title: String
    let description: String
    let exerciseType: ExerciseType
    let content: String

    enum ExerciseType {
        case breathing
        case grounding
        case reflection
        case journaling
        case mindfulness
    }

    static let all: [DailyExercise] = [
        // Semana 1: Fundamentos
        DailyExercise(
            day: 1, title: "Respiración Consciente",
            description: "Aprende la base de todo: respirar correctamente.",
            exerciseType: .breathing,
            content:
            "Durante 5 minutos, concéntrate únicamente en tu respiración. Inhala en 4, retén en 4, exhala en 4. No juzgues tu mente, solo observa. Esta es tu ancla."
        ),
        DailyExercise(
            day: 2, title: "Identificar Sensaciones",
            description: "Reconoce cómo se siente la ansiedad en tu cuerpo.",
            exerciseType: .reflection,
            content:
            "Escribe 3 sensaciones físicas que sientes cuando estás ansioso. Por ejemplo: presión en el pecho, manos frías, estómago tenso. Reconocerlas es el primer paso para gestionarlas."
        ),
        DailyExercise(
            day: 3, title: "Grounding Básico", description: "Conéctate con el presente.",
            exerciseType: .grounding,
            content:
            "Practica 5-4-3-2-1: 5 cosas que ves, 4 que tocas, 3 que oyes, 2 que hueles, 1 que saboreas. Hazlo lentamente. Este ejercicio te devuelve al ahora."
        ),
        DailyExercise(
            day: 4, title: "Diario de Gratitud", description: "Cambia el foco de tu mente.",
            exerciseType: .journaling,
            content:
            "Escribe 3 cosas por las que estás agradecido hoy. Pueden ser pequeñas: el café de la mañana, una conversación amable, el sol. Tu cerebro aprenderá a buscar lo positivo."
        ),
        DailyExercise(
            day: 5, title: "Escaneo Corporal", description: "Relaja tu cuerpo paso a paso.",
            exerciseType: .mindfulness,
            content:
            "Acuéstate. Tensa y relaja cada parte del cuerpo, desde los pies hasta la cabeza. Dedica 1 minuto a cada zona. Esto libera la tensión acumulada."
        ),
        DailyExercise(
            day: 6, title: "Pensamiento Automático",
            description: "Identifica tus patrones mentales.", exerciseType: .reflection,
            content:
            "Cuando sientas ansiedad, anota el pensamiento exacto que tuviste antes. Por ejemplo: 'Voy a fracasar'. Solo identificarlo, sin juzgar. Esto es autoconocimiento."
        ),
        DailyExercise(
            day: 7, title: "Revisión de la Semana", description: "Reflexiona sobre tu progreso.",
            exerciseType: .journaling,
            content:
            "¿Qué aprendiste de ti mismo esta semana? ¿Qué ejercicio te ayudó más? No hay respuestas incorrectas. Solo honestidad."
        ),

        // Semana 2: Cuestionamiento
        DailyExercise(
            day: 8, title: "Cuestiona tus Miedos", description: "¿Son reales o imaginarios?",
            exerciseType: .reflection,
            content:
            "Elige un miedo recurrente. Pregunta: ¿Qué evidencia real tengo de que esto pasará? ¿Cuántas veces ha pasado antes? Separa hechos de suposiciones."
        ),
        DailyExercise(
            day: 9, title: "Respiración 4-7-8", description: "Una técnica más avanzada.",
            exerciseType: .breathing,
            content:
            "Inhala en 4, retén en 7, exhala en 8. Repite 4 veces. Esta respiración activa tu sistema nervioso parasimpático, calmando tu cuerpo."
        ),
        DailyExercise(
            day: 10, title: "Escribe a tu Yo Ansioso",
            description: "Habla con tu ansiedad como si fuera alguien más.",
            exerciseType: .journaling,
            content:
            "Escribe una carta a tu ansiedad. Pregúntale qué intenta protegerte. A veces, el miedo solo quiere cuidarte, pero exagera."
        ),
        DailyExercise(
            day: 11, title: "Mindfulness en Movimiento", description: "Camina con atención plena.",
            exerciseType: .mindfulness,
            content:
            "Sal a caminar 10 minutos sin móvil. Siente cada paso. Observa los sonidos, el viento. No pienses en tareas. Solo camina."
        ),
        DailyExercise(
            day: 12, title: "Reformular Pensamientos", description: "Cambia la narrativa.",
            exerciseType: .reflection,
            content:
            "Toma un pensamiento negativo de ayer. Reescríbelo de forma neutral o positiva. Ejemplo: 'Soy un fracaso' → 'Estoy aprendiendo y mejorando'."
        ),
        DailyExercise(
            day: 13, title: "Diario de Logros", description: "Reconoce tus victorias.",
            exerciseType: .journaling,
            content:
            "Escribelogros de esta semana, por pequeños que sean. Levantarte, ducharte, hacer ejercicio. Todo cuenta. Tu cerebro necesita verlos."
        ),
        DailyExercise(
            day: 14, title: "Revisión de Progreso", description: "Evalúa tu evolución.",
            exerciseType: .reflection,
            content:
            "Compara tu ansiedad de hoy con la del Día 1. ¿Notas algún cambio? ¿Qué técnica usas más? Celebra tu esfuerzo."
        ),

        // Semana 3: Profundización
        DailyExercise(
            day: 15, title: "Meditación Guiada", description: "Silencia la mente.",
            exerciseType: .mindfulness,
            content:
            "Dedica 10 minutos a meditar. Siéntate cómodo, cierra los ojos, respira. Cuando un pensamiento llegue, déjalo pasar como una nube. No lo sigas."
        ),
        DailyExercise(
            day: 16, title: "Visualización Positiva",
            description: "Entrena tu mente para el éxito.", exerciseType: .reflection,
            content:
            "Imagina una situación que te da ansiedad, pero visualízate manejándola con calma. Repite esto 3 veces. Tu cerebro no diferencia entre práctica real e imaginada."
        ),
        DailyExercise(
            day: 17, title: "Grounding con Objetos", description: "Usa el tacto como ancla.",
            exerciseType: .grounding,
            content:
            "Lleva un objeto pequeño contigo (piedra, moneda). Cuando sientas ansiedad, tócalo. Siente su textura, temperatura, peso. Esto te devuelve al presente."
        ),
        DailyExercise(
            day: 18, title: "Carta de Autocompasión", description: "Sé amable contigo mismo.",
            exerciseType: .journaling,
            content:
            "Escribe una carta a ti mismo como si fueras tu mejor amigo. ¿Qué le dirías? Usa ese mismo tono contigo siempre."
        ),
        DailyExercise(
            day: 19, title: "Respiración Alterna", description: "Equilibra tu sistema nervioso.",
            exerciseType: .breathing,
            content:
            "Tapa tu fosa nasal derecha, inhala por la izquierda. Tapa la izquierda, exhala por la derecha. Alterna 5 minutos. Esto balancea tu energía."
        ),
        DailyExercise(
            day: 20, title: "Identifica Triggers", description: "Conoce qué dispara tu ansiedad.",
            exerciseType: .reflection,
            content:
            "Anota 3 situaciones o pensamientos que activan tu ansiedad. Reconocer tus triggers te da control sobre ellos."
        ),
        DailyExercise(
            day: 21, title: "Revisión de Medio Camino", description: "Has llegado lejos.",
            exerciseType: .journaling,
            content:
            "¿Cómo te sientes hoy vs Día 1? ¿Qué has descubierto de ti? Estás a mitad del camino. Sigue adelante."
        ),

        // Semana 4: Integración
        DailyExercise(
            day: 22, title: "Mindfulness al Comer", description: "Lleva atención a lo cotidiano.",
            exerciseType: .mindfulness,
            content:
            "Come una comida en silencio, sin pantallas. Saborea cada bocado. Esto entrena tu mente para estar presente en todo."
        ),
        DailyExercise(
            day: 23, title: "Plan de Acción", description: "Prepárate para el futuro.",
            exerciseType: .reflection,
            content:
            "Escribe un mini plan de acción para cuando sientas ansiedad: 1) Respirar, 2) Grounding, 3) Llamar a alguien. Tener un plan reduce el miedo."
        ),
        DailyExercise(
            day: 24, title: "Gratitud Profunda", description: "Agradece lo invisible.",
            exerciseType: .journaling,
            content:
            "Escribe sobre una persona que te ayudó sin saberlo. Tal vez con una sonrisa o un gesto. Reconecta con la bondad humana."
        ),
        DailyExercise(
            day: 25, title: "Respiración Consciente Avanzada",
            description: "Domina tu respiración.", exerciseType: .breathing,
            content:
            "Combina 4-7-8 con visualización: al inhalar, imagina luz entrando. Al exhalar, imagina estrés saliendo. Hazlo 10 minutos."
        ),
        DailyExercise(
            day: 26, title: "Perdónate", description: "Suelta el pasado.",
            exerciseType: .reflection,
            content:
            "Piensa en algo que te lamentes. Escribe: 'Me perdono por...'. Repetir esto libera la culpa que alimenta la ansiedad."
        ),
        DailyExercise(
            day: 27, title: "Celebra tus Fortalezas", description: "Reconoce tu poder.",
            exerciseType: .journaling,
            content:
            "Escribe 5 cualidades tuyas que te ayudan a superar la ansiedad. Resiliencia, valentía, paciencia. Mírate con admiración."
        ),
        DailyExercise(
            day: 28, title: "Última Semana - Reflexión", description: "Casi terminas.",
            exerciseType: .reflection,
            content:
            "¿Qué ejercicio fue el más difícil? ¿Cuál el más útil? ¿Cómo seguirás practicando? La transformación es continua."
        ),

        // Últimos días: Cierre
        DailyExercise(
            day: 29, title: "Carta al Futuro", description: "Inspírate a ti mismo.",
            exerciseType: .journaling,
            content:
            "Escribe una carta a tu yo de dentro de 6 meses. Cuéntale cómo te sientes ahora y qué esperas haber logrado. Sella esta carta mentalmente."
        ),
        DailyExercise(
            day: 30, title: "Celebración Final", description: "Lo lograste.",
            exerciseType: .reflection,
            content:
            "Has completado 30 días. Reconoce tu esfuerzo. La ansiedad no desaparece, pero ahora tienes herramientas. Eres más fuerte de lo que crees. Continúa."
        ),
    ]
}
