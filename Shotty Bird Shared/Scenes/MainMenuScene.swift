//
//  MainMenuScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 6/29/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Main menu scene.
class MainMenuScene: BaseScene {
    
    /// Audio manager to play background music.
    let audioManager = AudioManager(file: "Crimson-Sextile", type: "mp3", loop: true)
    
    /// The z-axis position for all menu UI elements.
    let zPositionMenuItems = CGFloat(Int.max)
    
    /// Plays a bird sound clip.
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    /// Plays a shot audio clip.
    let playShotSoundAction = SKAction.playSoundFileNamed("shot", waitForCompletion: false)
    /// Plays an explosion sound cliop.
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    /// Determines if the game is running on a phone device.
    private var isPhone = UIDevice.current.userInterfaceIdiom == .phone
    
    override init(backgroundSpeed: BackgroundSpeed = .slow) {
        super.init(backgroundSpeed: backgroundSpeed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupUI()
        audioManager.tryPlayMusic()
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
        let animateAndWait = SKAction.sequence([animationAction, playBirdSoundAction, waitAction])
        let repeatAction = SKAction.repeatForever(animateAndWait)
        enemy.run(repeatAction)
    }
    
    /// Sets up all UI elements on the menu scene.
    private func setupUI() {
        // Add idle enemy and animate it
        addIdleEnemy()
        
        // Add play button
        let playButton = SKSpriteNode(imageNamed: "play_button")
        playButton.setScale(0.75)
        playButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        playButton.name = "playButton"
        playButton.zPosition = zPositionMenuItems
        addChild(playButton)
        
        // Add leaderboard button
        let leaderboardButton = SKSpriteNode(imageNamed: "leaderboard_button")
        leaderboardButton.setScale(0.75)
        leaderboardButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - leaderboardButton.size.height - 10)
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.zPosition = zPositionMenuItems
        addChild(leaderboardButton)
        
        // Add credits button
        let creditsButton = SKSpriteNode(imageNamed: "credits_button")
        creditsButton.setScale(0.75)
        creditsButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - (leaderboardButton.size.height * 2) - 20)
        creditsButton.name = "creditsButton"
        creditsButton.zPosition = zPositionMenuItems
        addChild(creditsButton)
        
        // Add share button
        let shareButton = SKSpriteNode(imageNamed: "share_button")
        var shareButtonPosition: CGPoint = .zero
        if DeviceModel.iPad || DeviceModel.iPadPro {
            shareButtonPosition = CGPoint(x: CGRectGetMinX(frame) + shareButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + shareButton.size.height - 20)
        } else if DeviceModel.iPhoneSE {
            shareButtonPosition = CGPoint(x: CGRectGetMinX(frame) + shareButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + shareButton.size.height - 10)
        } else {
            shareButtonPosition = CGPoint(x: CGRectGetMinX(frame) + shareButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + shareButton.size.height + 20)
        }
        shareButton.position = shareButtonPosition
        shareButton.name = "shareButton"
        shareButton.zPosition = zPositionMenuItems
        addChild(shareButton)
        
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
    
    /// Handles the play button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handlePlayButton(in location: CGPoint) {
        guard let playButton = childNode(withName: "playButton") else {
            return
        }
        if playButton.contains(location) {
            audioManager.stopMusic()
            run(playExplosionSoundAction)
            
            let gameScene = GameScene(backgroundSpeed: .fast)
            gameScene.audioManager.isMuted = audioManager.isMuted
            
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transition)
        }
    }
    
    /// Handles the play leaderboard tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleLeaderboardButton(in location: CGPoint) {
        guard let leaderboardButton = childNode(withName: "leaderboardButton") else {
            return
        }
        if leaderboardButton.contains(location) {
            // TODO: implement transition
        }
    }
    
    /// Handles the play credits tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleCreditsButton(in location: CGPoint) {
        guard let creditsButton = childNode(withName: "creditsButton") else {
            return
        }
        if creditsButton.contains(location) {
            // TODO: implement transition
        }
    }
    
    /// Handles the share credits tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleShareButton(in location: CGPoint) {
        guard let shareButton = childNode(withName: "shareButton") as? SKSpriteNode,
              let gameViewController = view?.window?.rootViewController as? GameViewController else {
            return
        }
        if shareButton.contains(location) {
            var convertedOrigin = convertPoint(toView: shareButton.frame.origin)
            convertedOrigin.y = convertedOrigin.y - shareButton.frame.size.height / 2
            let shareFrame = CGRect(origin: convertedOrigin, size: shareButton.frame.size)
            
            let activityItems: [Any] = [Constants.shareText, Constants.shareURL, Constants.appIconImage]
            let excludedActivityTypes: [UIActivity.ActivityType] = [.print,
                                                                    .copyToPasteboard,
                                                                    .assignToContact,
                                                                    .saveToCameraRoll,
                                                                    .addToReadingList,
                                                                    .airDrop,
                                                                    .openInIBooks,
                                                                    .postToVimeo,
                                                                    .collaborationCopyLink,
                                                                    .collaborationInviteWithLink,
                                                                    .markupAsPDF,
                                                                    .sharePlay]
            
            let shareController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            shareController.excludedActivityTypes = excludedActivityTypes
            shareController.popoverPresentationController?.sourceView = view
            shareController.popoverPresentationController?.sourceRect = shareFrame
            shareController.popoverPresentationController?.permittedArrowDirections = [.down]
            gameViewController.present(shareController, animated: true)
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

extension MainMenuScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Handle play button tap
            handlePlayButton(in: location)
            // Handle leaderboard button tap
            handleLeaderboardButton(in: location)
            // Handle credits button tap
            handleCreditsButton(in: location)
            // Handle share button tap
            handleShareButton(in: location)
            // Handle mute button tap
            handleMuteButton(in: location)
        }
    }
}

