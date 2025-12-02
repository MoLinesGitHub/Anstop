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
    @Environment(PurchaseManager.self) private var purchaseManager
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userName") private var userName = ""
    @AppStorage("initialAnxietyLevel") private var initialAnxietyLevel = 5.0
    @AppStorage(HapticManager.userDefaultsKey) private var hapticsEnabled: Bool = true

    @State private var showingDeleteAlert = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTerms = false
    @State private var showPaywall = false

    @State private var remindersEnabled: Bool = false
    @State private var reminderTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()

    var body: some View {
        List {
            // Premium Section (solo para usuarios no premium)
            if !purchaseManager.isPremium {
                Section {
                    Button {
                        showPaywall = true
                    } label: {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.yellow)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Obtener Premium")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("7 días de prueba GRATIS")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                } header: {
                    Text("Suscripción")
                } footer: {
                    Text("Desbloquea todas las funciones premium incluyendo guías de audio ilimitadas, programa de 30 días y asistente IA.")
                }
            } else {
                Section {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                        Text("Premium Activo")
                            .font(.headline)
                        Spacer()
                        Text("✓")
                            .foregroundStyle(.green)
                    }
                } header: {
                    Text("Suscripción")
                }
            }
            
            // Preferences Section
            Section {
                Toggle(isOn: $hapticsEnabled) {
                    HStack {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .foregroundStyle(.blue)
                        Text("Hápticos")
                    }
                }
                .onChange(of: hapticsEnabled) {
                    if hapticsEnabled { HapticManager.shared.warmUp() }
                }
            } header: {
                Text("Preferencias")
            }

            // Reminders Section
            Section {
                Toggle(isOn: $remindersEnabled) {
                    HStack {
                        Image(systemName: "bell.fill").foregroundStyle(.orange)
                        Text("Recordatorio diario")
                    }
                }

                if remindersEnabled {
                    DatePicker("Hora", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                }

                Button("Guardar recordatorio") {
                    Task {
                        let granted = await NotificationManager.shared.requestAuthorization()
                        guard granted else { return }
                        let comps = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
                        let hour = comps.hour ?? 20
                        let minute = comps.minute ?? 0
                        if remindersEnabled {
                            await NotificationManager.shared.scheduleDailyReminder(at: hour, minute: minute)
                            HapticManager.shared.triggerNotification(.success)
                        } else {
                            NotificationManager.shared.cancelDailyReminder()
                            HapticManager.shared.triggerSelection()
                        }
                    }
                }
                .padding(.horizontal, 40)
                .buttonStyle(PrimaryButtonStyle(color: .orange))
                .disabled(!remindersEnabled)
                
                Button("Cancelar recordatorio") {
                    Task {
                        NotificationManager.shared.cancelDailyReminder()
                        HapticManager.shared.triggerSelection()
                    }
                }
                .padding(.horizontal, 40)
                .buttonStyle(SecondaryButtonStyle(color: .orange))
            } header: {
                Text("Recordatorios")
            } footer: {
                Text("Programa un recordatorio diario para registrar tu estado en el diario.")
            }

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
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
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

