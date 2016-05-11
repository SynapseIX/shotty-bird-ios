//
//  AudioManager.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/10/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import AVFoundation

class AudioManager: NSObject {
    
    var audioSession: AVAudioSession?
    var audioPlayer: AVAudioPlayer?
    
    var musicPlaying = false
    var musicInterrupted = false
    
    init(file:String?, type:String?, loop: Bool) {
        super.init()
        
        configureAudioSession()
        configureAudioPlayer(file, type: type, loop: loop)
    }
    
    func tryPlayMusic() {
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        musicPlaying = true
    }
    
    func stopMusic() {
        if musicPlaying {
            audioPlayer?.stop()
        }
    }
    
    // MARK: - Audio session and player setup
    
    private func configureAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        
        if let audioSession = audioSession {
            if audioSession.otherAudioPlaying {
                do {
                    try audioSession.setCategory(AVAudioSessionCategorySoloAmbient)
                    musicPlaying = false
                } catch let error as NSError {
                    NSLog("Error setting category: \(error.userInfo)")
                }
            } else {
                do {
                    try audioSession.setCategory(AVAudioSessionCategoryAmbient)
                    musicPlaying = false
                } catch let error as NSError {
                    NSLog("Error setting category: \(error.userInfo)")
                }
            }
        }
    }
    
    private func configureAudioPlayer(file: String?, type: String?, loop: Bool) {
        let backgroundMusicPath = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let backgroundMusicURL = NSURL(fileURLWithPath: backgroundMusicPath!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL)
            
            if let audioPlayer = audioPlayer {
                audioPlayer.delegate = self
                audioPlayer.numberOfLoops = loop ? -1 : 0
            }
        } catch let error as NSError {
            NSLog("Error when trying to setup the audio player: \(error.userInfo)")
        }
    }
}

// MARK: - Audio player delegate

extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        musicInterrupted = true
        musicPlaying = false
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        tryPlayMusic()
        musicInterrupted = false
    }
    
}

