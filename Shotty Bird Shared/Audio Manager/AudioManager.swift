//
//  AudioManager.swift
//  Shotty Bird Shared
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import AVFoundation

/// Defines what type of music to play.
enum MusicType {
    case menu
    case gameplay
    case practice
    case gameOver
}

/// Audio manager class to control game music playback on iOS and iPadOS.
final class AudioManager: NSObject {
    
    /// Shared manager instance.
    static let shared = AudioManager()
    
    /// The maximum volume for the music.
    static let maxVolume: Float = 0.5
    
    /// The maxium playback rate allowed.
    static let maximumPlaybackRate: Float = 2.0
    
    /// The audio session.
    private var session: AVAudioSession?
    /// The audio player.
    private var player: AVAudioPlayer?
    
    /// Internal mute state value.
    private var isMutedValue = false
    /// Returns or sets the current mute state of the audio player.
    var isMuted: Bool {
        get {
            isMutedValue
        }
        set {
            isMutedValue = newValue
            player?.volume = newValue ? 0.0 : AudioManager.maxVolume
        }
    }
    
    /// Flag that determines if the music was interrupted due to an audio session interruption.
    private(set) var isMusicInterrupted = false
    
    /// Creates a new `AudioManager` instance.
    private override init() {
        super.init()
        configureAudioSession()
    }
    
    // MARK: - Audio session and player setup
    
    /// Configures the audio session.
    private func configureAudioSession() {
        session = AVAudioSession.sharedInstance()
        do {
            try session?.setCategory(.playback)
        } catch {
            print("Error setting category: \(error.localizedDescription)")
        }
    }
    
    /// Plays game music.
    /// - Parameters:
    ///   - type: The type of music to play.
    ///   - loop: Determines if the music should play again after it is over.
    func playMusic(type: MusicType, loop: Bool) {
        var resource: String
        switch type {
        case .menu:
            resource = "Crimson-Sextile"
        case .gameplay:
            resource = "TwinEngines-JeremyKorpas"
        default:
            resource = "Crimson-Sextile"
        }
        guard let backgroundMusicPath = Bundle.main.path(forResource: resource, ofType: "mp3") else {
            return
        }
        if player?.isPlaying == true {
            player?.stop()
        }
        do {
            let backgroundMusicURL = URL(fileURLWithPath: backgroundMusicPath)
            try player = AVAudioPlayer(contentsOf: backgroundMusicURL)
            player?.delegate = self
            player?.numberOfLoops = loop ? -1 : 0
            player?.enableRate = true
            player?.volume = isMuted ? 0.0 : AudioManager.maxVolume
            resume()
        } catch {
            print("Error when trying to setup the audio player: \(error.localizedDescription)")
        }
    }
    
    /// Attempts to resume audio playback.
    func resume() {
        if session?.isOtherAudioPlaying == false {
            player?.prepareToPlay()
            player?.play()
        }
    }
    
    /// Pauses audio playback.
    func pause() {
        player?.pause()
    }
    
    /// Stops audio playback.
    func stop() {
        if player?.isPlaying == true {
            player?.stop()
        }
    }
    
    /// Increases the playback rate by a given amount.
    /// - Parameter by: The playback rate value to added .
    func increasePlaybackRate(by: Float) {
        guard let rate = player?.rate else {
            return
        }
        if rate <= AudioManager.maximumPlaybackRate {
            player?.rate += by
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        isMusicInterrupted = true
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        resume()
        if player.isPlaying == true {
            isMusicInterrupted = false
        }
    }
}

