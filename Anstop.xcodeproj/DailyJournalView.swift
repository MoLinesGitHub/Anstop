// DailyJournalView.swift
import SwiftUI
import SwiftData

struct DailyJournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showSavedAlert = false
    @State private var mood: Double = 5
    @State private var notes: String = ""

    var body: some View {
        Form {
            Section("Estado") {
                HStack {
                    Text("Ánimo: \(Int(mood))")
                    Slider(value: $mood, in: 1...10, step: 1)
                }
            }
            Section("Notas") {
                TextEditor(text: $notes)
                    .frame(minHeight: 120)
            }
            Section {
                Button("Guardar") { saveEntry() }
                    .buttonStyle(PrimaryButtonStyle())
            }
        }
        .navigationTitle("Diario del día")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Guardado", isPresented: $showSavedAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Tu entrada del diario se ha guardado correctamente.")
        }
    }
    
    private func saveEntry() {
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = JournalEntry(date: Date(), mood: Int(mood), notes: trimmedNotes.isEmpty ? nil : trimmedNotes)
        modelContext.insert(entry)
        do {
            try modelContext.save()
            HapticManager.shared.triggerNotification(.success)
            showSavedAlert = true
            // Optionally reset fields
            notes = ""
        } catch {
            print("Error saving journal entry: \(error)")
            HapticManager.shared.triggerNotification(.error)
        }
    }
}

#Preview {
    NavigationStack { DailyJournalView() }
}
