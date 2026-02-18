import XCTest
@testable import Anstop

final class AudioManagerTests: XCTestCase {
    func test_initialState_isIdle() async {
        await MainActor.run {
            let manager = AudioManager(configureAudioSessionOnInit: false)

            XCTAssertFalse(manager.isPlaying)
            XCTAssertNil(manager.currentAudio)
            XCTAssertEqual(manager.currentTime, 0)
            XCTAssertEqual(manager.duration, 0)
        }
    }

    func test_stop_resetsPlaybackState() async {
        await MainActor.run {
            let manager = AudioManager(configureAudioSessionOnInit: false)
            manager.isPlaying = true
            manager.currentAudio = "test-audio"
            manager.currentTime = 42
            manager.duration = 120

            manager.stop()

            XCTAssertFalse(manager.isPlaying)
            XCTAssertNil(manager.currentAudio)
            XCTAssertEqual(manager.currentTime, 0)
            XCTAssertEqual(manager.duration, 120)
        }
    }

    func test_seek_updatesCurrentTime() async {
        await MainActor.run {
            let manager = AudioManager(configureAudioSessionOnInit: false)

            manager.seek(to: 17.5)

            XCTAssertEqual(manager.currentTime, 17.5, accuracy: 0.0001)
        }
    }

    func test_pauseAndResume_toggleIsPlayingFlag() async {
        await MainActor.run {
            let manager = AudioManager(configureAudioSessionOnInit: false)

            manager.pause()
            XCTAssertFalse(manager.isPlaying)

            manager.resume()
            XCTAssertTrue(manager.isPlaying)
        }
    }
}
