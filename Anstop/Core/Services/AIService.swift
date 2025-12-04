//
//  AIService.swift
//  Anstop
//
//  Created on 2025-11-24.
//  Servicio de IA para asistencia en bienestar y manejo del estrés
//

import Foundation
import Observation

// MARK: - Chat Message Model

struct ChatMessage: Identifiable, Equatable, Sendable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date = Date()
}

// MARK: - AI Response Type

enum AIResponseCategory: Sendable {
    case breathing
    case grounding
    case sleep
    case anxiety
    case negativeThoughts
    case general
    case greeting
    case emergency
}

// MARK: - AI Service

@MainActor
@Observable
final class AIService {
    var messages: [ChatMessage] = []
    var isTyping: Bool = false

    // MARK: - Respuestas predefinidas por categoría

    private let responses: [AIResponseCategory: [String]] = [
        .greeting: [
            "¡Hola! 👋 Estoy aquí para ayudarte. ¿Cómo te sientes en este momento?",
            "Bienvenido/a. Me alegra que estés aquí. ¿En qué puedo ayudarte hoy?",
            "Hola, soy tu asistente de bienestar. Estoy aquí para escucharte. 💜"
        ],
        .breathing: [
            """
            La respiración es una herramienta poderosa para calmar tu sistema nervioso. 🌬️

            Te recomiendo probar la técnica 4-7-8:
            • Inhala por 4 segundos
            • Mantén por 7 segundos
            • Exhala por 8 segundos

            Repite 4 veces. ¿Quieres que te guíe paso a paso?
            """,
            """
            Cuando sientas ansiedad, tu respiración puede ser tu ancla. 🧘‍♀️

            Intenta la respiración cuadrada:
            • Inhala 4 segundos
            • Mantén 4 segundos
            • Exhala 4 segundos
            • Mantén 4 segundos

            Puedes acceder a ejercicios guiados en la sección de Respiración.
            """,
            """
            La respiración diafragmática activa tu sistema parasimpático, ayudándote
            a relajarte naturalmente. 💙

            Coloca una mano en tu pecho y otra en tu abdomen. Al inhalar, solo debe
            moverse la mano del abdomen.
            """
        ],
        .grounding: [
            """
            El grounding te ayuda a reconectarte con el presente cuando te sientes
            abrumado/a. 🌿

            Prueba la técnica 5-4-3-2-1:
            • 5 cosas que puedes VER
            • 4 cosas que puedes TOCAR
            • 3 cosas que puedes OÍR
            • 2 cosas que puedes OLER
            • 1 cosa que puedes SABOREAR

            ¿Lo intentamos juntos?
            """,
            """
            Cuando los pensamientos se sienten abrumadores, anclarte en tus sentidos
            puede ayudar. 🍃

            Toca algo frío o caliente, siente la textura de la ropa que llevas, o
            presiona tus pies contra el suelo. Estas sensaciones te traen al aquí y ahora.
            """,
            """
            El grounding es como un ancla para tu mente. ⚓

            Un ejercicio simple: nombra 3 colores que veas a tu alrededor. Esto
            interrumpe el ciclo de pensamientos ansiosos y te centra en el presente.
            """
        ],
        .sleep: [
            """
            Los problemas de sueño son muy comunes cuando hay estrés. 🌙

            Algunos consejos:
            • Evita pantallas 1 hora antes de dormir
            • Mantén un horario regular
            • Prueba una meditación guiada
            • La respiración 4-7-8 es especialmente efectiva

            ¿Quieres que te sugiera una rutina nocturna?
            """,
            """
            El sueño y la ansiedad están muy conectados. 😴

            Intenta el 'body scan':
            Recostado/a, recorre mentalmente tu cuerpo desde los pies hasta la cabeza,
            relajando cada zona conscientemente.

            También tenemos audios relajantes en la app que pueden ayudarte.
            """,
            """
            Cuando no puedes dormir, luchar contra el insomnio puede empeorarlo. 🌟

            Intenta:
            • Levantarte si llevas 20+ minutos despierto/a
            • Hacer algo tranquilo (sin pantallas)
            • Volver cuando sientas sueño

            La técnica de 'paradójica' también ayuda: intenta mantenerte despierto/a
            en lugar de dormirte.
            """
        ],
        .anxiety: [
            """
            Siento que estás pasando por un momento difícil. 💜

            La ansiedad puede ser abrumadora, pero recuerda: es temporal y tú eres
            más fuerte de lo que crees.

            Ahora mismo, ¿puedes tomar 3 respiraciones lentas y profundas conmigo?

            Inhala... y exhala... 🌬️
            """,
            """
            Es completamente válido sentir ansiedad. No estás solo/a en esto. 🤗

            Algo que puede ayudar ahora:
            1. Pon tus pies firmemente en el suelo
            2. Siente la solidez debajo de ti
            3. Recuerda: este momento pasará

            ¿Quieres hablar sobre qué te está preocupando?
            """,
            """
            La ansiedad a veces nos hace sentir fuera de control. 🌊

            Pero tu cuerpo tiene la capacidad de calmarse. Activa tu sistema de relajación:
            • Enfría tus muñecas con agua fría
            • Haz un suspiro largo y audible
            • Tensiona todos tus músculos por 5 segundos y suelta

            Estoy aquí contigo. 💙
            """
        ],
        .negativeThoughts: [
            """
            Los pensamientos negativos pueden sentirse muy reales, pero no siempre
            son verdad. 🧠

            Prueba esto:
            1. Identifica el pensamiento
            2. Pregúntate: ¿Es un hecho o una interpretación?
            3. ¿Qué le dirías a un amigo que pensara esto?

            Ser amable contigo mismo/a es poderoso. 💜
            """,
            """
            Cuando la mente se llena de negatividad, podemos sentirnos atrapados. 🌧️

            Una técnica útil:
            Imagina que tus pensamientos son nubes pasando por el cielo. Los observas,
            pero no tienes que aferrarte a ellos.

            Tú no eres tus pensamientos. 🌈
            """,
            """
            Los pensamientos negativos suelen venir en espiral. 🌀

            Para interrumpir el ciclo:
            • Di en voz alta: 'Esto es un pensamiento, no un hecho'
            • Cambia tu postura física (ponte de pie, estírate)
            • Haz algo con las manos (agua fría, apretar algo)

            Pequeñas acciones pueden tener un gran impacto. 💪
            """
        ],
        .emergency: [
            """
            ⚠️ Si estás en crisis o tienes pensamientos de hacerte daño, por favor
            contacta ayuda profesional inmediatamente:

            🇪🇸 Teléfono de la Esperanza: 717 003 717
            🇲🇽 SAPTEL: 55 5259-8121
            🌍 Emergencias: 112

            No tienes que pasar por esto solo/a. Hay personas que quieren ayudarte. 💜
            """,
            """
            Me preocupa lo que describes. Tu bienestar es lo más importante. 💙

            Por favor, considera hablar con alguien de confianza o un profesional.

            Líneas de ayuda 24/7:
            • 717 003 717 (España)
            • 024 (España - Línea atención conducta suicida)

            Mereces apoyo y ayuda profesional. 🤗
            """
        ],
        .general: [
            """
            Gracias por compartir eso conmigo. 💜

            Recuerda que cuidar de tu bienestar mental es tan importante como cuidar
            tu salud física. Estoy aquí para acompañarte en este proceso.

            ¿Hay algo específico en lo que te gustaría trabajar hoy?
            """,
            """
            Te escucho. 🤗

            Cada paso que das hacia tu bienestar cuenta, incluso los más pequeños.
            El hecho de que estés aquí ya es un paso importante.

            ¿Te gustaría explorar alguna técnica de relajación?
            """,
            """
            Aprecio que confíes en mí. 💙

            Recuerda que está bien no estar bien todo el tiempo. Lo importante es
            que busques recursos y apoyo cuando lo necesites.

            ¿En qué puedo ayudarte hoy?
            """,
            """
            Es valioso que te tomes este momento para ti. 🌟

            La autocompasión es clave: trátate con la misma amabilidad que tratarías
            a un amigo querido.

            ¿Quieres que exploremos juntos alguna herramienta de la app?
            """
        ]
    ]

    // MARK: - Keywords para detectar categoría

    private let keywords: [(category: AIResponseCategory, words: [String])] = [
        (.emergency, ["suicid", "morir", "acabar", "no quiero vivir", "hacerme daño", "matarme", "crisis"]),
        (.breathing, ["respirar", "respiración", "respir", "inhalar", "exhalar", "aire", "4-7-8", "diafragma"]),
        (.grounding, ["grounding", "anclar", "5-4-3-2-1", "sentidos", "presente", "aquí y ahora", "desconectado"]),
        (.sleep, ["dormir", "sueño", "insomnio", "noche", "despertar", "descansar", "cama"]),
        (.anxiety, ["ansie", "angustia", "pánico", "nervios", "preocup", "miedo", "agobio", "estres", "calm"]),
        (.negativeThoughts, ["pensamiento", "negativ", "mente", "cabeza", "rumia", "obsesi", "no puedo parar"]),
        (.greeting, ["hola", "buenos", "hey", "saludos", "qué tal", "cómo estás"])
    ]

    // MARK: - Public Methods

    func sendMessage(_ text: String) async {
        // Añadir mensaje del usuario
        let userMessage = ChatMessage(content: text, isUser: true)
        messages.append(userMessage)

        // Simular "escribiendo..."
        isTyping = true

        // Delay para simular procesamiento (más natural)
        let thinkingTime = UInt64.random(in: 800_000_000...1_500_000_000)
        try? await Task.sleep(nanoseconds: thinkingTime)

        // Generar respuesta
        let response = generateResponse(for: text)

        // Añadir respuesta de la IA
        let aiMessage = ChatMessage(content: response, isUser: false)
        messages.append(aiMessage)

        isTyping = false
    }

    // MARK: - Private Methods

    private func generateResponse(for input: String) -> String {
        let lowercased = input.lowercased()

        // Detectar categoría basada en keywords
        var detectedCategory: AIResponseCategory = .general
        var highestMatch = 0

        for (category, words) in keywords {
            let matches = words.filter { lowercased.contains($0) }.count
            if matches > highestMatch {
                highestMatch = matches
                detectedCategory = category
            }
        }

        // Seleccionar respuesta aleatoria de la categoría
        if let categoryResponses = responses[detectedCategory], !categoryResponses.isEmpty {
            return categoryResponses.randomElement() ?? responses[.general]!.randomElement()!
        }

        return responses[.general]!.randomElement()!
    }
}
