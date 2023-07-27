//
//  GameOverScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/27/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Game over scene.
class GameOverScene: BaseScene {
    
    /// The score that was obtained by the player
    let score: Int64
    
    /// The game mode that was played.
    let mode: GameMode
    
    /// Audio manager to play background music.
    let audioManager = AudioManager.shared
    
    /// The z-axis position for all menu UI elements.
    let zPositionMenuItems = CGFloat(Int.max)
    
    /// Plays a bird sound clip.
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    /// Plays a shot audio clip.
    let playShotSoundAction = SKAction.playSoundFileNamed("shot", waitForCompletion: false)
    /// Plays an explosion sound clip.
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    /// Plays a gmae over chime sound.
    let playGameOverChime = SKAction.playSoundFileNamed("game_over_positive", waitForCompletion: false)
    
    /// Creates a new Game Over scene instance.
    /// - Parameter score: The score that was obtained.
    /// - Parameter mode: The game mode that was played.
    init(score: Int64, mode: GameMode) {
        self.score = score
        self.mode = mode
        super.init(backgroundSpeed: .slow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupUI()
        audioManager.playMusic(type: .gameOver, loop: true)
        if !audioManager.isMuted {
            run(playGameOverChime)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    // MARK: - UI configuration
    
    /// Sets up all UI elements on the menu scene.
    private func setupUI() {
        // TODO: implement
        
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
    
    // MARK: - UI event handlers
    
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
            
            let mainMenuScene = MainMenuScene()
            let transition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
            view?.presentScene(mainMenuScene, transition: transition)
            audioManager.playMusic(type: .menu, loop: true)
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

extension GameOverScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Handle share button tap
            handleBackButton(in: location)
            // Handle mute button tap
            handleMuteButton(in: location)
        }
    }
}

