//
//  SettingsView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userName") private var userName = ""
    @AppStorage("initialAnxietyLevel") private var initialAnxietyLevel = 5.0

    @State private var showingDeleteAlert = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTerms = false

    var body: some View {
        List {
            // Legal Section
            Section {
                Button {
                    showingPrivacyPolicy = true
                } label: {
                    HStack {
                        Image(systemName: "hand.raised.fill")
                            .foregroundStyle(.blue)
                        Text("Política de Privacidad")
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }

                Button {
                    showingTerms = true
                } label: {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundStyle(.blue)
                        Text("Términos de Uso")
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
            } header: {
                Text("Legal")
            }

            // Data Management Section
            Section {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Borrar todos mis datos")
                    }
                }
            } header: {
                Text("Datos")
            } footer: {
                Text(
                    "Esto eliminará tu diario, registros y preferencias permanentemente. Esta acción no se puede deshacer."
                )
            }

            // App Info
            Section {
                HStack {
                    Text("Versión")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Desarrollado con")
                    Spacer()
                    Text("❤️ y SwiftUI")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Información")
            }
        }
        .navigationTitle("Configuración")
        .sheet(isPresented: $showingPrivacyPolicy) {
            LegalTextView(title: "Política de Privacidad", content: LegalData.privacyPolicy)
        }
        .sheet(isPresented: $showingTerms) {
            LegalTextView(title: "Términos de Uso", content: LegalData.termsOfUse)
        }
        .alert("¿Borrar todos los datos?", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Borrar Todo", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text(
                "Esto eliminará tu diario, registros de ansiedad y todas tus preferencias. No podrás recuperar esta información."
            )
        }
    }

    private func deleteAllData() {
        // 1. Eliminar SwiftData
        do {
            try modelContext.delete(model: JournalEntry.self)
            try modelContext.delete(model: AnxietyEvent.self)
        } catch {
            print("Error eliminando datos: \(error)")
        }

        // 2. Resetear AppStorage
        hasCompletedOnboarding = false
        userName = ""
        initialAnxietyLevel = 5.0
    }
}

struct LegalTextView: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let content: String

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(.init(content))
                    .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
