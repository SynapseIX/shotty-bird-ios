//
//  AudioManager.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/25/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import Foundation

protocol AudioManager {
    /// Attempts to play the audio file selected during initialization.
    func tryPlayMusic()
    /// Stops music playback.
    func stopMusic()
    /// Toggles audio player mute state.
    func toggleMute()
}
