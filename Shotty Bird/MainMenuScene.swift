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
    
    var parallaxBackground: ParallaxBackground?
    
    let audioManager = AudioManager(file: "menu_music", type: "wav", loop: true)
    var muted = false
    
    let zPositionMenuItems = CGFloat(Int.max)
    
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    // MARK: - Scene methods
    
    override func didMoveToView(view: SKView) {
        setupAudioManager()
        setupUI()
    }
    
    override func willMoveFromView(view: SKView) {
        for node in children {
            node.removeFromParent()
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        parallaxBackground?.update()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let playButton = childNodeWithName("playButton") {
                if playButton.containsPoint(location) {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let tutorialCompleted = defaults.boolForKey("tutorialCompleted")
                    
                    if tutorialCompleted {
                        if let gameScene = getGameScene() {
                            audioManager.stopMusic()
                            gameScene.muted = muted
                            gameScene.bgLayers = parallaxBackground!.bgLayers
                            
                            if !muted {
                                playButton.runAction(playExplosionSoundAction)
                            }
                            
                            let transition = SKTransition.crossFadeWithDuration(1.0)
                            view?.presentScene(gameScene, transition: transition)
                        }
                    } else {
                        // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
                        let tutorialScene = TutorialScene(size: CGSize(width: 1024.0, height: 768.0))
                        tutorialScene.scaleMode = .AspectFill
                        tutorialScene.muted = muted
                        tutorialScene.bgLayers = parallaxBackground!.bgLayers
                        
                        let transition = SKTransition.crossFadeWithDuration(1.0)
                        view?.presentScene(tutorialScene, transition: transition)
                    }
                }
            }
            
            if let leaderboardButton = childNodeWithName("leaderboardButton") {
                if leaderboardButton.containsPoint(location) {
                    // TODO: Handle leaderboard button tap
                    if !muted {
                        leaderboardButton.runAction(playBirdSoundAction)
                    }
                    print("Leaderboard button tapped")
                }
            }
            
            if let creditsButton = childNodeWithName("creditsButton") {
                if creditsButton.containsPoint(location) {
                    // TODO: Handle leaderboard button tap
                    if !muted {
                        creditsButton.runAction(playBirdSoundAction)
                    }
                    
                    print("Credits button tapped")
                }
            }
            
            if let twitterButton = childNodeWithName("twitterButton") {
                if twitterButton.containsPoint(location) {
                    if !muted {
                        twitterButton.runAction(playBirdSoundAction)
                    }
                    
                    shareOnTwitter()
                }
            }
            
            if let facebookButton = childNodeWithName("facebookButton") {
                if facebookButton.containsPoint(location) {
                    facebookButton.runAction(playBirdSoundAction)
                    shareOnFacebook()
                }
            }
            
            if let muteButton = childNodeWithName("muteButton") as? SKSpriteNode {
                if muteButton.containsPoint(location) {
                    audioManager.audioPlayer?.volume = muted ? 1.0 : 0.0
                    muted = audioManager.audioPlayer?.volume == 0.0 ? true : false
                    
                    muteButton.texture = muted ? SKTexture(imageNamed: "mute_button") : SKTexture(imageNamed: "unmute_button")
                }
            }
        }
    }
    
    // MARK: - User interface methods
    
    private func setupUI() {
        // Add background
        let bg1 = ["bg1_layer1", "bg1_layer2", "bg1_layer3", "bg1_layer4", "bg1_layer5"]
        let bg2 = ["bg2_layer1", "bg2_layer2", "bg2_layer3", "bg2_layer4"]
        let bg3 = ["bg3_layer1", "bg3_layer2", "bg3_layer3", "bg3_layer4", "bg3_layer5"]
        let bg4 = ["bg4_layer1", "bg4_layer2", "bg4_layer3", "bg4_layer4", "bg4_layer5"]
        let bg5 = ["bg5_layer1", "bg5_layer2", "bg5_layer3", "bg5_layer4", "bg5_layer5"]
        let bg6 = ["bg6_layer1", "bg6_layer2", "bg6_layer3", "bg6_layer4", "bg6_layer5"]
        let bg7 = ["bg7_layer1", "bg7_layer2", "bg7_layer3", "bg7_layer4"]
        
        let allBgs = [bg1, bg2, bg3, bg4, bg5, bg6, bg7]
        let bgs = allBgs[Int(arc4random_uniform(UInt32(allBgs.count)))]
        
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgs, size: size, fastestSpeed: 2.0, speedDecrease: 0.25)
        addChild(parallaxBackground!)
        
        // Add and scale game logo
        let logo = SKSpriteNode(imageNamed: "logo_large")
        
        if DeviceModel.iPad || DeviceModel.iPadPro {
            logo.xScale = 0.75
            logo.yScale = 0.75
        } else {
            logo.xScale = 0.65
            logo.yScale = 0.65
        }
        
        let logoY = DeviceModel.iPad || DeviceModel.iPadPro ? CGRectGetMaxY(frame) - CGFloat(logo.size.height) / 2 - 30 : CGRectGetMaxY(frame) - CGFloat(logo.size.height) - 30
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
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
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
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
            facebookButton.position = CGPoint(x: CGRectGetMinX(frame) + twitterButton.size.width * 2 + 5, y: CGRectGetMinY(frame) + twitterButton.size.height - 20)
        } else {
            facebookButton.position = CGPoint(x: CGRectGetMinX(frame) + twitterButton.size.width * 2 + 5, y: CGRectGetMinY(frame) + twitterButton.size.height * 2)
        }
        
        facebookButton.name = "facebookButton"
        facebookButton.zPosition = zPositionMenuItems
        addChild(facebookButton)
        
        // Add mute button
        let muteButton = SKSpriteNode(imageNamed: "unmute_button")
        
        if DeviceModel.iPhone4 {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height + 20)
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height - 20)
        } else {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height * 2)
        }
        
        muteButton.name = "muteButton"
        muteButton.zPosition = zPositionMenuItems
        addChild(muteButton)
    }
    
    private func getGameScene() -> GameScene? {
        if let scene = GameScene(fileNamed:"GameScene") {
            scene.scaleMode = .AspectFill
            return scene
        }
        
        return nil
    }
    
    // MARK: - Audio methods
    
    private func setupAudioManager() {
        audioManager.audioPlayer?.volume = !muted ? 1.0 : 0.0
        audioManager.tryPlayMusic()
    }
    
    // MARK: - Social methods
    
    private func shareOnTwitter() {
        let gameViewController = view?.window?.rootViewController as! GameViewController
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            twitterController.completionHandler = { (result: SLComposeViewControllerResult) -> Void in
                twitterController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            twitterController.setInitialText("Improving my shooting skills with #ShottyBird. Available on the App Store. https://appsto.re/us/shottybird.i")
            
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