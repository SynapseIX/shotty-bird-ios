//
//  GameCenterHelper.swift
//  Shotty Bird iOS
//
//  Created by Jorge Tapia on 7/28/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import GameKit

/// Helper class that provide Game Center functionality.
final class GameCenterHelper: NSObject {
    
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
                let IDs = [Constants.slayerLeaderboardID, Constants.timeAttackLeaderboardID]
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
    
    /// Gets a leaderboard object that matches the given leaderboard base ID.
    /// - Parameter baseLeaderboardID: The base ID.
    /// - Returns: A leaderboard object.
    func getLeaderboard(with baseLeaderboardID: String) -> GKLeaderboard? {
        leaderboards.first(where: { $0.baseLeaderboardID == baseLeaderboardID })
    }
    
    /// Gets an achievement object that matches the given identifier.
    /// - Parameter baseLeaderboardID: The achievement identifier.
    /// - Returns: An achievement object.
    func getAchievement(with identifier: String) -> GKAchievement? {
        achievements.first(where: { $0.identifier == identifier })
    }
    
    /// Presents a Game Center view controller displaying a leaderboard for a given game mode.
    /// - Parameter mode: The game mode for which a leadeboard should be displayed.
    func presentLeaderboard(for mode: GameMode) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        var leaderboardID: String
        switch mode {
        case .slayer:
            leaderboardID = Constants.slayerLeaderboardID
        case .timeAttack:
            leaderboardID = Constants.timeAttackLeaderboardID
        default:
            leaderboardID = Constants.slayerLeaderboardID
        }
        let gameCenterVC = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .global, timeScope: .allTime)
        gameCenterVC.gameCenterDelegate = self
        let rootViewController = appDelegate.window?.rootViewController
        rootViewController?.present(gameCenterVC, animated: true, completion: nil)
    }
    
    /// Presents the Game Center view controller.
    func presentGameCenterViewController() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self
        let rootViewController = appDelegate.window?.rootViewController
        rootViewController?.present(gameCenterVC, animated: true, completion: nil)
    }
    
    // MARK: - Achievement methods
    
    /// Reports achievement progress.
    /// - Parameters:
    ///   - identifier: The achievement identifier.
    ///   - percentComplete: Achievement percent completed.
    ///   - showsCompletionBanner: Flag to determine if a Game Center banner should be displayed upon completion.
    func reportAchievement(identifier: String, percentComplete: Double, showsCompletionBanner: Bool) {
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = showsCompletionBanner
        
        if achievement.percentComplete < 100 {
            GKAchievement.report([achievement]) { (error) in
                if let error = error {
                    print("Error reporting achievement: \(error.localizedDescription)", error)
                    return
                }
                print("Achievement \(identifier) reported")
            }
        } else {
            print("Achievement \(identifier) already unlocked")
        }
    }
    
    // MARK: - Score submission
    
    /// Submits a score to a leaderboard.
    /// - Parameters:
    ///   - score: The score to be submitted.
    ///   - mode: The game mode for which a leaderboard should be updated.
    ///   - completionHandler: Score submission completion handler.
    func submitScore(_ score: Int, for mode: GameMode, completionHandler: ((_ success: Bool) -> Void)?) {
        var leaderboardID: String
        switch mode {
        case .slayer:
            leaderboardID = Constants.slayerLeaderboardID
        case .timeAttack:
            leaderboardID = Constants.timeAttackLeaderboardID
        default:
            leaderboardID = Constants.slayerLeaderboardID
        }
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler?(false)
                return
            }
            completionHandler?(true)
        }
    }
}

// MARK: - GKGameCenterControllerDelegate

extension GameCenterHelper: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

