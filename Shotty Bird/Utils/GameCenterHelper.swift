//
//  GameCenterHelper.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/19/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import GameKit

class GameCenterHelper: NSObject {

    var leaderboardIdentifier: String?
    var gameCenterEnabled = false
    
    func authenticateLocalPlayer(presentingViewController: UIViewController, completion: (() -> Void)?) {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { (viewController, error) in
            if let viewController = viewController {
                presentingViewController.presentViewController(viewController, animated: true, completion: nil)
            } else if localPlayer.authenticated {
                self.gameCenterEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (identifier, error) in
                    if let error = error {
                        dispatch_async(dispatch_get_main_queue()) {
                            GameError.handleAsAlert("Ooops!", message: error.localizedDescription, presentingViewController: presentingViewController, completion: nil)
                        }
                        
                        return
                    }
                    
                    self.leaderboardIdentifier = identifier
                    completion?()
                })
            } else {
                self.gameCenterEnabled = false
            }
        }
    }
    
    func presentLeaderboard(presentingViewController: UIViewController) {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = .Leaderboards
        gameCenterViewController.leaderboardIdentifier = leaderboardIdentifier
        
        presentingViewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func submitScore(scoreToSubmit: Int) {
        if let leaderboardIdentifier = leaderboardIdentifier {
            let score = GKScore(leaderboardIdentifier: leaderboardIdentifier)
            score.value = Int64(scoreToSubmit)
            
            GKScore.reportScores([score]) { (error: NSError?) in
                if let error = error {
                    NSLog("Error: \(error.localizedDescription)", error)
                }
            }
        }
    }
    
    func fetchPlayerScore() -> GKScore? {
        let leaderboard = GKLeaderboard()
        leaderboard.identifier = leaderboardIdentifier
        return leaderboard.localPlayerScore
    }
    
}

// MARK: - Game Center view controller delegate

extension GameCenterHelper: GKGameCenterControllerDelegate {

    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
