//
//  AIHelperView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI
import Observation

struct AIHelperView: View {
    @State private var aiService = AIService()
    @State private var inputText = ""
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Lista de mensajes
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(aiService.messages) { msg in
                            MessageBubble(message: msg)
                        }

                        if aiService.isTyping {
                            HStack {
                                TypingIndicator()
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                .onChange(of: aiService.messages) {
                    if let last = aiService.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Input area
            HStack(spacing: 12) {
                TextField("Escribe aquí...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                    .disabled(aiService.isTyping)

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(inputText.isEmpty || aiService.isTyping ? .gray : .blue)
                }
                .disabled(inputText.isEmpty || aiService.isTyping)
            }
            .padding()
            .background(.bar)
        }
        .navigationTitle("Asistente Anstop")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack(spacing: 12) {
                    Button("Limpiar conversación") {
                        clearConversation()
                    }
                    .padding(.horizontal, 40)
                    .buttonStyle(SecondaryButtonStyle(color: .orange))

                    Button("Cerrar") {
                        dismiss()
                    }
                    .padding(.horizontal, 40)
                    .buttonStyle(SecondaryButtonStyle(color: .orange))
                }
            }
        }
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        inputText = ""
        isFocused = false

        Task {
            await aiService.sendMessage(text)
        }
    }
    
    private func clearConversation() {
        aiService.isTyping = false
        aiService.messages.removeAll()
        HapticManager.shared.triggerSelection()
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer() }

            Text(message.content)
                .padding(12)
                .background(message.isUser ? .blue : Color(uiColor: .secondarySystemBackground))
                .foregroundStyle(message.isUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)

            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var showDot1 = false
    @State private var showDot2 = false
    @State private var showDot3 = false

    var body: some View {
        HStack(spacing: 4) {
            Circle().frame(width: 6, height: 6).opacity(showDot1 ? 1 : 0.3)
            Circle().frame(width: 6, height: 6).opacity(showDot2 ? 1 : 0.3)
            Circle().frame(width: 6, height: 6).opacity(showDot3 ? 1 : 0.3)
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever()) { showDot1 = true }
            withAnimation(.easeInOut(duration: 0.5).repeatForever().delay(0.2)) { showDot2 = true }
            withAnimation(.easeInOut(duration: 0.5).repeatForever().delay(0.4)) { showDot3 = true }
        }
    }
}

#Preview {
    NavigationStack {
        AIHelperView()
    }
}
