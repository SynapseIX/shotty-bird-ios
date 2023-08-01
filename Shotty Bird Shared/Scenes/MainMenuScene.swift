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
        ads.initialize()
        ads.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupUI()
        Task {
            if await StoreManager.shared.unlockRemoveAds() {
                audioManager.playMusic(type: .menu, loop: true)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    // MARK: - UI configuration
    
    /// Sets up all UI elements on the menu scene.
    private func setupUI() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let rootViewController = appDelegate.window?.rootViewController as? GameViewController else {
            return
        }
        Task {
            if await !StoreManager.shared.unlockRemoveAds() && !ads.adsAreLoaded {
                DispatchQueue.main.async {
                    rootViewController.loadingOverlay.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    rootViewController.loadingOverlay.isHidden = true
                }
            }
        }
        
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
        
        // Add play button
        let playButton = SKSpriteNode(imageNamed: "play_button")
        playButton.setScale(0.75)
        playButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        playButton.name = "playButton"
        playButton.zPosition = zPositionMenuItems
        addChild(playButton)
        
        // Add Game Center button
        let gameCenterButton = SKSpriteNode(imageNamed: "game_center_button")
        gameCenterButton.setScale(0.75)
        gameCenterButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - gameCenterButton.size.height - 10)
        gameCenterButton.name = "gameCenterButton"
        gameCenterButton.zPosition = zPositionMenuItems
        addChild(gameCenterButton)
        
        // Add credits button
        let creditsButton = SKSpriteNode(imageNamed: "credits_button")
        creditsButton.setScale(0.75)
        creditsButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - (creditsButton.size.height * 2) - 20)
        creditsButton.name = "creditsButton"
        creditsButton.zPosition = zPositionMenuItems
        addChild(creditsButton)
        
        // Add store button
        let storeButton = SKSpriteNode(imageNamed: "store_button")
        storeButton.setScale(0.75)
        storeButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - (storeButton.size.height * 3) - 30)
        storeButton.name = "storeButton"
        storeButton.zPosition = zPositionMenuItems
        addChild(storeButton)
        
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
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            
            let gameModeScene = GameModeScene()
            let transition = SKTransition.crossFade(withDuration: 1.0)
            view?.presentScene(gameModeScene, transition: transition)
        }
    }
    
    /// Handles the Game Center button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleGameCenterButton(in location: CGPoint) {
        guard let gameCenterButton = childNode(withName: "gameCenterButton") else {
            return
        }
        if gameCenterButton.contains(location) {
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            if gameCenterButton.contains(location) && GameCenterHelper.shared.isGameCenterEnabled {
                GameCenterHelper.shared.presentGameCenterViewController()
            }
        }
    }
    
    /// Handles the credits button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleCreditsButton(in location: CGPoint) {
        guard let creditsButton = childNode(withName: "creditsButton") else {
            return
        }
        if creditsButton.contains(location) {
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            
            let creditsScene = CreditsScene()
            let transition = SKTransition.crossFade(withDuration: 1.0)
            view?.presentScene(creditsScene, transition: transition)
        }
    }
    
    /// Handles the store button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleStoreButton(in location: CGPoint) {
        guard let storeButton = childNode(withName: "storeButton") else {
            return
        }
        if storeButton.contains(location) {
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            
            let storeScene = StoreScene()
            let transition = SKTransition.crossFade(withDuration: 1.0)
            view?.presentScene(storeScene, transition: transition)
        }
    }
    
    /// Handles the share button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleShareButton(in location: CGPoint) {
        guard let shareButton = childNode(withName: "shareButton") as? SKSpriteNode,
              let gameViewController = view?.window?.rootViewController as? GameViewController else {
            return
        }
        if shareButton.contains(location) {
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            
            var convertedOrigin = convertPoint(toView: shareButton.frame.origin)
            convertedOrigin.y = convertedOrigin.y - shareButton.frame.size.height / 2
            let shareFrame = CGRect(origin: convertedOrigin, size: shareButton.frame.size)
            
            let activityItems: [Any] = [Constants.shareText, Constants.appStoreURL]
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
            // Handle Game Center button tap
            handleGameCenterButton(in: location)
            // Handle credits button tap
            handleCreditsButton(in: location)
            // Handle store button tap
            handleStoreButton(in: location)
            // Handle share button tap
            handleShareButton(in: location)
            // Handle mute button tap
            handleMuteButton(in: location)
        }
    }
}

// MARK: - AdsManagerDelegate

extension MainMenuScene: AdsManagerDelegate {
    func adsDidLoad() {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let rootViewController = appDelegate.window?.rootViewController as? GameViewController else {
                return
            }
            rootViewController.loadingOverlay.isHidden = true
            if !self.audioManager.isPlaying {
                self.audioManager.playMusic(type: .menu, loop: true)
            }
        }
    }
}

