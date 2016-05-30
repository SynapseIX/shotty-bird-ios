//
//  GameCenterHelper.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/19/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import GameKit

class GameCenterHelper: NSObject {

    var gameCenterEnabled = false
    
    // Leaderboards
    var leaderboard = GKLeaderboard()
    
    // Achievements
    var shot0 = Achievement(identifier: "co.profapps.Shotty_Bird.achievement.x0", percentComplete: 0.0, unlocked: false)
    var shot50 = Achievement(identifier: "co.profapps.Shotty_Bird.achievement.x50", percentComplete: 0.0, unlocked: false)
    var shot100 = Achievement(identifier: "co.profapps.Shotty_Bird.achievement.x100", percentComplete: 0.0, unlocked: false)
    var shot150 = Achievement(identifier: "co.profapps.Shotty_Bird.achievement.x150", percentComplete: 0.0, unlocked: false)
    var shot200 = Achievement(identifier: "co.profapps.Shotty_Bird.achievement.x200", percentComplete: 0.0, unlocked: false)
    var shot250 = Achievement(identifier: "co.profapps.Shotty_Bird.achievement.x250", percentComplete: 0.0, unlocked: false)
    var shot300 = Achievement(identifier: "co.profapps.Shotty_Bird.achievement.x300", percentComplete: 0.0, unlocked: false)
    var sniper = Achievement(identifier: "co.profapps.Shotty_Bird.achievement.sniper", percentComplete: 0.0, unlocked: false)
    
    func authenticateLocalPlayer(presentingViewController: UIViewController?, completion: ((success: Bool) -> Void)?) {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { (viewController, error) in
            if let viewController = viewController {
                presentingViewController?.presentViewController(viewController, animated: true, completion: nil)
            } else if localPlayer.authenticated {
                self.gameCenterEnabled = true
                
                // Load leaderboard
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (identifier, error) in
                    if let error = error {
                        NSLog("Error loading leaderboard: \(error.localizedDescription)", error)
                    } else {
                        self.leaderboard.identifier = identifier
                        
                        // Load player's highest score
                        self.loadPlayerHighestScore { (score) in
                            print("Players highest score: \(score?.value)")
                        }
                    }
                    
                    // Load achievements
                    GKAchievement.loadAchievementsWithCompletionHandler { (achievements, error) in
                        if let error = error {
                            NSLog("Error loading achievements: \(error.localizedDescription)", error)
                        }
                        
                        if let achievements = achievements {
                            for achievement in achievements {
                                if let identifier = achievement.identifier {
                                    switch identifier {
                                    case "co.profapps.Shotty_Bird.achievement.x0":
                                        self.shot0.identifier = identifier
                                        self.shot0.percentComplete = achievement.percentComplete
                                        self.shot0.unlocked = achievement.completed
                                    case "co.profapps.Shotty_Bird.achievement.x50":
                                        self.shot50.identifier = identifier
                                        self.shot50.percentComplete = achievement.percentComplete
                                        self.shot50.unlocked = achievement.completed
                                    case "co.profapps.Shotty_Bird.achievement.x100":
                                        self.shot100.identifier = identifier
                                        self.shot100.percentComplete = achievement.percentComplete
                                        self.shot100.unlocked = achievement.completed
                                    case "co.profapps.Shotty_Bird.achievement.x150":
                                        self.shot150.identifier = identifier
                                        self.shot150.percentComplete = achievement.percentComplete
                                        self.shot150.unlocked = achievement.completed
                                    case "co.profapps.Shotty_Bird.achievement.x200":
                                        self.shot200.identifier = identifier
                                        self.shot200.percentComplete = achievement.percentComplete
                                        self.shot200.unlocked = achievement.completed
                                    case "co.profapps.Shotty_Bird.achievement.x250":
                                        self.shot250.identifier = identifier
                                        self.shot250.percentComplete = achievement.percentComplete
                                        self.shot250.unlocked = achievement.completed
                                    case "co.profapps.Shotty_Bird.achievement.x300":
                                        self.shot300.identifier = identifier
                                        self.shot300.percentComplete = achievement.percentComplete
                                        self.shot300.unlocked = achievement.completed
                                    case "co.profapps.Shotty_Bird.achievement.sniper":
                                        self.sniper.identifier = identifier
                                        self.sniper.percentComplete = achievement.percentComplete
                                        self.sniper.unlocked = achievement.completed
                                    default:
                                        break
                                    }
                                }
                            }
                            
                            completion?(success: true)
                        }
                    }
                })
            } else {
                self.gameCenterEnabled = false
                completion?(success: false)
            }
        }
    }
    
    // MARK: - Leaderboard methods
    
    func presentLeaderboard() {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = .Leaderboards
        gameCenterViewController.leaderboardIdentifier = leaderboard.identifier
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let gameViewController = appDelegate.window?.rootViewController
        gameViewController?.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func submitScore(scoreToSubmit: Int64, completion: ((success: Bool) -> Void)?) {
        if let leaderboardIdentifier = leaderboard.identifier {
            let score = GKScore(leaderboardIdentifier: leaderboardIdentifier)
            score.value = scoreToSubmit
            
            GKScore.reportScores([score]) { (error: NSError?) in
                if let error = error {
                    NSLog("Error: \(error.localizedDescription)", error)
                    completion?(success: false)
                } else {
                    completion?(success: true)
                }
            }
        }
    }
    
    func loadPlayerHighestScore(completion: ((score: GKScore?) -> Void)?) {
        leaderboard.playerScope = .FriendsOnly
        leaderboard.timeScope = .AllTime
        leaderboard.range = NSMakeRange(1, 1)
        leaderboard.loadScoresWithCompletionHandler { (scores, error) in
            if let error = error {
                NSLog("Error loading scores: \(error.localizedDescription)", error)
                completion?(score: nil)
            } else {
                completion?(score: self.leaderboard.localPlayerScore)
            }
        }
    }
    
    // MARK: - Achievement methods
    
    func reportAchievement(identifier: String?, percentComplete: Double, showsCompletionBanner: Bool) {
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = showsCompletionBanner
        
        GKAchievement.reportAchievements([achievement]) { (error) in
            if let error = error {
                NSLog("Error reporting achievement: \(error.localizedDescription)", error)
            }
            
            if let identifier = achievement.identifier {
                switch identifier {
                case "co.profapps.Shotty_Bird.achievement.x0":
                    self.shot0.identifier = identifier
                    self.shot0.percentComplete = achievement.percentComplete
                    self.shot0.unlocked = achievement.completed
                case "co.profapps.Shotty_Bird.achievement.x50":
                    self.shot50.identifier = identifier
                    self.shot50.percentComplete = achievement.percentComplete
                    self.shot50.unlocked = achievement.completed
                case "co.profapps.Shotty_Bird.achievement.x100":
                    self.shot100.identifier = identifier
                    self.shot100.percentComplete = achievement.percentComplete
                    self.shot100.unlocked = achievement.completed
                case "co.profapps.Shotty_Bird.achievement.x150":
                    self.shot150.identifier = identifier
                    self.shot150.percentComplete = achievement.percentComplete
                    self.shot150.unlocked = achievement.completed
                case "co.profapps.Shotty_Bird.achievement.x200":
                    self.shot200.identifier = identifier
                    self.shot200.percentComplete = achievement.percentComplete
                    self.shot200.unlocked = achievement.completed
                case "co.profapps.Shotty_Bird.achievement.x250":
                    self.shot250.identifier = identifier
                    self.shot250.percentComplete = achievement.percentComplete
                    self.shot250.unlocked = achievement.completed
                case "co.profapps.Shotty_Bird.achievement.x300":
                    self.shot300.identifier = identifier
                    self.shot300.percentComplete = achievement.percentComplete
                    self.shot300.unlocked = achievement.completed
                case "co.profapps.Shotty_Bird.achievement.sniper":
                    self.sniper.identifier = identifier
                    self.sniper.percentComplete = achievement.percentComplete
                    self.sniper.unlocked = achievement.completed
                default:
                    break
                }
            }
        }
    }
    
}

// MARK: - Game Center view controller delegate

extension GameCenterHelper: GKGameCenterControllerDelegate {

    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
