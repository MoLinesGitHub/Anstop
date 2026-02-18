import AVFoundation
import Observation

@MainActor
@Observable
final class AudioManager {
    private var player: AVAudioPlayer?
    var isPlaying: Bool = false
    var currentAudio: String?
    var duration: TimeInterval = 0
    var currentTime: TimeInterval = 0

    init(configureAudioSessionOnInit: Bool = true) {
        if configureAudioSessionOnInit {
            configureAudioSession()
        }
    }

    private nonisolated func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default)
        try? audioSession.setActive(true)
    }

    func play(_ audioName: String) {
        guard let url = Bundle.main.url(forResource: audioName, withExtension: "mp3") else {
            print("Audio file not found: \(audioName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()

            currentAudio = audioName
            duration = player?.duration ?? 0
            isPlaying = true
        } catch {
            print("Error playing audio: \(error)")
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func resume() {
        player?.play()
        isPlaying = true
    }

    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
        currentAudio = nil
        currentTime = 0
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }
}
