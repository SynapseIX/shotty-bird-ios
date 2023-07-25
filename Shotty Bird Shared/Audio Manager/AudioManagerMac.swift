//
//  AudioManagerMac.swift
//  Shotty Bird macOS
//
//  Created by Jorge Tapia on 7/25/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import Foundation

/// Audio manager class to control game music playback on macOS.
@available(iOS 16.4, *)
class AudioManagerMac {
    var isMuted: Bool {
        false
    }
}

// MARK: - AudioManager

extension AudioManagerMac: AudioManager {
    func tryPlayMusic() {
        // TODO: implement
    }
    
    func stopMusic() {
        // TODO: implement
    }
    
    func toggleMute() {
        // TODO: implement
    }
}

