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
    // MARK: - Store manager
    static let purchased = "You've successfully bought this purchase!"
    static let purchasedAlready = "You've already purchased this product!\nEnjoy ad-free gaming and 1 permanent extra life on Slayer mode.\nYou can restore your purchase by tapping the Restore Purchase button. Thank you!"
    static let purchaseRestored = "Your purchase has been restored. You're all set!"
    static let purchasesDisabled = "Purchases are disabled on your device."
    static let purchaseFailed = "An error has ocurred with this purchase. Please try again later."
    
    
    // MARK: - Game Over scene
    static let scored0 = "Lead your shots and try again"
    static let yourBestScoreFormat = "Your best score is %d"
    static let newRecord = "NEW RECORD"
    
    // MARK: Game Center
    static let x0 = "co.profapps.Shotty_Bird.achievement.x0"
    static let x50 = "co.profapps.Shotty_Bird.achievement.x50"
    static let x100 = "co.profapps.Shotty_Bird.achievement.x100"
    static let x150 = "co.profapps.Shotty_Bird.achievement.x150"
    static let x200 = "co.profapps.Shotty_Bird.achievement.x200"
    static let x250 = "co.profapps.Shotty_Bird.achievement.x250"
    static let x300 = "co.profapps.Shotty_Bird.achievement.x300"
    static let x500 = "co.profapps.Shotty_Bird.achievement.x500"
    static let sniper = "co.profapps.Shotty_Bird.sniper"
    static let slayerLeaderboardID = "shotty_bird_leaderboard"
    static let timeAttackLeaderboardID = "shotty_bird_time_attack_leaderboard"
    
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

