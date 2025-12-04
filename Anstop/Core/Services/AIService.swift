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
            "La respiración es una herramienta poderosa para calmar tu sistema nervioso. 🌬️\n\nTe recomiendo probar la técnica 4-7-8:\n• Inhala por 4 segundos\n• Mantén por 7 segundos\n• Exhala por 8 segundos\n\nRepite 4 veces. ¿Quieres que te guíe paso a paso?",
            "Cuando sientas ansiedad, tu respiración puede ser tu ancla. 🧘‍♀️\n\nIntenta la respiración cuadrada:\n• Inhala 4 segundos\n• Mantén 4 segundos\n• Exhala 4 segundos\n• Mantén 4 segundos\n\nPuedes acceder a ejercicios guiados en la sección de Respiración.",
            "La respiración diafragmática activa tu sistema parasimpático, ayudándote a relajarte naturalmente. 💙\n\nColoca una mano en tu pecho y otra en tu abdomen. Al inhalar, solo debe moverse la mano del abdomen."
        ],
        .grounding: [
            "El grounding te ayuda a reconectarte con el presente cuando te sientes abrumado/a. 🌿\n\nPrueba la técnica 5-4-3-2-1:\n• 5 cosas que puedes VER\n• 4 cosas que puedes TOCAR\n• 3 cosas que puedes OÍR\n• 2 cosas que puedes OLER\n• 1 cosa que puedes SABOREAR\n\n¿Lo intentamos juntos?",
            "Cuando los pensamientos se sienten abrumadores, anclarte en tus sentidos puede ayudar. 🍃\n\nToca algo frío o caliente, siente la textura de la ropa que llevas, o presiona tus pies contra el suelo. Estas sensaciones te traen al aquí y ahora.",
            "El grounding es como un ancla para tu mente. ⚓\n\nUn ejercicio simple: nombra 3 colores que veas a tu alrededor. Esto interrumpe el ciclo de pensamientos ansiosos y te centra en el presente."
        ],
        .sleep: [
            "Los problemas de sueño son muy comunes cuando hay estrés. 🌙\n\nAlgunos consejos:\n• Evita pantallas 1 hora antes de dormir\n• Mantén un horario regular\n• Prueba una meditación guiada\n• La respiración 4-7-8 es especialmente efectiva\n\n¿Quieres que te sugiera una rutina nocturna?",
            "El sueño y la ansiedad están muy conectados. 😴\n\nIntenta el 'body scan':\nRecostado/a, recorre mentalmente tu cuerpo desde los pies hasta la cabeza, relajando cada zona conscientemente.\n\nTambién tenemos audios relajantes en la app que pueden ayudarte.",
            "Cuando no puedes dormir, luchar contra el insomnio puede empeorarlo. 🌟\n\nIntenta:\n• Levantarte si llevas 20+ minutos despierto/a\n• Hacer algo tranquilo (sin pantallas)\n• Volver cuando sientas sueño\n\nLa técnica de 'paradójica' también ayuda: intenta mantenerte despierto/a en lugar de dormirte."
        ],
        .anxiety: [
            "Siento que estás pasando por un momento difícil. 💜\n\nLa ansiedad puede ser abrumadora, pero recuerda: es temporal y tú eres más fuerte de lo que crees.\n\nAhora mismo, ¿puedes tomar 3 respiraciones lentas y profundas conmigo?\n\nInhala... y exhala... 🌬️",
            "Es completamente válido sentir ansiedad. No estás solo/a en esto. 🤗\n\nAlgo que puede ayudar ahora:\n1. Pon tus pies firmemente en el suelo\n2. Siente la solidez debajo de ti\n3. Recuerda: este momento pasará\n\n¿Quieres hablar sobre qué te está preocupando?",
            "La ansiedad a veces nos hace sentir fuera de control. 🌊\n\nPero tu cuerpo tiene la capacidad de calmarse. Activa tu sistema de relajación:\n• Enfría tus muñecas con agua fría\n• Haz un suspiro largo y audible\n• Tensiona todos tus músculos por 5 segundos y suelta\n\nEstoy aquí contigo. 💙"
        ],
        .negativeThoughts: [
            "Los pensamientos negativos pueden sentirse muy reales, pero no siempre son verdad. 🧠\n\nPrueba esto:\n1. Identifica el pensamiento\n2. Pregúntate: ¿Es un hecho o una interpretación?\n3. ¿Qué le dirías a un amigo que pensara esto?\n\nSer amable contigo mismo/a es poderoso. 💜",
            "Cuando la mente se llena de negatividad, podemos sentirnos atrapados. 🌧️\n\nUna técnica útil:\nImagina que tus pensamientos son nubes pasando por el cielo. Los observas, pero no tienes que aferrarte a ellos.\n\nTú no eres tus pensamientos. 🌈",
            "Los pensamientos negativos suelen venir en espiral. 🌀\n\nPara interrumpir el ciclo:\n• Di en voz alta: 'Esto es un pensamiento, no un hecho'\n• Cambia tu postura física (ponte de pie, estírate)\n• Haz algo con las manos (agua fría, apretar algo)\n\nPequeñas acciones pueden tener un gran impacto. 💪"
        ],
        .emergency: [
            "⚠️ Si estás en crisis o tienes pensamientos de hacerte daño, por favor contacta ayuda profesional inmediatamente:\n\n🇪🇸 Teléfono de la Esperanza: 717 003 717\n🇲🇽 SAPTEL: 55 5259-8121\n🌍 Emergencias: 112\n\nNo tienes que pasar por esto solo/a. Hay personas que quieren ayudarte. 💜",
            "Me preocupa lo que describes. Tu bienestar es lo más importante. 💙\n\nPor favor, considera hablar con alguien de confianza o un profesional.\n\nLíneas de ayuda 24/7:\n• 717 003 717 (España)\n• 024 (España - Línea atención conducta suicida)\n\nMereces apoyo y ayuda profesional. 🤗"
        ],
        .general: [
            "Gracias por compartir eso conmigo. 💜\n\nRecuerda que cuidar de tu bienestar mental es tan importante como cuidar tu salud física. Estoy aquí para acompañarte en este proceso.\n\n¿Hay algo específico en lo que te gustaría trabajar hoy?",
            "Te escucho. 🤗\n\nCada paso que das hacia tu bienestar cuenta, incluso los más pequeños. El hecho de que estés aquí ya es un paso importante.\n\n¿Te gustaría explorar alguna técnica de relajación?",
            "Aprecio que confíes en mí. 💙\n\nRecuerda que está bien no estar bien todo el tiempo. Lo importante es que busques recursos y apoyo cuando lo necesites.\n\n¿En qué puedo ayudarte hoy?",
            "Es valioso que te tomes este momento para ti. 🌟\n\nLa autocompasión es clave: trátate con la misma amabilidad que tratarías a un amigo querido.\n\n¿Quieres que exploremos juntos alguna herramienta de la app?"
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
