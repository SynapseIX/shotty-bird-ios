//
//  MainMenuScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/10/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit
import GameKit

class MainMenuScene: SKScene {
    
    var parallaxBackground: ParallaxBackground?
    
    let audioManager = AudioManager(file: "menu_music", type: "wav", loop: true)
    var muted = false
    
    let zPositionMenuItems = CGFloat(Int.max)
    
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    let playShotSoundAction = SKAction.playSoundFileNamed("shot", waitForCompletion: false)
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    var waitingForGameCenterNode = SKSpriteNode(imageNamed: "waiting")
    
    // MARK: - Scene methods
    
    override func didMoveToView(view: SKView) {
        setupAudioManager()
        setupUI()
        
        // Reset achievements
//        GKAchievement.resetAchievementsWithCompletionHandler { (error) in
//            print("Achievements reset...")
//        }
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
                    // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
                    let tutorialScene = TutorialScene(size: CGSize(width: 1024.0, height: 768.0))
                    tutorialScene.scaleMode = .AspectFill
                    tutorialScene.muted = muted
                    tutorialScene.bgLayers = parallaxBackground!.bgLayers
                    
                    let transition = SKTransition.crossFadeWithDuration(1.0)
                    view?.presentScene(tutorialScene, transition: transition)
                }
            }
            
            if let leaderboardButton = childNodeWithName("leaderboardButton") {
                if leaderboardButton.containsPoint(location) {
                    let gameViewController = view?.window?.rootViewController as! GameViewController
                    let gameCenterHelper = gameViewController.gameCenterHelper
                    
                    if !gameCenterHelper.gameCenterEnabled {
                        // Add waiting for game center node
                        waitingForGameCenterNode.removeFromParent()
                        waitingForGameCenterNode = SKSpriteNode(imageNamed: "waiting")
                        
                        if DeviceModel.iPad || DeviceModel.iPadPro {
                            waitingForGameCenterNode.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + waitingForGameCenterNode.size.height)
                        } else if DeviceModel.iPhone4 {
                            waitingForGameCenterNode.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + waitingForGameCenterNode.size.height * 2)
                        } else {
                            waitingForGameCenterNode.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + waitingForGameCenterNode.size.height * 3)
                        }
                        
                        waitingForGameCenterNode.zPosition = zPositionMenuItems
                        
                        let fadeAction = SKAction.sequence([SKAction.fadeInWithDuration(0.4), SKAction.fadeOutWithDuration(0.4)])
                        let repeatFadeAction = SKAction.repeatActionForever(fadeAction)
                        let waitingAction = SKAction.sequence([repeatFadeAction, SKAction.removeFromParent()])
                        
                        waitingForGameCenterNode.runAction(waitingAction)
                        addChild(waitingForGameCenterNode)
                        
                        // Authenticate player
                        gameCenterHelper.authenticateLocalPlayer(gameViewController) {
                            self.waitingForGameCenterNode.removeFromParent()
                            gameCenterHelper.presentLeaderboard(gameViewController)
                        }
                    } else {
                        if !muted {
                            leaderboardButton.runAction(playBirdSoundAction)
                            gameCenterHelper.presentLeaderboard(gameViewController)
                        }
                    }
                }
            }
            
            if let creditsButton = childNodeWithName("creditsButton") {
                if creditsButton.containsPoint(location) {
                    if !muted {
                        creditsButton.runAction(playBirdSoundAction)
                    }
                    
                    // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
                    let creditsScene = CreditsScene(size: CGSize(width: 1024.0, height: 768.0))
                    creditsScene.scaleMode = .AspectFill
                    creditsScene.bgLayers = parallaxBackground!.bgLayers
                    creditsScene.muted = muted
                    
                    let transition = SKTransition.pushWithDirection(.Up, duration: 0.5)
                    view?.presentScene(creditsScene, transition: transition)
                }
            }
            
            if let twitterButton = childNodeWithName("twitterButton") {
                if twitterButton.containsPoint(location) {
                    if !muted {
                        twitterButton.runAction(playBirdSoundAction)
                    }
                    
                    if let tweetbotURL = NSURL(string: "tweetbot://shottybird/user_profile/shottybird") {
                        if UIApplication.sharedApplication().canOpenURL(tweetbotURL) {
                            UIApplication.sharedApplication().openURL(tweetbotURL)
                        } else if let twitterURL = NSURL(string: "twitter://user?screen_name=shottybird") {
                            if UIApplication.sharedApplication().canOpenURL(twitterURL) {
                                UIApplication.sharedApplication().openURL(twitterURL)
                            } else {
                                if let twitterWebURL = NSURL(string: "http://twitter.com/shottybird") {
                                    UIApplication.sharedApplication().openURL(twitterWebURL)
                                }
                            }
                        }
                    }
                }
            }
            
            if let facebookButton = childNodeWithName("facebookButton") {
                if facebookButton.containsPoint(location) {
                    facebookButton.runAction(playBirdSoundAction)
                    
                    if let fbAppURL = NSURL(string: "fb://profile/1629764307346494") {
                        if UIApplication.sharedApplication().canOpenURL(fbAppURL) {
                            UIApplication.sharedApplication().openURL(fbAppURL)
                        } else {
                            if let facebookURL = NSURL(string: "http://facebook.com/shottybird") {
                                UIApplication.sharedApplication().openURL(facebookURL)
                            }
                        }
                    }
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
        addParallaxBackground()
        
        // Add and scale game logo
        let logo = SKSpriteNode(imageNamed: "logo_large")
        
        if DeviceModel.iPad || DeviceModel.iPadPro {
            logo.setScale(0.75)
        } else {
            logo.setScale(0.65)
        }
        
        let logoY = DeviceModel.iPad || DeviceModel.iPadPro ? CGRectGetMaxY(frame) - CGFloat(logo.size.height) / 2 - 30 : CGRectGetMaxY(frame) - CGFloat(logo.size.height) - 30
        logo.position = CGPoint(x: CGRectGetMidX(frame), y: logoY)
        logo.zPosition = zPositionMenuItems
        addChild(logo)
        
        // Add play button
        let playButton = SKSpriteNode(imageNamed: "play_button")
        
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            playButton.setScale(0.75)
        }
        
        playButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        playButton.name = "playButton"
        playButton.zPosition = zPositionMenuItems
        addChild(playButton)
        
        // Add leaderboard button
        let leaderboardButton = SKSpriteNode(imageNamed: "leaderboard_button")
        
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            leaderboardButton.setScale(0.75)
        }
        
        leaderboardButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - leaderboardButton.size.height - 10)
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.zPosition = zPositionMenuItems
        addChild(leaderboardButton)
        
        // Add credits button
        let creditsButton = SKSpriteNode(imageNamed: "credits_button")
        
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            creditsButton.setScale(0.75)
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
        let muteButton = !muted ? SKSpriteNode(imageNamed: "unmute_button") : SKSpriteNode(imageNamed: "mute_button") 
        
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
    
    private func addParallaxBackground() {
        let bg1 = ["bg1_layer1", "bg1_layer2", "bg1_layer3", "bg1_layer4", "bg1_layer5"]
        let bg2 = ["bg2_layer1", "bg2_layer2", "bg2_layer3", "bg2_layer4"]
        let bg3 = ["bg3_layer1", "bg3_layer2", "bg3_layer3", "bg3_layer4", "bg3_layer5"]
        let bg4 = ["bg4_layer1", "bg4_layer2", "bg4_layer3", "bg4_layer4", "bg4_layer5"]
        let bg5 = ["bg5_layer1", "bg5_layer2", "bg5_layer3", "bg5_layer4", "bg5_layer5"]
        let bg6 = ["bg6_layer1", "bg6_layer2", "bg6_layer3", "bg6_layer4", "bg6_layer5"]
        let bg7 = ["bg7_layer1", "bg7_layer2", "bg7_layer3", "bg7_layer4"]
        let bg8 = ["bg8_layer1", "bg8_layer2", "bg8_layer3", "bg8_layer4", "bg8_layer5"]
        let bg9 = ["bg9_layer1", "bg9_layer2", "bg9_layer3", "bg9_layer4", "bg9_layer5", "bg9_layer6", "bg9_layer7", "bg9_layer8"]
        let bg10 = ["bg10_layer1", "bg10_layer2", "bg10_layer3", "bg10_layer4", "bg10_layer5"]
        let bg11 = ["bg11_layer1", "bg11_layer2", "bg11_layer3", "bg11_layer4", "bg11_layer5"]
        
        let allBgs = [bg1, bg2, bg3, bg4, bg5, bg6, bg7, bg8, bg9, bg10, bg11]
        let bgs = allBgs[Int(arc4random_uniform(UInt32(allBgs.count)))]
        
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgs, size: size, fastestSpeed: 2.0, speedDecrease: 0.6)
        addChild(parallaxBackground!)
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
        
        if !audioManager.audioPlayer!.playing {
            audioManager.tryPlayMusic()
        }
    }
    
}