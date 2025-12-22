// NotificationManager.swift
import Foundation
import OSLog
import UserNotifications

@MainActor
final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    override private init() {}

    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            AppLogger.notifications.error("Authorization error: \(String(describing: error))")
            return false
        }
    }

    func scheduleDailyReminder(at hour: Int, minute: Int) async {
        let center = UNUserNotificationCenter.current()
        cancelDailyReminder()

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Momento de tu check-in"
        content.body = "Registra tu estado en el diario de Anstop."
        content.sound = .default

        let pending = await center.pendingNotificationRequests()
        AppLogger.notifications.info("Pending before schedule: \(pending.count)")

        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        do {
            try await center.add(request)
        } catch {
            AppLogger.notifications.error("Schedule error: \(String(describing: error))")
        }
    }

    func cancelDailyReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
        AppLogger.notifications.info("Daily reminder canceled")
    }
}
