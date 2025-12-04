//
//  AIHelperView.swift
//  Anstop
//
//  Created on 2025-11-24.
//  Asistente de IA especializado en bienestar y manejo del estrés
//

import SwiftUI
import Observation

// MARK: - Main View

struct AIHelperView: View {
    @State private var aiService = AIService()
    @State private var inputText = ""
    @State private var showSuggestions = true
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // Colores calmantes para la UI
    private let accentColor = Color(red: 0.6, green: 0.4, blue: 0.8) // Púrpura suave
    private let userBubbleColor = Color(red: 0.5, green: 0.7, blue: 0.9) // Azul calmante
    private let aiBubbleColor = Color(red: 0.85, green: 0.9, blue: 0.95) // Gris azulado muy suave
    
    // Sugerencias rápidas para el usuario
    private let quickSuggestions = [
        "¿Cómo puedo calmarme rápido?",
        "Técnicas de respiración",
        "No puedo dormir",
        "Siento mucha ansiedad",
        "Ejercicios de grounding",
        "Pensamientos negativos"
    ]
    
    var body: some View {
        ZStack {
            // Fondo con gradiente calmante
            backgroundView
            
            VStack(spacing: 0) {
                // Header personalizado
                headerView
                
                // Contenido principal
                if aiService.messages.isEmpty {
                    emptyStateView
                } else {
                    messagesListView
                }
                
                // Sugerencias rápidas
                if showSuggestions && aiService.messages.count < 3 {
                    suggestionsView
                }
                
                // Input area
                inputAreaView
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isFocused = false
        }
    }
    
    // MARK: - Background
    
    private var backgroundView: some View {
        ZStack {
            // Gradiente de fondo calmante
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.9, green: 0.95, blue: 0.98)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Círculos decorativos sutiles
            GeometryReader { geometry in
                Circle()
                    .fill(accentColor.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: -100, y: -50)
                
                Circle()
                    .fill(Color.cyan.opacity(0.05))
                    .frame(width: 250, height: 250)
                    .blur(radius: 50)
                    .offset(x: geometry.size.width - 100, y: geometry.size.height - 200)
            }
            .ignoresSafeArea()
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            Button {
                HapticManager.shared.triggerImpact(style: .light)
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(accentColor)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundStyle(accentColor)
                    
                    Text("Asistente Anstop")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                
                Text("Tu compañero de bienestar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                HapticManager.shared.triggerSelection()
                clearConversation()
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(aiService.messages.isEmpty ? .gray : accentColor)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
            .disabled(aiService.messages.isEmpty)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icono principal con animación
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [accentColor.opacity(0.2), accentColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [accentColor, accentColor.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .shadow(color: accentColor.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 12) {
                Text("¿Cómo te sientes hoy?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("Estoy aquí para escucharte y ayudarte\na encontrar calma en cualquier momento.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
    
    // MARK: - Messages List
    
    private var messagesListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(aiService.messages) { message in
                        MessageBubbleView(
                            message: message,
                            userColor: userBubbleColor,
                            aiColor: aiBubbleColor,
                            accentColor: accentColor
                        )
                        .id(message.id)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity
                        ))
                    }
                    
                    if aiService.isTyping {
                        AITypingIndicatorView(color: accentColor)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .padding(.bottom, 8)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: aiService.messages.count) {
                withAnimation(.easeOut(duration: 0.3)) {
                    if let last = aiService.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    // MARK: - Suggestions
    
    private var suggestionsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sugerencias")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(quickSuggestions, id: \.self) { suggestion in
                        AISuggestionChip(
                            text: suggestion,
                            color: accentColor
                        ) {
                            HapticManager.shared.triggerSelection()
                            inputText = suggestion
                            sendMessage()
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
        )
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Input Area
    
    private var inputAreaView: some View {
        HStack(spacing: 12) {
            // Campo de texto
            HStack {
                TextField("Escribe cómo te sientes...", text: $inputText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .disabled(aiService.isTyping)
                    .lineLimit(1...5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(isFocused ? accentColor.opacity(0.5) : .clear, lineWidth: 2)
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            // Botón de enviar
            Button(action: sendMessage) {
                ZStack {
                    Circle()
                        .fill(
                            canSend
                                ? LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "arrow.up")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(canSend ? .white : .gray)
                }
            }
            .disabled(!canSend)
            .scaleEffect(canSend ? 1.0 : 0.9)
            .animation(.spring(response: 0.3), value: canSend)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    // MARK: - Computed Properties
    
    private var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !aiService.isTyping
    }
    
    // MARK: - Actions
    
    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        HapticManager.shared.triggerImpact(style: .light)
        
        withAnimation(.easeOut(duration: 0.2)) {
            showSuggestions = false
        }
        
        inputText = ""
        isFocused = false
        
        Task {
            await aiService.sendMessage(text)
        }
    }
    
    private func clearConversation() {
        withAnimation(.spring(response: 0.4)) {
            aiService.isTyping = false
            aiService.messages.removeAll()
            showSuggestions = true
        }
        HapticManager.shared.triggerSelection()
    }
}

// MARK: - Message Bubble View

struct MessageBubbleView: View {
    let message: ChatMessage
    let userColor: Color
    let aiColor: Color
    let accentColor: Color
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser {
                Spacer(minLength: 60)
            } else {
                // Avatar de la IA
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [accentColor.opacity(0.2), accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundStyle(accentColor)
                }
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundStyle(message.isUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        AIBubbleShape(isUser: message.isUser)
                            .fill(message.isUser ? userColor : aiColor)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if message.isUser {
                // Avatar del usuario
                ZStack {
                    Circle()
                        .fill(userColor.opacity(0.3))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(userColor)
                }
            } else {
                Spacer(minLength: 60)
            }
        }
    }
}

// MARK: - Bubble Shape

struct AIBubbleShape: Shape {
    let isUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 18
        let tailSize: CGFloat = 6
        
        var path = Path()
        
        if isUser {
            // Burbuja del usuario (cola a la derecha)
            path.addRoundedRect(
                in: CGRect(x: 0, y: 0, width: rect.width - tailSize, height: rect.height),
                cornerSize: CGSize(width: radius, height: radius)
            )
        } else {
            // Burbuja de la IA (cola a la izquierda)
            path.addRoundedRect(
                in: CGRect(x: tailSize, y: 0, width: rect.width - tailSize, height: rect.height),
                cornerSize: CGSize(width: radius, height: radius)
            )
        }
        
        return path
    }
}

// MARK: - Typing Indicator

struct AITypingIndicatorView: View {
    let color: Color
    @State private var animationPhase = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color.opacity(animationPhase == index ? 1.0 : 0.3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(animationPhase == index ? 1.2 : 1.0)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
        .task {
            await startAnimation()
        }
    }
    
    private func startAnimation() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .milliseconds(400))
            withAnimation(.easeInOut(duration: 0.3)) {
                animationPhase = (animationPhase + 1) % 3
            }
        }
    }
}

// MARK: - Suggestion Chip

struct AISuggestionChip: View {
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(color)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(color.opacity(0.1))
                        .overlay(
                            Capsule()
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(AIScaleButtonStyle())
    }
}

// MARK: - Scale Button Style

struct AIScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AIHelperView()
    }
}

#Preview("With Messages") {
    NavigationStack {
        AIHelperView()
    }
}
