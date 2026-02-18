//  SettingsView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import GlassKitPro
import SwiftData
import SwiftUI

struct SettingsView: View {
   @Environment(\.modelContext) private var modelContext
   @State private var purchaseManager = PurchaseManager.shared
   @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
   @AppStorage("userName") private var userName = ""
   @AppStorage("initialAnxietyLevel") private var initialAnxietyLevel = 5.0
   @AppStorage(HapticManager.userDefaultsKey) private var hapticsEnabled: Bool = true

   @State private var showingDeleteAlert = false
   @State private var showingPrivacyPolicy = false
   @State private var showingTerms = false
   @State private var showingEULA = false
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
                               Text("settings_get_premium")
                                   .font(.futuraHeadline)
                                   .foregroundStyle(.primary)
                               Text("settings_trial_subtitle")
                                   .font(.futuraCaption)
                                   .foregroundStyle(.secondary)
                           }
                           Spacer()
                           Image(systemName: "chevron.right")
                               .foregroundStyle(.secondary)
                               .font(.futuraCaption)
                       }
                   }
               } header: {
                   Text("settings_subscription")
               } footer: {
                   Text("settings_subscription_footer")
               }
           } else {
               Section {
                   HStack {
                       Image(systemName: "checkmark.seal.fill")
                           .foregroundStyle(.green)
                       Text("settings_premium_active")
                           .font(.futuraHeadline)
                       Spacer()
                       Text("settings_checkmark")
                           .foregroundStyle(.green)
                   }
               } header: {
                   Text("settings_subscription")
               }
           }

           // Preferences Section
           Section {
               Toggle(isOn: $hapticsEnabled) {
                   HStack {
                       Image(systemName: "dot.radiowaves.left.and.right")
                           .foregroundStyle(Color("AnstopBlue"))
                       Text("settings_haptics")
                   }
               }
               .onChange(of: hapticsEnabled) {
                   if hapticsEnabled { HapticManager.shared.warmUp() }
               }
           } header: {
               Text("settings_preferences")
           }

           // Reminders Section
           Section {
               Toggle(isOn: $remindersEnabled) {
                   HStack {
                       Image(systemName: "bell.fill").foregroundStyle(.orange)
                       Text("settings_daily_reminder")
                   }
               }

               if remindersEnabled {
                   DatePicker("settings_time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                       .datePickerStyle(.compact)
               }

               Button("settings_save_reminder") {
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

               Button("settings_cancel_reminder") {
                   Task {
                       NotificationManager.shared.cancelDailyReminder()
                       HapticManager.shared.triggerSelection()
                   }
               }
               .padding(.horizontal, 40)
               .buttonStyle(SecondaryButtonStyle(color: .orange))
           } header: {
               Text("settings_reminders")
           } footer: {
               Text("settings_reminders_footer")
           }

           // Legal Section
           Section {
               Button {
                   showingPrivacyPolicy = true
               } label: {
                   HStack {
                       Image(systemName: "hand.raised.fill")
                           .foregroundStyle(Color("AnstopBlue"))
                       Text("settings_privacy_policy")
                           .foregroundStyle(.primary)
                       Spacer()
                       Image(systemName: "chevron.right")
                           .foregroundStyle(.secondary)
                           .font(.futuraCaption)
                   }
               }

               Button {
                   showingTerms = true
               } label: {
                   HStack {
                       Image(systemName: "doc.text.fill")
                           .foregroundStyle(Color("AnstopBlue"))
                       Text("settings_terms_of_use")
                           .foregroundStyle(.primary)
                       Spacer()
                       Image(systemName: "chevron.right")
                           .foregroundStyle(.secondary)
                           .font(.futuraCaption)
                   }
               }

               Button {
                   showingEULA = true
               } label: {
                   HStack {
                       Image(systemName: "doc.plaintext.fill")
                           .foregroundStyle(Color("AnstopBlue"))
                       Text("settings_eula")
                           .foregroundStyle(.primary)
                       Spacer()
                       Image(systemName: "chevron.right")
                           .foregroundStyle(.secondary)
                           .font(.futuraCaption)
                   }
               }
           } header: {
               Text("settings_legal")
           }

           // Data Management Section
           Section {
               Button(role: .destructive) {
                   showingDeleteAlert = true
               } label: {
                   HStack {
                       Image(systemName: "trash.fill")
                       Text("settings_delete_all_data")
                   }
               }
           } header: {
               Text("settings_data")
           } footer: {
               Text("settings_data_footer")
           }

           // App Info
           Section {
               HStack {
                   Text("settings_version")
                   Spacer()
                   Text("settings_version_value")
                       .foregroundStyle(.secondary)
               }

               HStack {
                   Text("settings_developed_with")
                   Spacer()
                   Text("settings_developed_with_value")
                       .foregroundStyle(.secondary)
               }
           } header: {
               Text("settings_information")
           }
       }
       .navigationTitle("settings_navigation_title")
       .sheet(isPresented: $showPaywall) {
           PaywallView()
       }
       .sheet(isPresented: $showingPrivacyPolicy) {
           LegalTextView(title: String(localized: "settings_privacy_policy"), content: LegalData.privacyPolicy)
       }
       .sheet(isPresented: $showingTerms) {
           LegalTextView(title: String(localized: "settings_terms_of_use"), content: LegalData.termsOfUse)
       }
       .sheet(isPresented: $showingEULA) {
           LegalTextView(title: String(localized: "settings_eula"), content: LegalData.eula)
       }
       .alert("settings_delete_alert_title", isPresented: $showingDeleteAlert) {
           Button("settings_delete_alert_cancel", role: .cancel) {}
           Button("settings_delete_alert_confirm", role: .destructive) {
               deleteAllData()
           }
       } message: {
           Text("settings_delete_alert_message")
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
                   Button("close") {
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
