// AIService.swift
import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

@MainActor
final class AIService {
    private(set) var messages: [ChatMessage] = []
    private(set) var isTyping: Bool = false

    func sendMessage(_ text: String) async {
        messages.append(ChatMessage(content: text, isUser: true))
        isTyping = true
        try? await Task.sleep(nanoseconds: 800_000_000)
        messages.append(ChatMessage(content: "Gracias por compartir. Estoy aquí para ayudarte.", isUser: false))
        isTyping = false
    }
}
