//
//  GameOverScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/11/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var score = 0
    var bgLayers = [String]()
    var parallaxBackground: ParallaxBackground?
    
    let audioManager = AudioManager(file: "game_over_music", type: "mp3", loop: false)
    var muted = false
    
    let zPositionBg = CGFloat(-1)
    let zPositionMenuItems = CGFloat(Int.max)
    
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)

    override func didMoveToView(view: SKView) {
        audioManager.audioPlayer?.volume = !muted ? 1.0 : 0.0
        audioManager.tryPlayMusic()
        
        // Add background
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgLayers, size: size, fastestSpeed: 2.0, speedDecrease: 0.25)
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
        // TODO: fetch best score from Game Center
        let bestScoreLabel = SKLabelNode(text: "Your best is 100")
        bestScoreLabel.fontName = "Kenney-Bold"
        bestScoreLabel.fontSize = 17.0
        bestScoreLabel.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        bestScoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(panel.frame) + 20)
        bestScoreLabel.zPosition = zPositionMenuItems
        addChild(bestScoreLabel)
        
        // Add game over node
        let gameOver = SKSpriteNode(imageNamed: "game_over")
        gameOver.xScale = 0.8
        gameOver.yScale = 0.8
        gameOver.zPosition = zPositionMenuItems
        gameOver.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(panel.frame) + gameOver.size.height - 30)
        addChild(gameOver)
        
        // Add replay button
        let playButton = SKSpriteNode(imageNamed: "replay_button")
        playButton.position = CGPoint(x: CGRectGetMidX(panel.frame), y: CGRectGetMinY(panel.frame) - playButton.size.height / 2 - 10)
        playButton.name = "playButton"
        playButton.zPosition = zPositionMenuItems
        addChild(playButton)
        
        // Add back button
        let backButton = SKSpriteNode(imageNamed: "back_button")
        backButton.position = CGPoint(x: playButton.position.x - backButton.size.width - 20, y: playButton.position.y)
        backButton.name = "backButton"
        backButton.zPosition = zPositionMenuItems
        addChild(backButton)
        
        // Add leaderboard button
        let leaderboardButton = SKSpriteNode(imageNamed: "leaderboard_button_icon")
        leaderboardButton.position = CGPoint(x: playButton.position.x + leaderboardButton.size.width + 20, y: playButton.position.y)
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.zPosition = zPositionMenuItems
        addChild(leaderboardButton)
        
        // Add AdMob view
        // TODO: replace with actual AdMob view
        let adNode = SKSpriteNode(imageNamed: "admob_sample")
        adNode.zPosition = zPositionMenuItems
        
        if DeviceModel.iPad || DeviceModel.iPadPro {
            adNode.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + adNode.size.height / 2)
        } else if DeviceModel.iPhone4 {
            adNode.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + adNode.size.height + 8)
        } else {
            adNode.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + adNode.size.height * 2 - 7)
        }
        
        addChild(adNode)
    }
    
    override func update(currentTime: NSTimeInterval) {
        parallaxBackground?.update()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let backButton = childNodeWithName("backButton") {
                if backButton.containsPoint(location) {
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
                    // TODO: Handle leaderboard button tap
                    if !muted {
                        leaderboardButton.runAction(playBirdSoundAction)
                    }
                    
                    print("Leaderboard button tapped")
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
    
}
