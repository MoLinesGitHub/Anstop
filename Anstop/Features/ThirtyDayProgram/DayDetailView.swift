//
//  DayDetailView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftData
import SwiftUI

struct DayDetailView: View {
    let day: Int

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var progressRecords: [ProgramProgress]

    private var progress: ProgramProgress? {
        progressRecords.first
    }

    private var exercise: DailyExercise? {
        DailyExercise.all.first(where: { $0.day == day })
    }

    @State private var showCompletionAnimation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("Día \(day)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Text(exercise?.title ?? "")
                        .font(.largeTitle)
                        .bold()

                    Text(exercise?.description ?? "")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Badge de tipo
                HStack {
                    Image(systemName: exerciseIcon)
                        .font(.caption)
                    Text(exerciseTypeName)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .foregroundStyle(.blue)
                .clipShape(Capsule())
                .padding(.horizontal, 20)

                // Contenido
                VStack(alignment: .leading, spacing: 16) {
                    Text("Instrucciones")
                        .font(.headline)

                    Text(exercise?.content ?? "")
                        .font(.body)
                        .lineSpacing(6)
                }
                .padding(20)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)

                // Botón de completar
                if let progress, !progress.isDayCompleted(day) {
                    Button(action: completeDay) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Marcar como Completado")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.blue))
                    }
                    .padding(.horizontal, 20)
                } else {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Completado")
                            .foregroundStyle(.secondary)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .systemGray6))
                    )
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 40)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if showCompletionAnimation {
                CompletionOverlay()
            }
        }
    }

    private var exerciseIcon: String {
        guard let exercise else { return "questionmark" }
        switch exercise.exerciseType {
        case .breathing: return "wind"
        case .grounding: return "hand.raised.fill"
        case .reflection: return "brain.head.profile"
        case .journaling: return "book.fill"
        case .mindfulness: return "sparkles"
        }
    }

    private var exerciseTypeName: String {
        guard let exercise else { return "" }
        switch exercise.exerciseType {
        case .breathing: return "Respiración"
        case .grounding: return "Grounding"
        case .reflection: return "Reflexión"
        case .journaling: return "Diario"
        case .mindfulness: return "Mindfulness"
        }
    }

    private func completeDay() {
        guard let progress else { return }

        progress.markDayCompleted(day)

        withAnimation {
            showCompletionAnimation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCompletionAnimation = false
            }
            dismiss()
        }
    }
}

struct CompletionOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.green)

                Text("¡Día completado!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DayDetailView(day: 1)
            .modelContainer(for: [ProgramProgress.self])
    }
}
