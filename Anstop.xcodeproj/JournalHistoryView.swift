// JournalHistoryView.swift
import Foundation
import SwiftData
import SwiftUI

struct JournalHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    @State private var selectedEntry: JournalEntry?
    @State private var showEdit = false

    @State private var searchText: String = ""
    @State private var minMood: Int = 1
    @State private var maxMood: Int = 10

    private var filteredEntries: [JournalEntry] {
        entries.filter { entry in
            let matchesText: Bool
            if searchText.isEmpty {
                matchesText = true
            } else {
                let haystack = (entry.notes ?? "") + " " + entry.date.description
                matchesText = haystack.localizedCaseInsensitiveContains(searchText)
            }
            let matchesMood = entry.mood >= minMood && entry.mood <= maxMood
            return matchesText && matchesMood
        }
    }

    var body: some View {
        List {
            ForEach(filteredEntries) { entry in
                Button {
                    selectedEntry = entry
                    showEdit = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.date, style: .date) + Text(" · ") + Text(entry.date, style: .time)
                            Text("Ánimo: \(entry.mood)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if let notes = entry.notes, !notes.isEmpty {
                                Text(notes)
                                    .lineLimit(1)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: deleteFiltered)
        }
        .navigationTitle("Historial de Diario")
        .sheet(isPresented: $showEdit) {
            if let entry = selectedEntry {
                JournalEditView(entry: entry)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Buscar notas")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Text("Ánimo")
                    Slider(value: Binding(
                        get: { Double(minMood) },
                        set: { minMood = Int($0) }
                    ), in: 1 ... Double(maxMood), step: 1)
                    Text("\(minMood)")
                    Divider()
                    Slider(value: Binding(
                        get: { Double(maxMood) },
                        set: { maxMood = Int($0) }
                    ), in: Double(minMood) ... 10, step: 1)
                    Text("\(maxMood)")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }

    private func deleteFiltered(at offsets: IndexSet) {
        for index in offsets {
            let entry = filteredEntries[index]
            if let originalIndex = entries.firstIndex(where: { $0.id == entry.id }) {
                modelContext.delete(entries[originalIndex])
            }
        }
        try? modelContext.save()
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
        try? modelContext.save()
    }
}

struct JournalEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var mood: Double
    @State private var notes: String
    let entry: JournalEntry

    init(entry: JournalEntry) {
        self.entry = entry
        _mood = State(initialValue: Double(entry.mood))
        _notes = State(initialValue: entry.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Estado") {
                    HStack {
                        Text("Ánimo: \(Int(mood))")
                        Slider(value: $mood, in: 1 ... 10, step: 1)
                    }
                }
                Section("Notas") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                }
                Section {
                    Button("Guardar") { save() }
                        .padding(.horizontal, 40)
                        .buttonStyle(PrimaryButtonStyle())

                    Button("Cancelar") { dismiss() }
                        .padding(.horizontal, 40)
                        .buttonStyle(SecondaryButtonStyle(color: .orange))
                }
            }
            .navigationTitle("Editar entrada")
        }
    }

    private func save() {
        entry.mood = Int(mood)
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        entry.notes = trimmed.isEmpty ? nil : trimmed
        do {
            try modelContext.save()
            HapticManager.shared.triggerNotification(.success)
            dismiss()
        } catch {
            print("Error saving entry: \(error)")
            HapticManager.shared.triggerNotification(.error)
        }
    }
}

#Preview {
    NavigationStack { JournalHistoryView() }
}
