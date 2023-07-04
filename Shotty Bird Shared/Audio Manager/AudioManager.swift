//
//  AudioManager.swift
//  Shotty Bird Shared
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import AVFoundation

class AudioManager: NSObject {
    
    private(set) var session: AVAudioSession?
    private(set) var player: AVAudioPlayer?
    
    private(set) var musicPlaying = false
    private(set) var musicInterrupted = false
    
    init(file:String?, type:String?, loop: Bool) {
        super.init()
        configureAudioSession()
        configureAudioPlayer(file: file, type: type, loop: loop)
    }
    
    func tryPlayMusic() {
        if session?.isOtherAudioPlaying == false {
            player?.prepareToPlay()
            player?.play()
            musicPlaying = true
        }
    }
    
    func stopMusic() {
        if musicPlaying {
            player?.stop()
        }
    }
    
    // MARK: - Audio session and player setup
    
    private func configureAudioSession() {
        session = AVAudioSession.sharedInstance()
        if session?.isOtherAudioPlaying == true {
            do {
                try session?.setCategory(.playback)
                musicPlaying = false
            } catch {
                print("Error setting category: \(error.localizedDescription)")
            }
        } else {
            do {
                try session?.setCategory(.playback)
                musicPlaying = false
            } catch {
                print("Error setting category: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureAudioPlayer(file: String?, type: String?, loop: Bool) {
        guard let backgroundMusicPath = Bundle.main.path(forResource: file, ofType: type) else {
            return
        }
        do {
            let backgroundMusicURL = URL(fileURLWithPath: backgroundMusicPath)
            try player = AVAudioPlayer(contentsOf: backgroundMusicURL)
            player?.delegate = self
            player?.numberOfLoops = loop ? -1 : 0
        } catch {
            print("Error when trying to setup the audio player: \(error.localizedDescription)")
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        musicInterrupted = true
        musicPlaying = false
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        tryPlayMusic()
        musicInterrupted = false
    }
}
