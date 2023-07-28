//
//  GameCenterHelper.swift
//  Shotty Bird iOS
//
//  Created by Jorge Tapia on 7/28/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import GameKit

/// Helper class that provide Game Center functionality.
class GameCenterHelper: NSObject {
    
    /// Shared helper instance.
    static let shared = GameCenterHelper()
    
    /// Determines if Game Center is enabled.
    private(set) var isGameCenterEnabled = false
    
    /// Available achievements.
    private(set) var achievements: [GKAchievement] = []
    /// Available leaderboards.
    private(set) var leaderboards: [GKLeaderboard] = []
    
    private override init() {
        super.init()
    }
    
    /// Authenticates the player with Game Center.
    /// - Parameters:
    ///   - presentingViewController: The view controller that will present the Game Center view controller.
    ///   - completionHandler: Closure with the status of the player authentication.
    func authenticateLocalPlayer(presentingViewController: UIViewController?, completionHandler: ((_ success: Bool) -> Void)?) {
        let player = GKLocalPlayer.local
        player.authenticateHandler = { viewController, error in
            if player.isAuthenticated {
                // Load leaderboards
                // TODO: load time attack
                let IDs = ["shotty_bird_leaderboard"]
                GKLeaderboard.loadLeaderboards(IDs: IDs) { leaderboards, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let leaderboards = leaderboards else {
                        return
                    }
                    self.leaderboards = leaderboards
                }
                
                // Load achievements
                GKAchievement.loadAchievements() { achievements, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let achievements = achievements else {
                        return
                    }
                    self.achievements = achievements
                }
                
                self.isGameCenterEnabled = true
                completionHandler?(true)
            } else {
                self.isGameCenterEnabled = false
                completionHandler?(false)
            }
        }
    }
    
    func presentLeaderboard(for mode: GameMode) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
//        var leaderboardIdentifier: String
//        switch mode {
//        case .slayer:
//            leaderboardIdentifier = "shotty_bird_leaderboard"
//        case .timeAttack:
//            leaderboardIdentifier = "shotty_bird_time_attack_leaderboard"
//        default:
//            leaderboardIdentifier = "shotty_bird_leaderboard"
//        }
//        guard let leaderboard = leaderboards.first(where: { $0.baseLeaderboardID == leaderboardIdentifier }) else {
//            return
//        }
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self
        let rootViewController = appDelegate.window?.rootViewController
        rootViewController?.present(gameCenterVC, animated: true, completion: nil)
    }
}

// MARK: - GKGameCenterControllerDelegate

extension GameCenterHelper: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

