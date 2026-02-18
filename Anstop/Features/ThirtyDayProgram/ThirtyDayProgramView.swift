//
//  ThirtyDayProgramView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import GlassKitPro
import SwiftData
import SwiftUI

struct ThirtyDayProgramView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var progressRecords: [ProgramProgress]

    private var progress: ProgramProgress {
        if let existing = progressRecords.first {
            return existing
        } else {
            let newProgress = ProgramProgress()
            modelContext.insert(newProgress)
            return newProgress
        }
    }

    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header con Racha
                VStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .font(.futura(50))
                        .foregroundStyle(.orange.gradient)

                    Text(
                        String(
                            format: String(localized: "program_streak_days_format"),
                            progress.currentStreak
                        )
                    )
                        .font(.prometheusTitle2)

                    Text(
                        String(
                            format: String(localized: "program_completed_exercises_format"),
                            progress.completedDays.count
                        )
                    )
                        .font(.futuraSubheadline)
                        .foregroundStyle(.secondary)

                    ProgressView(value: progress.progressPercentage)
                        .tint(.blue)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 20)

                // Grid de 30 días
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(1 ... 30, id: \.self) { day in
                        DayCell(
                            day: day,
                            isCompleted: progress.isDayCompleted(day),
                            isUnlocked: progress.isDayUnlocked(day)
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
        }
        .anstopBackground(.program)
        .navigationTitle("program_navigation_title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DayCell: View {
    let day: Int
    let isCompleted: Bool
    let isUnlocked: Bool

    var body: some View {
        NavigationLink(destination: DayDetailView(day: day)) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.futuraTitle)
                        .foregroundStyle(.white)
                } else {
                    VStack(spacing: 4) {
                        Text("\(day)")
                            .font(.futuraTitle2)
                            .bold()
                        Text("program_day_short")
                            .font(.futuraCaption2)
                    }
                    .foregroundStyle(isUnlocked ? .white : .secondary)
                }
            }
            .frame(height: 70)
        }
        .disabled(!isUnlocked)
    }

    private var backgroundColor: Color {
        if isCompleted {
            .green
        } else if isUnlocked {
            Color("AnstopBlue")
        } else {
            Color(uiColor: .systemGray5)
        }
    }
}

#Preview {
    NavigationStack {
        ThirtyDayProgramView()
            .modelContainer(for: [ProgramProgress.self])
    }
}
