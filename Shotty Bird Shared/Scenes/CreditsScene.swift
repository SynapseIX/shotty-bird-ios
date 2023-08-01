//
//  CreditsScene.swift
//  Shotty Bird iOS
//
//  Created by Jorge Tapia on 7/31/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit
import UIKit

/// Credits scene.
class CreditsScene: BaseScene {
    
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
    
    init() {
        super.init(backgroundSpeed: .slow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupUI()
        audioManager.playMusic(type: .gameOver, loop: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    // MARK: - UI configuration
    
    /// Sets up all UI elements on the menu scene.
    private func setupUI() {
        // Add title label
        let titleLabel = AttributedLabelNode(size: CGSize(width: 500, height: 250))
        titleLabel.zPosition = zPositionMenuItems
        titleLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame) - 200)
        guard let font =  UIFont(name: "Kenney-Bold", size: 80) else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.font : font,
                                                         .foregroundColor: UIColor.white,
                                                         .strokeColor: UIColor.black,
                                                         .strokeWidth: -10,
                                                         .paragraphStyle: paragraphStyle]
        titleLabel.attributedString = NSAttributedString(string: "SHOTTY\nBIRD", attributes: attributes)
        addChild(titleLabel)
        
        // Add Jorge's panel
        let panelJorge = SKSpriteNode(imageNamed: "score_panel")
        panelJorge.xScale = 0.6
        panelJorge.yScale = 0.6
        panelJorge.zPosition = zPositionMenuItems
        panelJorge.zPosition = zPositionMenuItems - 0.01
        panelJorge.position = CGPoint(x: CGRectGetMidX(frame) - panelJorge.size.width / 2 - 20, y: CGRectGetMidY(frame) - panelJorge.size.height / 2 - 30)
        panelJorge.name = "jorgeButton"
        addChild(panelJorge)
        
        // Add programming label
        let programming = SKLabelNode()
        programming.position = CGPoint(x: CGRectGetMidX(panelJorge.frame), y: panelJorge.position.y + 120)
        programming.zPosition = zPositionMenuItems
        programming.zPosition = zPositionMenuItems - 0.01
        programming.fontName = "Kenney-Bold"
        programming.fontSize = 28
        programming.fontColor = .black
        programming.text = "Programming"
        addChild(programming)
        
        // Add no ads description label
        let jorgeTapia = SKLabelNode()
        jorgeTapia.fontName = "Kenney-Bold"
        jorgeTapia.fontSize = 28.0
        jorgeTapia.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        jorgeTapia.position = CGPoint(x: CGRectGetMidX(panelJorge.frame), y: CGRectGetMidY(panelJorge.frame))
        jorgeTapia.zPosition = zPositionMenuItems
        jorgeTapia.text = "Jorge Tapia"
        addChild(jorgeTapia)
        
        // Add @4Stryngs label
        let fourStryngs = SKLabelNode()
        fourStryngs.fontName = "Kenney-Bold"
        fourStryngs.fontSize = 28.0
        fourStryngs.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        fourStryngs.position = CGPoint(x: CGRectGetMidX(panelJorge.frame), y: CGRectGetMidY(panelJorge.frame) - 50)
        fourStryngs.zPosition = zPositionMenuItems
        fourStryngs.text = "@4Stryngs"
        addChild(fourStryngs)
        
        // Add JP's panel
        let panelJP = SKSpriteNode(imageNamed: "score_panel")
        panelJP.xScale = 0.6
        panelJP.yScale = 0.6
        panelJP.zPosition = zPositionMenuItems
        panelJP.zPosition = zPositionMenuItems - 0.01
        panelJP.position = CGPoint(x: CGRectGetMidX(frame) + panelJP.size.width / 2 + 20, y: CGRectGetMidY(frame) - panelJP.size.height / 2 - 30)
        panelJP.name = "jpButton"
        addChild(panelJP)
        
        // Add game concept label
        let gameConcept = SKLabelNode()
        gameConcept.position = CGPoint(x: CGRectGetMidX(panelJP.frame), y: panelJP.position.y + 120)
        gameConcept.zPosition = zPositionMenuItems
        gameConcept.zPosition = zPositionMenuItems - 0.01
        gameConcept.fontName = "Kenney-Bold"
        gameConcept.fontSize = 28
        gameConcept.fontColor = .black
        gameConcept.text = "Game Concept"
        addChild(gameConcept)
        
        // Add no ads description label
        let jpAlbuja = SKLabelNode()
        jpAlbuja.fontName = "Kenney-Bold"
        jpAlbuja.fontSize = 28.0
        jpAlbuja.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        jpAlbuja.position = CGPoint(x: CGRectGetMidX(panelJP.frame), y: CGRectGetMidY(panelJP.frame))
        jpAlbuja.zPosition = zPositionMenuItems
        jpAlbuja.text = "Juan P. Albuja"
        addChild(jpAlbuja)
        
        // Add @4Stryngs label
        let jpLink = SKLabelNode()
        jpLink.fontName = "Kenney-Bold"
        jpLink.fontSize = 28.0
        jpLink.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        jpLink.position = CGPoint(x: CGRectGetMidX(panelJP.frame), y: CGRectGetMidY(panelJP.frame) - 50)
        jpLink.zPosition = zPositionMenuItems
        jpLink.text = "@jpalbuja"
        addChild(jpLink)
        
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
    
    /// Handles the Jorge button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleJorgeButton(in location: CGPoint) {
        guard let jorgeButton = childNode(withName: "jorgeButton") as? SKSpriteNode else {
            return
        }
        if jorgeButton.contains(location) {
            if !audioManager.isMuted {
                jorgeButton.run(playExplosionSoundAction)
            }
            UIApplication.shared.open(Constants.jorgeSocialURL)
        }
    }
    
    /// Handles the JP button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleJpButton(in location: CGPoint) {
        guard let jpButton = childNode(withName: "jpButton") as? SKSpriteNode else {
            return
        }
        if jpButton.contains(location) {
            if !audioManager.isMuted {
                jpButton.run(playExplosionSoundAction)
            }
            UIApplication.shared.open(Constants.juanPabloSocialURL)
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
            
            let mainMenuScene = MainMenuScene()
            let transition = SKTransition.crossFade(withDuration: 1.0)
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

extension CreditsScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Handle Jorge button tap
            handleJorgeButton(in: location)
            // Handle JP button tap
            handleJpButton(in: location)
            // Handle back button tap
            handleBackButton(in: location)
            // Handle mute button tap
            handleMuteButton(in: location)
        }
    }
}

