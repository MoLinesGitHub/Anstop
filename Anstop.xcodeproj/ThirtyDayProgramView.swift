// ThirtyDayProgramView.swift
import SwiftData
import SwiftUI

struct ThirtyDayProgramView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ProgramProgress.startDate, order: .forward) private var progressList: [ProgramProgress]

    private var progress: ProgramProgress? { progressList.first }
    private var currentDay: Int { min(max(progress?.dayCompleted ?? 0, 0), 30) }

    var body: some View {
        VStack(spacing: 16) {
            Text("Programa de 30 Días")
                .font(.title)
                .bold()

            Text("Día actual: \(currentDay + 1)")
                .font(.headline)
                .foregroundStyle(.secondary)

            // Detail card for the current day
            DayDetailCard(day: currentDay + 1)
                .padding(.vertical, 4)

            List {
                Section("Progreso") {
                    ProgressView(value: Double(currentDay), total: 30)
                        .tint(.orange)
                    Text("Completados: \(currentDay) / 30")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Días") {
                    ForEach(0 ..< 30, id: \.self) { day in
                        NavigationLink(destination: DayDetailView(day: day + 1)) {
                            HStack {
                                Text("Día \(day + 1)")
                                Spacer()
                                if day < currentDay {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else if day == currentDay {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundStyle(.orange)
                                }
                            }
                        }
                    }
                }
            }

            Button(action: completeToday) {
                Text(currentDay >= 30 ? "Programa completado" : "Marcar día \(currentDay + 1) como completado")
                    .padding(.horizontal, 40)
            }
            .buttonStyle(PrimaryButtonStyle(color: .orange))
            .disabled(currentDay >= 30)
        }
        .padding()
        .navigationTitle("Programa 30 Días")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: ensureProgress)
    }

    private func ensureProgress() {
        if progress == nil {
            let new = ProgramProgress(startDate: Date(), dayCompleted: 0)
            modelContext.insert(new)
            try? modelContext.save()
        }
    }

    private func completeToday() {
        guard let progress else { return }
        let next = min(progress.dayCompleted + 1, 30)
        progress.dayCompleted = next
        do {
            try modelContext.save()
            HapticManager.shared.triggerNotification(.success)
        } catch {
            print("Error updating progress: \(error)")
            HapticManager.shared.triggerNotification(.error)
        }
    }
}

struct DayDetailCard: View {
    let day: Int

    var body: some View {
        let content = ProgramContent.content(for: day)
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "target")
                    .foregroundStyle(.orange)
                Text("Objetivos del día \(content.day)")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(content.objectives, id: \.self) { obj in
                    Label(obj, systemImage: "checkmark.seal")
                }
            }
            .font(.subheadline)

            Divider()

            HStack(alignment: .top) {
                Image(systemName: "lightbulb.fill").foregroundStyle(.yellow)
                Text(content.tip)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack { ThirtyDayProgramView() }
}
