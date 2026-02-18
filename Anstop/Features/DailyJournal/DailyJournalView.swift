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
                                .font(.futuraTitle2)
                                .foregroundStyle(Color("AnstopBlue"))
                            Text("journal_new_entry")
                                .font(.futuraHeadline)
                        }
                    }
                }

                Section("journal_history") {
                    ForEach(entries) { entry in
                        JournalEntryRow(entry: entry)
                    }
                    .onDelete(perform: deleteEntries)
                }
            }
            .anstopScrollBackground(.journal)
            .navigationTitle("journal_navigation_title")
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
                    .font(.futuraSubheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                MoodIndicator(mood: entry.mood)
            }

            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.futuraBody)
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
                Section("journal_how_do_you_feel_today") {
                    VStack(spacing: 20) {
                        Text(String(format: String(localized: "journal_mood_value_format"), mood))
                            .font(.futura(48))
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

                Section("journal_notes_optional") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("journal_new_entry_navigation_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("journal_save") {
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
