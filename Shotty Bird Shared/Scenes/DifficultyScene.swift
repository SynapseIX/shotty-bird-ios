//
//  DifficultyScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/27/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Difficulty selection scene for practice mode.
class DifficultyScene: BaseScene {
    
    /// The selected difficulty level for practice mode.
    private var selectedDifficulty: Difficulty = .none
    
    /// Audio manager to play background music.
    let audioManager = AudioManager.shared
    /// Ads manager.
    let ads = AdsManager.shared
    
    /// The z-axis position for all menu UI elements.
    let zPositionMenuItems = CGFloat(Int.max)
    
    /// Plays a bird sound clip.
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    /// Plays a shot audio clip.
    let playShotSoundAction = SKAction.playSoundFileNamed("shot", waitForCompletion: false)
    /// Plays an explosion sound clip.
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    override init(backgroundSpeed: BackgroundSpeed = .slow) {
        super.init(backgroundSpeed: backgroundSpeed)
        ads.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupUI()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    // MARK: - UI configuration
    
    /// Adds an idle enemy with animation.
    private func addIdleEnemy() {
        let sprites = [SKTexture(imageNamed: "idle-texture0001"),
                       SKTexture(imageNamed: "idle-texture0002"),
                       SKTexture(imageNamed: "idle-texture0003"),
                       SKTexture(imageNamed: "idle-texture0004"),
                       SKTexture(imageNamed: "idle-texture0005"),
                       SKTexture(imageNamed: "idle-texture0006"),
                       SKTexture(imageNamed: "idle-texture0007"),
                       SKTexture(imageNamed: "idle-texture0008"),
                       SKTexture(imageNamed: "idle-texture0009"),
                       SKTexture(imageNamed: "idle-texture0010"),
                       SKTexture(imageNamed: "idle-texture0011"),
                       SKTexture(imageNamed: "idle-texture0012"),
                       SKTexture(imageNamed: "idle-texture0013"),
                       SKTexture(imageNamed: "idle-texture0014"),
                       SKTexture(imageNamed: "idle-texture0015"),
                       SKTexture(imageNamed: "idle-texture0016"),
                       SKTexture(imageNamed: "idle-texture0017"),
                       SKTexture(imageNamed: "idle-texture0018"),
                       SKTexture(imageNamed: "idle-texture0019"),
                       SKTexture(imageNamed: "idle-texture0020"),
                       SKTexture(imageNamed: "idle-texture0021"),
                       SKTexture(imageNamed: "idle-texture0022"),
                       SKTexture(imageNamed: "idle-texture0023"),
                       SKTexture(imageNamed: "idle-texture0024"),
                       SKTexture(imageNamed: "idle-texture0025")]
        
        let enemy = SKSpriteNode(texture: sprites[0], color: .clear, size: sprites[0].size())
        enemy.setScale(0.5)
        enemy.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) + 150)
        enemy.name = "enemyIdle"
        enemy.zPosition = zPositionMenuItems
        addChild(enemy)
        
        let animationAction = SKAction.animate(with: sprites, timePerFrame: 1.0 / 25.0)
        let waitAction = SKAction.wait(forDuration: 2.0)
        let animateAndWait = SKAction.sequence([animationAction, waitAction])
        let repeatAction = SKAction.repeatForever(animateAndWait)
        enemy.run(repeatAction)
    }
    
    /// Sets up all UI elements on the menu scene.
    private func setupUI() {
        // Add idle enemy and animate it
        addIdleEnemy()
        
        // Add easy button
        let easyButton = SKSpriteNode(imageNamed: "easy_button")
        easyButton.setScale(0.75)
        easyButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        easyButton.name = "easyButton"
        easyButton.zPosition = zPositionMenuItems
        addChild(easyButton)
        
        // Add normal button
        let normalButton = SKSpriteNode(imageNamed: "normal_button")
        normalButton.setScale(0.75)
        normalButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - normalButton.size.height - 10)
        normalButton.name = "normalButton"
        normalButton.zPosition = zPositionMenuItems
        addChild(normalButton)
        
        // Add hard button
        let hardButton = SKSpriteNode(imageNamed: "hard_button")
        hardButton.setScale(0.75)
        hardButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - (normalButton.size.height * 2) - 20)
        hardButton.name = "hardButton"
        hardButton.zPosition = zPositionMenuItems
        addChild(hardButton)
        
        // Add back button
        let backButton = SKSpriteNode(imageNamed: "back_button")
        var backButtonPosition: CGPoint = .zero
        if DeviceModel.iPad || DeviceModel.iPadPro {
            backButtonPosition = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height - 20)
        } else if DeviceModel.iPhoneSE {
            backButtonPosition = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height - 10)
        } else {
            backButtonPosition = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height + 20)
        }
        backButton.position = backButtonPosition
        backButton.name = "backButton"
        backButton.zPosition = zPositionMenuItems
        addChild(backButton)
        
        // Add mute button
        let muteButton = audioManager.isMuted ? SKSpriteNode(imageNamed: "mute_button") : SKSpriteNode(imageNamed: "unmute_button")
        var muteButtonPosition: CGPoint = .zero
        if DeviceModel.iPad || DeviceModel.iPadPro {
            muteButtonPosition = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height - 20)
        } else if DeviceModel.iPhoneSE {
            muteButtonPosition = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height - 10)
        } else {
            muteButtonPosition = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height + 20)
        }
        muteButton.position = muteButtonPosition
        muteButton.name = "muteButton"
        muteButton.zPosition = zPositionMenuItems
        addChild(muteButton)
    }
    
    /// Transitions to the game scene for given game mode.
    private func launchPractice() {
        if selectedDifficulty != .none {
            audioManager.stop()
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            let gameScene = GameScene(mode: .practice, difficulty: selectedDifficulty, didInteractWithAd: false)
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.1)
            view?.presentScene(gameScene, transition: transition)
        }
    }
    
    // MARK: - UI event handlers
    
    /// Handles the easy button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleEasyButton(in location: CGPoint) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let rootViewController = appDelegate.window?.rootViewController as? GameViewController else {
            return
        }
        if !rootViewController.loadingOverlay.isHidden {
            return
        }
        
        guard let easyButton = childNode(withName: "easyButton") else {
            return
        }
        if easyButton.contains(location) {
            selectedDifficulty = .easy
            Task {
                if await StoreManager.shared.unlockRemoveAds() {
                    launchPractice()
                } else {
                    ads.showInterstitial()
                }
            }
        }
    }
    
    /// Handles the normal button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleNormalButton(in location: CGPoint) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let rootViewController = appDelegate.window?.rootViewController as? GameViewController else {
            return
        }
        if !rootViewController.loadingOverlay.isHidden {
            return
        }
        
        guard let normalButton = childNode(withName: "normalButton") else {
            return
        }
        if normalButton.contains(location) {
            selectedDifficulty = .normal
            Task {
                if await StoreManager.shared.unlockRemoveAds() {
                    launchPractice()
                } else {
                    ads.showInterstitial()
                }
            }
        }
    }
    
    /// Handles the hard button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleHardButton(in location: CGPoint) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let rootViewController = appDelegate.window?.rootViewController as? GameViewController else {
            return
        }
        if !rootViewController.loadingOverlay.isHidden {
            return
        }
        
        guard let hardButton = childNode(withName: "hardButton") else {
            return
        }
        if hardButton.contains(location) {
            selectedDifficulty = .hard
            Task {
                if await StoreManager.shared.unlockRemoveAds() {
                    launchPractice()
                } else {
                    ads.showInterstitial()
                }
            }
        }
    }
    
    /// Handles the back button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleBackButton(in location: CGPoint) {
        guard let backButton = childNode(withName: "backButton") as? SKSpriteNode else {
            return
        }
        if backButton.contains(location) {
            if !audioManager.isMuted {
                backButton.run(playBirdSoundAction)
            }
            
            let mainMenuScene = GameModeScene()
            let transition = SKTransition.crossFade(withDuration: 1.0)
            view?.presentScene(mainMenuScene, transition: transition)
        }
    }
    
    /// Handles the mute button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleMuteButton(in location: CGPoint) {
        guard let muteButton = childNode(withName: "muteButton") as? SKSpriteNode else {
            return
        }
        if muteButton.contains(location) {
            audioManager.isMuted.toggle()
            muteButton.texture = audioManager.isMuted ? SKTexture(imageNamed: "mute_button") : SKTexture(imageNamed: "unmute_button")
        }
    }
}

// MARK: - Touch-based event handling

extension DifficultyScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Handle play button tap
            handleEasyButton(in: location)
            // Handle leaderboard button tap
            handleNormalButton(in: location)
            // Handle credits button tap
            handleHardButton(in: location)
            // Handle share button tap
            handleBackButton(in: location)
            // Handle mute button tap
            handleMuteButton(in: location)
        }
    }
}

// MARK: - AdsManager

extension DifficultyScene: AdsManagerDelegate {
    func adDidDismiss(withReward: Bool) {
        launchPractice()
    }
}
