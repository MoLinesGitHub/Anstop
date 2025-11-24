// AIService.swift
import Foundation
import Observation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

@MainActor
@Observable
final class AIService {
    var messages: [ChatMessage] = []
    var isTyping: Bool = false

    func sendMessage(_ text: String) async {
        messages.append(ChatMessage(content: text, isUser: true))
        isTyping = true
        try? await Task.sleep(nanoseconds: 800_000_000)
        messages.append(ChatMessage(content: "Gracias por compartir. Estoy aquí para ayudarte.", isUser: false))
        isTyping = false
    }
}

