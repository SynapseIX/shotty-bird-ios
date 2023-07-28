//
//  Constants.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/26/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import UIKit

/// Defines constants used across the game.
struct Constants {
    // MARK: - Sharing the game
    /// The text copy used when tapping the share button.
    static let shareText = "Shotty Bird is free to download and play! Brace yourself for the challenge of your life! Become the world's top slayer by shooting down birds, unlocking achievements, and climbing up the ladder. Available on the  App Store."
    /// URL to use when tapping the share button.
    static let shareURL = URL(string: "https://komodo.life")!
    /// Share slayer score text with format.
    static let shareSlayerScoreText = "I slayed %d birds in Shotty Bird! Can you beat my score? Download now for FREE.\n\(shareURL.absoluteString)\n#HappySlaying"
    /// Share slayer score text with format.
    static let shareTimeAttackScoreText = "I slayed %d birds in Shotty Bird in 1 minute! Can you beat my score? Download now for FREE.\n\(shareURL.absoluteString)\n#HappySlaying"
    /// The app icon image to use when sharing the game.
    static let appIconImage = UIImage(named: "AppIcon")!
}

