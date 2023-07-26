//
//  AudioManager.swift
//  Shotty Bird Shared
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import AVFoundation

/// Audio manager class to control game music playback on iOS and iPadOS.
class AudioManager: NSObject {
    
    /// The maximum volume for the music.
    static let maxVolume: Float = 0.5
    
    /// The audio session.
    private var session: AVAudioSession?
    /// The audio player.
    private var player: AVAudioPlayer?
    
    /// Returns or sets the current mute state of the audio player.
    var isMuted: Bool {
        get {
            player?.volume == 0.0
        }
        set {
            player?.volume = newValue ? 0.0 : AudioManager.maxVolume
        }
    }
    
    /// Flag that determines if the music was interrupted due to an audio session interruption.
    private(set) var isMusicInterrupted = false
    
    /// Creates a new `AudioManager` instance.
    /// - Parameters:
    ///   - file: The audio file to play.
    ///   - type: The audio file type extension.
    ///   - loop: Flag to determine if the audio should play again after it is over.
    init(file:String?, type:String?, loop: Bool) {
        super.init()
        configureAudioSession()
        configureAudioPlayer(file: file, type: type, loop: loop)
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
    
    /// Configures the audio player.
    /// - Parameters:
    ///   - file: The audio file to play.
    ///   - type: The audio file type extension.
    ///   - loop: Flag to determine if the audio should play again after it is over.
    private func configureAudioPlayer(file: String?, type: String?, loop: Bool) {
        guard let backgroundMusicPath = Bundle.main.path(forResource: file, ofType: type) else {
            return
        }
        do {
            let backgroundMusicURL = URL(fileURLWithPath: backgroundMusicPath)
            try player = AVAudioPlayer(contentsOf: backgroundMusicURL)
            player?.delegate = self
            player?.numberOfLoops = loop ? -1 : 0
            player?.enableRate = true
        } catch {
            print("Error when trying to setup the audio player: \(error.localizedDescription)")
        }
    }
    
    /// Attempts to play the loaded audio file.
    func tryPlayMusic() {
        if session?.isOtherAudioPlaying == false {
            player?.prepareToPlay()
            player?.play()
        }
    }
    
    /// Stops playing audio.
    func stopMusic() {
        if player?.isPlaying == true {
            player?.stop()
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        isMusicInterrupted = true
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        tryPlayMusic()
        if player.isPlaying == true {
            isMusicInterrupted = false
        }
    }
}

