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
                    Text(String(format: String(localized: "program_day_label_format"), day))
                        .font(.futuraCaption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Text(exercise?.title ?? "")
                        .font(.prometheusLargeTitle)

                    Text(exercise?.description ?? "")
                        .font(.futuraTitle3)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Badge de tipo
                HStack {
                    Image(systemName: exerciseIcon)
                        .font(.futuraCaption)
                    Text(exerciseTypeName)
                        .font(.futuraCaption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color("AnstopBlue").opacity(0.1))
                .foregroundStyle(Color("AnstopBlue"))
                .clipShape(Capsule())
                .padding(.horizontal, 20)

                // Contenido
                VStack(alignment: .leading, spacing: 16) {
                    Text("program_instructions")
                        .font(.futuraHeadline)

                    Text(exercise?.content ?? "")
                        .font(.futuraBody)
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
                            Text("program_mark_completed")
                        }
                        .font(.futuraHeadline)
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
                        Text("program_completed")
                            .foregroundStyle(.secondary)
                    }
                    .font(.futuraHeadline)
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
        case .breathing: return String(localized: "program_type_breathing")
        case .grounding: return String(localized: "program_type_grounding")
        case .reflection: return String(localized: "program_type_reflection")
        case .journaling: return String(localized: "program_type_journaling")
        case .mindfulness: return String(localized: "program_type_mindfulness")
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
                    .font(.futura(80))
                    .foregroundStyle(.green)

                Text("program_day_completed_title")
                    .font(.futuraTitle)
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
