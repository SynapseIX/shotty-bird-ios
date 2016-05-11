//
//  MainMenuScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/10/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit
import Social

class MainMenuScene: SKScene {
    
    let audioManager = AudioManager(file: "menu_music", type: "wav", loop: true)
    var muted = false
    
    let zPositionBg = CGFloat(-1)
    let zPositionMenuItems = CGFloat(Int.max)
    
    override func didMoveToView(view: SKView) {
        audioManager.audioPlayer?.volume = !muted ? 1.0 : 0.0
        audioManager.tryPlayMusic()
        setupUI()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // TODO: handle button touches
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let playButton = childNodeWithName("playButton") {
                if playButton.containsPoint(location) {
                    if let gameScene = getGameScene() {
                        // TODO: validate if it need to show tutorial scene
                        audioManager.stopMusic()
                        gameScene.muted = muted
                        
                        if !muted {
                            playButton.runAction(GameAction.playExplosionSoundAction)
                        }
                    
                        let transition = SKTransition.crossFadeWithDuration(1.0)
                        view?.presentScene(gameScene, transition: transition)
                    }
                }
            }
            
            if let leaderboardButton = childNodeWithName("leaderboardButton") {
                if leaderboardButton.containsPoint(location) {
                    // TODO: Handle leaderboard button tap
                    if !muted {
                        leaderboardButton.runAction(GameAction.playBirdSoundAction)
                    }
                    print("Leaderboard button tapped")
                }
            }
            
            if let creditsButton = childNodeWithName("creditsButton") {
                if creditsButton.containsPoint(location) {
                    // TODO: Handle leaderboard button tap
                    if !muted {
                        creditsButton.runAction(GameAction.playBirdSoundAction)
                    }
                    
                    print("Credits button tapped")
                }
            }
            
            if let twitterButton = childNodeWithName("twitterButton") {
                if twitterButton.containsPoint(location) {
                    if !muted {
                        twitterButton.runAction(GameAction.playBirdSoundAction)
                    }
                    
                    shareOnTwitter()
                }
            }
            
            if let facebookButton = childNodeWithName("facebookButton") {
                if facebookButton.containsPoint(location) {
                    facebookButton.runAction(GameAction.playBirdSoundAction)
                    shareOnFacebook()
                }
            }
            
            if let muteButton = childNodeWithName("muteButton") {
                if muteButton.containsPoint(location) {
                    audioManager.audioPlayer?.volume = muted ? 1.0 : 0.0
                    muted = audioManager.audioPlayer?.volume == 0.0 ? true : false
                    
                    // TODO: change node texture accordingly
                }
            }
        }
    }
    
    // MARK: - UI methods
    
    private func setupUI() {
        // TODO: implement parallax scrolling background
        // Add background
        let background = SKSpriteNode(imageNamed: "background")
        
        if DeviceModel.iPad {
            background.xScale = 0.7
            background.yScale = 0.7
        } else if DeviceModel.iPhone4 {
            background.xScale = 0.65
            background.yScale = 0.65
        } else {
            background.xScale = 0.55
            background.yScale = 0.55
        }
        
        background.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        background.zPosition = zPositionBg
        addChild(background)
        
        // Add and scale game logo
        let logo = SKSpriteNode(imageNamed: "logo_large")
        
        if DeviceModel.iPad {
            logo.xScale = 0.75
            logo.yScale = 0.75
        } else {
            logo.xScale = 0.65
            logo.yScale = 0.65
        }
        
        let logoY = DeviceModel.iPad ? CGRectGetMaxY(frame) - CGFloat(logo.size.height) / 2 - 30 : CGRectGetMaxY(frame) - CGFloat(logo.size.height) - 30
        logo.position = CGPoint(x: CGRectGetMidX(frame), y: logoY)
        logo.zPosition = zPositionMenuItems
        addChild(logo)
        
        // Add play button
        let playButton = SKSpriteNode(imageNamed: "play_button")
        
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            playButton.xScale = 0.75
            playButton.yScale = 0.75
        }
        
        playButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        playButton.name = "playButton"
        playButton.zPosition = zPositionMenuItems
        addChild(playButton)
        
        // Add leaderboard button
        let leaderboardButton = SKSpriteNode(imageNamed: "leaderboard_button")
        
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            leaderboardButton.xScale = 0.75
            leaderboardButton.yScale = 0.75
        }
        
        leaderboardButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - leaderboardButton.size.height - 10)
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.zPosition = zPositionMenuItems
        addChild(leaderboardButton)
        
        // Add credits button
        let creditsButton = SKSpriteNode(imageNamed: "credits_button")
        
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            creditsButton.xScale = 0.75
            creditsButton.yScale = 0.75
        }
        
        creditsButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - (leaderboardButton.size.height * 2) - 20)
        creditsButton.name = "creditsButton"
        creditsButton.zPosition = zPositionMenuItems
        addChild(creditsButton)
        
        // Add Twitter button
        let twitterButton = SKSpriteNode(imageNamed: "twitter_button")
        
        if DeviceModel.iPhone4 {
            twitterButton.position = CGPoint(x: CGRectGetMinX(frame) + twitterButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + twitterButton.size.height + 20)
        } else if DeviceModel.iPad {
            twitterButton.position = CGPoint(x: CGRectGetMinX(frame) + twitterButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + twitterButton.size.height - 20)
        } else {
            twitterButton.position = CGPoint(x: CGRectGetMinX(frame) + twitterButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + twitterButton.size.height * 2)
        }
        
        twitterButton.name = "twitterButton"
        twitterButton.zPosition = zPositionMenuItems
        addChild(twitterButton)
        
        // Add Facebook button
        let facebookButton = SKSpriteNode(imageNamed: "facebook_button")
        
        if DeviceModel.iPhone4 {
            facebookButton.position = CGPoint(x: CGRectGetMinX(frame) + twitterButton.size.width * 2 + 5, y: CGRectGetMinY(frame) + twitterButton.size.height + 20)
        } else if DeviceModel.iPad {
            facebookButton.position = CGPoint(x: CGRectGetMinX(frame) + twitterButton.size.width * 2 + 5, y: CGRectGetMinY(frame) + twitterButton.size.height - 20)
        } else {
            facebookButton.position = CGPoint(x: CGRectGetMinX(frame) + twitterButton.size.width * 2 + 5, y: CGRectGetMinY(frame) + twitterButton.size.height * 2)
        }
        
        facebookButton.name = "facebookButton"
        facebookButton.zPosition = zPositionMenuItems
        addChild(facebookButton)
        
        // Add mute button
        let muteButton = SKSpriteNode(imageNamed: "mute_button")
        
        if DeviceModel.iPhone4 {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + twitterButton.size.height + 20)
        } else if DeviceModel.iPad {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + twitterButton.size.height - 20)
        } else {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + twitterButton.size.height * 2)
        }
        
        muteButton.name = "muteButton"
        muteButton.zPosition = zPositionMenuItems
        addChild(muteButton)
    }
    
    private func getGameScene() -> GameScene? {
        if let scene = GameScene(fileNamed:"GameScene") {
            scene.scaleMode = .AspectFill
            
            view?.showsFPS = true
            view?.showsNodeCount = true
            view?.showsPhysics = true
            
            return scene
        }
        
        return nil
    }
    
    // MARK: - Social methods
    
    private func shareOnTwitter() {
        let gameViewController = view?.window?.rootViewController as! GameViewController
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            twitterController.completionHandler = { (result: SLComposeViewControllerResult) -> Void in
                twitterController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            twitterController.setInitialText("Improving my shooting skills with #ShottyBird, by @itsProf. Available on the App Store. https://appsto.re/us/shottybird.i")
            
            gameViewController.presentViewController(twitterController, animated: true, completion: nil)
        } else {
            GameError.handleAsAlert("Sign in to Twitter", message: "You are not signed in with Twitter. On the Home screen, launch Settings, tap Twitter, and sign in to your account.", presentingViewController: gameViewController, completion: nil)
        }
    }
    
    private func shareOnFacebook() {
        let gameViewController = view?.window?.rootViewController as! GameViewController
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let twitterController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            twitterController.completionHandler = { (result: SLComposeViewControllerResult) -> Void in
                twitterController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            twitterController.setInitialText("Improving my shooting skills with Shotty Bird. Available on the App Store. https://appsto.re/us/shottybird.i")
            
            gameViewController.presentViewController(twitterController, animated: true, completion: nil)
        } else {
            GameError.handleAsAlert("Sign in to Facebook", message: "You are not signed in with Facebook. On the Home screen, launch Settings, tap Facebook, and sign in to your account.", presentingViewController: gameViewController, completion: nil)
        }
    }
    
}