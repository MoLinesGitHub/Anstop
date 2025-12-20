//
//  DailyJournalView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import GlassKitPro
import SwiftData
import SwiftUI

struct DailyJournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]

    @State private var showNewEntry = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: { showNewEntry = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color("Blue"))
                            Text("Nueva entrada")
                                .font(.headline)
                        }
                    }
                }

                Section("Historial") {
                    ForEach(entries) { entry in
                        JournalEntryRow(entry: entry)
                    }
                    .onDelete(perform: deleteEntries)
                }
            }
            .anstopScrollBackground(.journal)
            .navigationTitle("Diario")
            .sheet(isPresented: $showNewEntry) {
                NewJournalEntryView()
            }
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                MoodIndicator(mood: entry.mood)
            }

            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.body)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct MoodIndicator: View {
    let mood: Int

    var color: Color {
        switch mood {
        case 1 ... 3: .red
        case 4 ... 6: .orange
        case 7 ... 8: .yellow
        case 9 ... 10: .green
        default: .gray
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1 ... 10, id: \.self) { index in
                Circle()
                    .fill(index <= mood ? color : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct NewJournalEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var mood: Int = 5
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("¿Cómo te sientes hoy?") {
                    VStack(spacing: 20) {
                        Text("\(mood)/10")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(moodColor)

                        Slider(
                            value: Binding(
                                get: { Double(mood) },
                                set: { mood = Int($0) }
                            ), in: 1 ... 10, step: 1
                        )
                    }
                    .padding(.vertical)
                }

                Section("Notas (opcional)") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Nueva Entrada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveEntry()
                        dismiss()
                    }
                }
            }
        }
    }

    private var moodColor: Color {
        switch mood {
        case 1 ... 3: .red
        case 4 ... 6: .orange
        case 7 ... 8: .yellow
        case 9 ... 10: .green
        default: .gray
        }
    }

    private func saveEntry() {
        let entry = JournalEntry(
            mood: mood,
            notes: notes.isEmpty ? nil : notes
        )
        modelContext.insert(entry)
    }
}

#Preview {
    DailyJournalView()
        .modelContainer(for: JournalEntry.self)
}
