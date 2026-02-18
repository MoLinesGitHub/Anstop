// NotificationManager.swift
import Foundation
import OSLog
import UserNotifications

@MainActor
protocol UserNotificationCenterClient: AnyObject {
    var delegate: UNUserNotificationCenterDelegate? { get set }
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func pendingNotificationRequests() async -> [UNNotificationRequest]
    func add(_ request: UNNotificationRequest) async throws
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
}

@MainActor
final class LiveUserNotificationCenterClient: UserNotificationCenterClient {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    var delegate: UNUserNotificationCenterDelegate? {
        get { center.delegate }
        set { center.delegate = newValue }
    }

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        try await center.requestAuthorization(options: options)
    }

    func pendingNotificationRequests() async -> [UNNotificationRequest] {
        await center.pendingNotificationRequests()
    }

    func add(_ request: UNNotificationRequest) async throws {
        try await center.add(request)
    }

    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

@MainActor
final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let dailyReminderIdentifier = "daily_reminder"
    static let shared = NotificationManager()
    private let center: any UserNotificationCenterClient

    private override convenience init() {
        self.init(center: LiveUserNotificationCenterClient())
    }

    init(center: any UserNotificationCenterClient) {
        self.center = center
        super.init()
    }

    func requestAuthorization() async -> Bool {
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
        cancelDailyReminder()

        let pending = await center.pendingNotificationRequests()
        AppLogger.notifications.info("Pending before schedule: \(pending.count)")

        let request = makeDailyReminderRequest(hour: hour, minute: minute)
        do {
            try await center.add(request)
        } catch {
            AppLogger.notifications.error("Schedule error: \(String(describing: error))")
        }
    }

    func cancelDailyReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [Self.dailyReminderIdentifier])
        AppLogger.notifications.info("Daily reminder canceled")
    }

    func makeDailyReminderRequest(hour: Int, minute: Int) -> UNNotificationRequest {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = String(localized: "notifications_daily_title")
        content.body = String(localized: "notifications_daily_body")
        content.sound = .default

        return UNNotificationRequest(identifier: Self.dailyReminderIdentifier, content: content, trigger: trigger)
    }
}
