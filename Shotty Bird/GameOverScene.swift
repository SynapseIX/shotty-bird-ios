//
//  GameOverScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/11/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit
import GameKit
import Social

class GameOverScene: SKScene {
    
    var score = 0
    var bgLayers = [String]()
    var parallaxBackground: ParallaxBackground?
    var newBest = false
    
    let audioManager = AudioManager(file: "game_over_music", type: "mp3", loop: false)
    var muted = false
    
    let zPositionBg = CGFloat(-1)
    let zPositionMenuItems = CGFloat(Int.max)
    
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    let playScreenshotSoundAction = SKAction.playSoundFileNamed("screenshot.wav", waitForCompletion: true)

    override func didMoveToView(view: SKView) {
        audioManager.audioPlayer?.volume = !muted ? 1.0 : 0.0
        audioManager.tryPlayMusic()
        
        // Show AdMob banner
        let gameViewController = view.window?.rootViewController as! GameViewController
        gameViewController.bannerView.hidden = false
        
        // Add background
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgLayers, size: size, fastestSpeed: 2.0, speedDecrease: 0.6)
        addChild(parallaxBackground!)
        
        // Add score panel
        let panel = SKSpriteNode(imageNamed: "score_panel")
        panel.xScale = 0.8
        panel.yScale = 0.6
        panel.zPosition = zPositionMenuItems
        panel.zPosition = zPositionMenuItems - 0.01
        panel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        
        addChild(panel)
        
        // Add score label
        let scoreLabel = ASAttributedLabelNode(size: panel.size)
        scoreLabel.zPosition = zPositionMenuItems
        scoreLabel.position = CGPoint(x: CGRectGetMidX(panel.frame), y: CGRectGetMidY(panel.frame))
        
        if let font =  UIFont(name: "Kenney-Bold", size: 80) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Center
            
            let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName: UIColor.whiteColor(),
                              NSStrokeColorAttributeName: UIColor.blackColor(), NSStrokeWidthAttributeName: -10, NSParagraphStyleAttributeName: paragraphStyle]
            
            scoreLabel.attributedString = NSAttributedString(string: "\(score)", attributes: attributes)
        }
        
        addChild(scoreLabel)
        
        // Add best score label
        let defaults = NSUserDefaults.standardUserDefaults()
        let bestScore = defaults.integerForKey("bestScore")
        
        // Synchronize high scores with Game Center
        let gameCenterHelper = gameViewController.gameCenterHelper
        
        if let score = gameCenterHelper.fetchPlayerScore() {
            if Int(score.value) > bestScore {
                defaults.setInteger(Int(score.value), forKey: "bestScore")
                defaults.synchronize()
            } else {
                // Submit high score to Game Center
                gameCenterHelper.submitScore(bestScore)
            }
        }
        
        if score > bestScore {
            newBest = true
            defaults.setInteger(score, forKey: "bestScore")
            defaults.synchronize()
            
            // Submit high score to Game Center
            gameCenterHelper.submitScore(score)
        }
        
        let bestScoreText = newBest ? "NEW RECORD" : "Your best is \(defaults.integerForKey("bestScore"))"
        let bestScoreLabel = SKLabelNode(text: bestScoreText)
        bestScoreLabel.fontName = "Kenney-Bold"
        bestScoreLabel.fontSize = 17.0
        bestScoreLabel.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        bestScoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(panel.frame) + 20)
        bestScoreLabel.zPosition = zPositionMenuItems
        addChild(bestScoreLabel)
        
        // Add game over node
        let gameOver = SKSpriteNode(imageNamed: "game_over")
        gameOver.name = "gameOver"
        gameOver.setScale(0.8)
        gameOver.zPosition = zPositionMenuItems
        gameOver.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(panel.frame) + gameOver.size.height - 30)
        addChild(gameOver)
        
        // Add leaderboard button
        let leaderboardButton = SKSpriteNode(imageNamed: "leaderboard_button_icon")
        leaderboardButton.position = CGPoint(x: CGRectGetMidX(panel.frame), y: CGRectGetMinY(panel.frame) - leaderboardButton.size.height / 2 - 10)
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.zPosition = zPositionMenuItems
        addChild(leaderboardButton)
        
        // Add replay button
        let playButton = SKSpriteNode(imageNamed: "replay_button")
        playButton.position = CGPoint(x: leaderboardButton.position.x - playButton.size.width - 20, y: leaderboardButton.position.y)
        playButton.name = "playButton"
        playButton.zPosition = zPositionMenuItems
        addChild(playButton)
        
        // Add back button
        let backButton = SKSpriteNode(imageNamed: "back_button")
        backButton.position = CGPoint(x: playButton.position.x - backButton.size.width - 20, y: leaderboardButton.position.y)
        backButton.name = "backButton"
        backButton.zPosition = zPositionMenuItems
        addChild(backButton)
        
        // Add twitter button
        let twitterButton = SKSpriteNode(imageNamed: "twitter_button")
        twitterButton.position = CGPoint(x: leaderboardButton.position.x + twitterButton.size.width + 20, y: leaderboardButton.position.y)
        twitterButton.name = "twitterButton"
        twitterButton.zPosition = zPositionMenuItems
        addChild(twitterButton)
        
        // Add facebook button
        let facebookButton = SKSpriteNode(imageNamed: "facebook_button")
        facebookButton.position = CGPoint(x: twitterButton.position.x + twitterButton.size.width + 20, y: leaderboardButton.position.y)
        facebookButton.name = "facebookButton"
        facebookButton.zPosition = zPositionMenuItems
        addChild(facebookButton)
        
        // Report achievements
        reportAchievements()
    }
    
    override func update(currentTime: NSTimeInterval) {
        parallaxBackground?.update()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let gameViewController = view?.window?.rootViewController as! GameViewController
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let backButton = childNodeWithName("backButton") {
                if backButton.containsPoint(location) {
                    // Hide AdMob banner
                    gameViewController.bannerView.hidden = true
                    
                    if !muted {
                        backButton.runAction(playBirdSoundAction)
                    }
                    
                    audioManager.stopMusic()
                    let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
                    view?.presentScene(getMainMenuScene(), transition: transition)
                }
            }
            
            if let playButton = childNodeWithName("playButton") {
                if playButton.containsPoint(location) {
                    // Hide AdMob banner
                    gameViewController.bannerView.hidden = true
                    
                    if let gameScene = getGameScene() {
                        gameScene.muted = muted
                        gameScene.bgLayers = bgLayers
                        
                        if !muted {
                            playButton.runAction(playExplosionSoundAction)
                        }
                        
                        audioManager.stopMusic()
                        let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
                        view?.presentScene(gameScene, transition: transition)
                    }
                }
            }
            
            if let leaderboardButton = childNodeWithName("leaderboardButton") {
                if leaderboardButton.containsPoint(location) {
                    if !muted {
                        leaderboardButton.runAction(playBirdSoundAction)
                    }
                    
                    let gameViewController = view?.window?.rootViewController as! GameViewController
                    let gameCenterHelper = gameViewController.gameCenterHelper
                    
                    if gameCenterHelper.gameCenterEnabled {
                        gameCenterHelper.presentLeaderboard(gameViewController)
                    } else {
                        gameCenterHelper.authenticateLocalPlayer(gameViewController) {
                            gameCenterHelper.presentLeaderboard(gameViewController)
                        }
                    }
                }
            }
            
            if let twitterButton = childNodeWithName("twitterButton") {
                if twitterButton.containsPoint(location) {
                    if !muted {
                        twitterButton.runAction(playScreenshotSoundAction)
                    }
                    
                    shareOnTwitter()
                }
            }
            
            if let facebookButton = childNodeWithName("facebookButton") {
                if facebookButton.containsPoint(location) {
                    if !muted {
                        facebookButton.runAction(playScreenshotSoundAction)
                    }
                    
                    shareOnFacebook()
                }
            }
        }
    }
    
    // MARK: - User interface methods
    
    private func getMainMenuScene() -> MainMenuScene {
        // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
        let scene = MainMenuScene(size: CGSize(width: 1024.0, height: 768.0))
        scene.muted = muted
        scene.scaleMode = .AspectFill
        
        return scene
    }
    
    private func getGameScene() -> GameScene? {
        if let scene = GameScene(fileNamed:"GameScene") {
            scene.scaleMode = .AspectFill
            return scene
        }
        
        return nil
    }
    
    // MARK: - Social methods
    
    private func shareOnTwitter() {
        let gameViewController = view?.window?.rootViewController as! GameViewController
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterController.addImage(takeScreenshot())
            twitterController.addURL(NSURL(string: "https://itunes.apple.com/us/app/shotty-bird/id1114259560?ls=1&mt=8"))
            twitterController.setInitialText("Becoming the best bird slayer at @shottybird. Available on the App Store.")
            twitterController.completionHandler = { (result) in
                twitterController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            gameViewController.presentViewController(twitterController, animated: true, completion: nil)
        } else {
            GameError.handleAsAlert("Sign in to Twitter", message: "You are not signed in with Twitter. On the Home screen, launch Settings, tap Twitter, and sign in to your account.", presentingViewController: gameViewController, completion: nil)
        }
    }
    
    private func shareOnFacebook() {
        let gameViewController = view?.window?.rootViewController as! GameViewController
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let facebookController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookController.addImage(takeScreenshot())
            facebookController.completionHandler = { (result) in
                facebookController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            gameViewController.presentViewController(facebookController, animated: true, completion: nil)
        } else {
            GameError.handleAsAlert("Sign in to Facebook", message: "You are not signed in with Facebook. On the Home screen, launch Settings, tap Facebook, and sign in to your account.", presentingViewController: gameViewController, completion: nil)
        }
    }
    
    private func takeScreenshot() -> UIImage {
        let gameViewController = view?.window?.rootViewController as! GameViewController
        gameViewController.bannerView.hidden = true
        
        UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.mainScreen().scale)
        view?.drawViewHierarchyInRect(frame, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        gameViewController.bannerView.hidden = false
        return screenshot
    }
    
    // MARK: - Achievement methods
    
    private func reportAchievements() {
        if score == 0 {
            let achievement = GKAchievement(identifier: "co.profapps.Shotty_Bird.achievement.x0")
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement], withCompletionHandler: nil)
        } else {
            // Report achievement progress
            let x50 = GKAchievement(identifier: "co.profapps.Shotty_Bird.achievement.x50")
            x50.showsCompletionBanner = true
            
            let x100 = GKAchievement(identifier: "co.profapps.Shotty_Bird.achievement.x100")
            x100.showsCompletionBanner = true
            
            let x150 = GKAchievement(identifier: "co.profapps.Shotty_Bird.achievement.x150")
            x150.showsCompletionBanner = true
            
            let x200 = GKAchievement(identifier: "co.profapps.Shotty_Bird.achievement.x200")
            x200.showsCompletionBanner = true
            
            let x300 = GKAchievement(identifier: "co.profapps.Shotty_Bird.achievement.x300")
            x300.showsCompletionBanner = true
            
            x50.percentComplete = Double(score * 100 / 50)
            x100.percentComplete = Double(score * 100 / 100)
            x150.percentComplete = Double(score * 100 / 150)
            x200.percentComplete = Double(score * 100 / 200)
            x300.percentComplete = Double(score * 100 / 300)
            
            GKAchievement.reportAchievements([x50, x100, x150, x200, x300], withCompletionHandler: nil)
        }
    }
    
}
