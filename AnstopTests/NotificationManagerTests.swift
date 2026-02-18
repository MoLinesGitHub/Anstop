import UserNotifications
import XCTest
@testable import Anstop

final class NotificationManagerTests: XCTestCase {
    func test_makeDailyReminderRequest_setsIdentifierAndTimeComponents() async {
        await MainActor.run {
            let center = MockNotificationCenter()
            let manager = NotificationManager(center: center)

            let request = manager.makeDailyReminderRequest(hour: 21, minute: 45)
            let trigger = request.trigger as? UNCalendarNotificationTrigger

            XCTAssertEqual(request.identifier, NotificationManager.dailyReminderIdentifier)
            XCTAssertNotNil(trigger)
            XCTAssertEqual(trigger?.dateComponents.hour, 21)
            XCTAssertEqual(trigger?.dateComponents.minute, 45)
            XCTAssertTrue(trigger?.repeats ?? false)
            XCTAssertFalse(request.content.title.isEmpty)
            XCTAssertFalse(request.content.body.isEmpty)
        }
    }

    func test_scheduleDailyReminder_cancelsExistingAndAddsRequest() async {
        let center = await MainActor.run { MockNotificationCenter() }
        let manager = await MainActor.run { NotificationManager(center: center) }

        await manager.scheduleDailyReminder(at: 8, minute: 30)

        await MainActor.run {
            XCTAssertEqual(center.removedIdentifiers.last, [NotificationManager.dailyReminderIdentifier])
            XCTAssertEqual(center.addedRequests.count, 1)
        }
    }

    func test_requestAuthorization_returnsCenterValue() async {
        let center = await MainActor.run { MockNotificationCenter() }
        await MainActor.run {
            center.authorizationResult = true
        }
        let manager = await MainActor.run { NotificationManager(center: center) }

        let granted = await manager.requestAuthorization()

        await MainActor.run {
            XCTAssertTrue(granted)
            XCTAssertTrue(center.didRequestAuthorization)
            XCTAssertNotNil(center.delegate)
        }
    }

    func test_cancelDailyReminder_removesKnownIdentifier() async {
        await MainActor.run {
            let center = MockNotificationCenter()
            let manager = NotificationManager(center: center)

            manager.cancelDailyReminder()

            XCTAssertEqual(center.removedIdentifiers.last, [NotificationManager.dailyReminderIdentifier])
        }
    }
}

@MainActor
private final class MockNotificationCenter: UserNotificationCenterClient {
    var delegate: UNUserNotificationCenterDelegate?
    var didRequestAuthorization = false
    var authorizationResult = false
    var authorizationError: Error?
    var pendingRequests: [UNNotificationRequest] = []
    var addedRequests: [UNNotificationRequest] = []
    var removedIdentifiers: [[String]] = []

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        didRequestAuthorization = true
        if let authorizationError {
            throw authorizationError
        }
        return authorizationResult
    }

    func pendingNotificationRequests() async -> [UNNotificationRequest] {
        pendingRequests
    }

    func add(_ request: UNNotificationRequest) async throws {
        addedRequests.append(request)
    }

    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        removedIdentifiers.append(identifiers)
    }
}
