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
    var audioManager: AudioManager {
        #if os(iOS) || os(tvOS)
            AudioManagerIOS(file: "TwinEngines-JeremyKorpas", type: "mp3", loop: true)
        #elseif os(OSX)
            AudioManagerMac()
        #endif
    }
    
    /// The z-axis position for all menu UI elements.
    let zPositionMenuItems = CGFloat(Int.max)
    
    /// Plays a bird sound clip.
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    /// Plays a shot audio clip.
    let playShotSoundAction = SKAction.playSoundFileNamed("shot", waitForCompletion: false)
    /// Plays an explosion sound cliop.
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    /// Determines if the game is running on a phone device.
    private var isPhone: Bool {
        #if os(iOS) || os(tvOS)
            UIDevice.current.userInterfaceIdiom == .phone
        #else
            false
        #endif
    }
    
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
    
    /// Sets up all UI elements on the menu scene.
    private func setupUI() {
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
        
        // Needed to position UI elements at the bottom of the screen
        let screenCompensation: CGFloat = isPhone ? 20 : -20
        
        // Add share button
        let shareButton = SKSpriteNode(imageNamed: "share_button")
        shareButton.position = CGPoint(x: CGRectGetMinX(frame) + shareButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + shareButton.size.height + screenCompensation)
        shareButton.name = "shareButton"
        shareButton.zPosition = zPositionMenuItems
        addChild(shareButton)
        
        // Add mute button
        let muteButton = audioManager.isMuted ? SKSpriteNode(imageNamed: "mute_button") : SKSpriteNode(imageNamed: "unmute_button")
        muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height + screenCompensation)
        muteButton.name = "muteButton"
        muteButton.zPosition = zPositionMenuItems
        addChild(muteButton)
    }
    
    // MARK: - UI event handlers
    
    private func handleMuteButton(in location: CGPoint) {
        guard let muteButton = childNode(withName: "muteButton") as? SKSpriteNode else {
            return
        }
        if muteButton.contains(location) {
            audioManager.toggleMute()
            muteButton.texture = audioManager.isMuted ? SKTexture(imageNamed: "mute_button") : SKTexture(imageNamed: "unmute_button")
        }
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension MainMenuScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Handle mute button tap
            handleMuteButton(in: location)
        }
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension MainMenuScene {
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        // Handle mute button click
        handleMuteButton(in: location)
    }
}
#endif

