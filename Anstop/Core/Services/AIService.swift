//
//  AIService.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let date: Date
}

@Observable
final class AIService {
    var messages: [ChatMessage] = []
    var isTyping = false

    init() {
        // Mensaje inicial de bienvenida
        messages.append(
            ChatMessage(
                content: "Hola. Estoy aquí para escucharte. ¿Cómo te sientes en este momento?",
                isUser: false, date: Date()))
    }

    func sendMessage(_ text: String) async {
        // 1. Añadir mensaje del usuario
        let userMsg = ChatMessage(content: text, isUser: true, date: Date())
        messages.append(userMsg)

        // 2. Simular "escribiendo"
        isTyping = true

        // Simular delay de red
        try? await Task.sleep(for: .seconds(1.5))

        // 3. Generar respuesta (Mock por ahora)
        let responseText = generateMockResponse(for: text)
        let aiMsg = ChatMessage(content: responseText, isUser: false, date: Date())

        messages.append(aiMsg)
        isTyping = false
    }

    private func generateMockResponse(for text: String) -> String {
        let lowerText = text.lowercased()

        if lowerText.contains("miedo") || lowerText.contains("pánico") {
            return
                "Es normal sentir miedo, pero recuerda que estás a salvo. Tu cuerpo solo está reaccionando a una falsa alarma. Respira profundo conmigo."
        } else if lowerText.contains("triste") || lowerText.contains("mal") {
            return
                "Lamento que te sientas así. A veces, permitirnos sentir esa tristeza es el primer paso para soltarla. ¿Quieres contarme más?"
        } else if lowerText.contains("gracias") {
            return "De nada. Estoy aquí siempre que me necesites."
        } else {
            return
                "Te entiendo. A veces es difícil ponerlo en palabras. Recuerda que este es un espacio seguro para ti. ¿Te ayudaría hacer un ejercicio de respiración?"
        }
    }
}
