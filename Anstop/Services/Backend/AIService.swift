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
    let timestamp: Date = .init()
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

    private let responseKeys: [AIResponseCategory: [String]] = [
        .greeting: ["ai_response_greeting_1", "ai_response_greeting_2", "ai_response_greeting_3"],
        .breathing: ["ai_response_breathing_1", "ai_response_breathing_2", "ai_response_breathing_3"],
        .grounding: ["ai_response_grounding_1", "ai_response_grounding_2", "ai_response_grounding_3"],
        .sleep: ["ai_response_sleep_1", "ai_response_sleep_2", "ai_response_sleep_3"],
        .anxiety: ["ai_response_anxiety_1", "ai_response_anxiety_2", "ai_response_anxiety_3"],
        .negativeThoughts: ["ai_response_negative_thoughts_1", "ai_response_negative_thoughts_2", "ai_response_negative_thoughts_3"],
        .emergency: ["ai_response_emergency_1", "ai_response_emergency_2"],
        .general: ["ai_response_general_1", "ai_response_general_2", "ai_response_general_3", "ai_response_general_4"],
    ]

    private func localizedResponses(for category: AIResponseCategory) -> [String] {
        responseKeys[category, default: []].map { NSLocalizedString($0, comment: "") }
    }

    // MARK: - Keywords para detectar categoría

    private let keywords: [(category: AIResponseCategory, words: [String])] = [
        (.emergency, ["suicid", "morir", "acabar", "no quiero vivir", "hacerme daño", "matarme", "crisis"]),
        (.breathing, ["respirar", "respiración", "respir", "inhalar", "exhalar", "aire", "4-7-8", "diafragma"]),
        (.grounding, ["grounding", "anclar", "5-4-3-2-1", "sentidos", "presente", "aquí y ahora", "desconectado"]),
        (.sleep, ["dormir", "sueño", "insomnio", "noche", "despertar", "descansar", "cama"]),
        (.anxiety, ["ansie", "angustia", "pánico", "nervios", "preocup", "miedo", "agobio", "estres", "calm"]),
        (.negativeThoughts, ["pensamiento", "negativ", "mente", "cabeza", "rumia", "obsesi", "no puedo parar"]),
        (.greeting, ["hola", "buenos", "hey", "saludos", "qué tal", "cómo estás"]),
    ]

    // MARK: - Public Methods

    func sendMessage(_ text: String) async {
        // Añadir mensaje del usuario
        let userMessage = ChatMessage(content: text, isUser: true)
        messages.append(userMessage)

        // Simular "escribiendo..."
        isTyping = true

        // Delay para simular procesamiento (más natural)
        let thinkingTime = UInt64.random(in: 800_000_000 ... 1_500_000_000)
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
        let categoryResponses = localizedResponses(for: detectedCategory)
        if !categoryResponses.isEmpty {
            return categoryResponses.randomElement()
                ?? localizedResponses(for: .general).randomElement()
                ?? ""
        }

        return localizedResponses(for: .general).randomElement() ?? ""
    }
}
