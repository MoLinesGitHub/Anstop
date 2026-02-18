import XCTest
@testable import Anstop

final class ProgramProgressTests: XCTestCase {
    func test_markDayCompleted_addsDayAndSetsInitialStreak() {
        let progress = ProgramProgress()

        progress.markDayCompleted(1)

        XCTAssertEqual(progress.completedDays, [1])
        XCTAssertEqual(progress.currentStreak, 1)
        XCTAssertNotNil(progress.lastCompletedDate)
    }

    func test_markDayCompleted_duplicateDay_doesNotDuplicateOrChangeStreak() {
        let progress = ProgramProgress()
        progress.completedDays = [1]
        progress.currentStreak = 1
        progress.lastCompletedDate = Date()

        progress.markDayCompleted(1)

        XCTAssertEqual(progress.completedDays, [1])
        XCTAssertEqual(progress.currentStreak, 1)
    }

    func test_markDayCompleted_whenLastCompletionWasYesterday_incrementsStreak() {
        let progress = ProgramProgress()
        progress.completedDays = [1]
        progress.currentStreak = 1
        progress.lastCompletedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        progress.markDayCompleted(2)

        XCTAssertEqual(progress.currentStreak, 2)
        XCTAssertEqual(progress.completedDays, [1, 2])
    }

    func test_markDayCompleted_whenLastCompletionHasGap_resetsStreak() {
        let progress = ProgramProgress()
        progress.completedDays = [1]
        progress.currentStreak = 6
        progress.lastCompletedDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())

        progress.markDayCompleted(2)

        XCTAssertEqual(progress.currentStreak, 1)
    }

    func test_isDayUnlocked_rules() {
        let progress = ProgramProgress()

        XCTAssertTrue(progress.isDayUnlocked(1))
        XCTAssertFalse(progress.isDayUnlocked(2))

        progress.completedDays = [1]
        XCTAssertTrue(progress.isDayUnlocked(2))
        XCTAssertFalse(progress.isDayUnlocked(3))
    }

    func test_progressPercentage_uses30DayBase() {
        let progress = ProgramProgress()
        progress.completedDays = [1, 2, 3]

        XCTAssertEqual(progress.progressPercentage, 0.1, accuracy: 0.0001)
    }
}

