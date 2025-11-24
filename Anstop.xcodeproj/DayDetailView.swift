// DayDetailView.swift
import SwiftUI
import SwiftData

struct DayDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ProgramProgress.startDate, order: .forward) private var progressList: [ProgramProgress]

    private var progress: ProgramProgress? { progressList.first }
    private var dayCompleted: Int { progress?.dayCompleted ?? 0 }
    private var isCompleted: Bool { day <= dayCompleted }
    private var canComplete: Bool { day == dayCompleted + 1 }

    let day: Int

    var body: some View {
        let content = ProgramContent.content(for: day)
        List {
            Section(header: Text("Estado")) {
                HStack {
                    Text("Progreso")
                    Spacer()
                    ProgressView(value: Double(dayCompleted), total: 30)
                        .tint(.orange)
                        .frame(width: 160)
                }
                HStack {
                    Text("Estado del día")
                    Spacer()
                    if isCompleted {
                        Label("Completado", systemImage: "checkmark.circle.fill").foregroundStyle(.green)
                    } else if canComplete {
                        Label("En curso", systemImage: "arrow.right.circle.fill").foregroundStyle(.orange)
                    } else {
                        Label("Bloqueado", systemImage: "lock.fill").foregroundStyle(.secondary)
                    }
                }
            }

            Section(header: Text("Objetivos")) {
                ForEach(content.objectives, id: \.self) { obj in
                    Label(obj, systemImage: "checkmark.seal")
                }
            }
            Section(header: Text("Consejo")) {
                HStack(alignment: .top) {
                    Image(systemName: "lightbulb.fill").foregroundStyle(.yellow)
                    Text(content.tip)
                }
            }

            Section {
                if isCompleted {
                    Button(action: uncompleteDay) {
                        Text("Desmarcar día \(day)")
                            .padding(.horizontal, 40)
                    }
                    .buttonStyle(SecondaryButtonStyle(color: .orange))
                } else {
                    Button(action: completeDay) {
                        Text("Marcar día \(day) como completado")
                            .padding(.horizontal, 40)
                    }
                    .buttonStyle(PrimaryButtonStyle(color: .orange))
                    .disabled(!canComplete)
                }
            }
        }
        .navigationTitle("Día \(content.day)")
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

    private func completeDay() {
        guard let progress = progress else { return }
        guard canComplete else { return }
        progress.dayCompleted = min(progress.dayCompleted + 1, 30)
        do {
            try modelContext.save()
            HapticManager.shared.triggerNotification(.success)
        } catch {
            print("Error updating progress: \(error)")
            HapticManager.shared.triggerNotification(.error)
        }
    }

    private func uncompleteDay() {
        guard let progress = progress else { return }
        guard isCompleted else { return }
        // Only allow uncomplete if this is the last completed day to keep sequence consistent
        if day == progress.dayCompleted {
            progress.dayCompleted = max(progress.dayCompleted - 1, 0)
            do {
                try modelContext.save()
                HapticManager.shared.triggerSelection()
            } catch {
                print("Error updating progress: \(error)")
                HapticManager.shared.triggerNotification(.error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DayDetailView(day: 1)
    }
}
