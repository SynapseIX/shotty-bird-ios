//
//  StoreScene.swift
//  Shotty Bird iOS
//
//  Created by Jorge Tapia on 7/30/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Store scene.
class StoreScene: BaseScene {
    
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
    
    override init(backgroundSpeed: BackgroundSpeed = .slow) {
        super.init(backgroundSpeed: backgroundSpeed)
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
    
    /// Sets up all UI elements on the menu scene.
    private func setupUI() {
        // Add panel panel
        let panel = SKSpriteNode(imageNamed: "score_panel")
        panel.xScale = 0.8
        panel.yScale = 0.6
        panel.zPosition = zPositionMenuItems
        panel.zPosition = zPositionMenuItems - 0.01
        panel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        panel.name = "buyButton"
        addChild(panel)
        
        // Add idle enemy and animate it
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
        enemy.setScale(0.33)
        enemy.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) + enemy.size.height / 2 - 20)
        enemy.name = "enemyIdle"
        enemy.zPosition = zPositionMenuItems
        addChild(enemy)
        
        let animationAction = SKAction.animate(with: sprites, timePerFrame: 1.0 / 25.0)
        let waitAction = SKAction.wait(forDuration: 2.0)
        let animateAndWait = SKAction.sequence([animationAction, waitAction])
        let repeatAction = SKAction.repeatForever(animateAndWait)
        enemy.run(repeatAction)
        
        // Add price label
        let priceLabel = AttributedLabelNode(size: panel.size)
        priceLabel.zPosition = zPositionMenuItems
        priceLabel.position = CGPoint(x: CGRectGetMidX(panel.frame), y: CGRectGetMidY(panel.frame) + 30)
        guard let font =  UIFont(name: "AmericanTypewriter-Bold", size: 60),
              let product = StoreManager.shared.items.first else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.font : font,
                                                         .foregroundColor: UIColor.white,
                                                         .strokeColor: UIColor.black,
                                                         .strokeWidth: -5,
                                                         .paragraphStyle: paragraphStyle]
        priceLabel.attributedString = NSAttributedString(string: "\(product.displayPrice)", attributes: attributes)
        addChild(priceLabel)
        
        // Add extra life description label
        let extraLifeLabel = SKLabelNode()
        extraLifeLabel.fontName = "Kenney-Bold"
        extraLifeLabel.fontSize = 17.0
        extraLifeLabel.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        extraLifeLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(panel.frame) + 20)
        extraLifeLabel.zPosition = zPositionMenuItems
        extraLifeLabel.text = "Extra Life on Slayer"
        addChild(extraLifeLabel)
        
        // Add no ads description label
        let noAdsLabel = SKLabelNode()
        noAdsLabel.fontName = "Kenney-Bold"
        noAdsLabel.fontSize = 28.0
        noAdsLabel.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        noAdsLabel.position = CGPoint(x: CGRectGetMidX(frame), y: extraLifeLabel.position.y + 30)
        noAdsLabel.zPosition = zPositionMenuItems
        noAdsLabel.text = "REMOVE ADS"
        addChild(noAdsLabel)
        
        // Add restore purchase button
        let restoreButton = SKSpriteNode(imageNamed: "restore_purchase_button")
        restoreButton.setScale(0.75)
        restoreButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(panel.frame) - restoreButton.size.height / 2 - 20)
        restoreButton.name = "restoreButton"
        restoreButton.zPosition = zPositionMenuItems
        addChild(restoreButton)
        
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
    
    /// Handles the buy button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleBuyButton(in location: CGPoint) {
        guard let buyButton = childNode(withName: "buyButton") else {
            return
        }
        if buyButton.contains(location) {
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            
            let store = StoreManager.shared
            Task {
                if await store.unlockRemoveAds() {
                    showAlert(message: Constants.purchasedAlready)
                } else {
                    guard let product = store.items.first else {
                        return
                    }
                    await store.purchase(product)
                    switch store.purchaseStatus {
                    case .success(let productID):
                        print("Successfully purchased: \(productID)")
                    case .failed(let error):
                        showAlert(message: error.localizedDescription)
                    default:
                        print(store.purchaseStatus)
                        break
                    }
                }
            }
        }
    }
    
    /// Handles the restore purchase button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleRestoreButton(in location: CGPoint) {
        guard let buyButton = childNode(withName: "restoreButton") else {
            return
        }
        if buyButton.contains(location) {
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            
            Task {
                let result = await StoreManager.shared.restorePurchases()
                switch result {
                case .success(let isRestored):
                    if isRestored {
                        showAlert(message: Constants.purchaseRestored)
                    }
                case .failure(let error):
                    showAlert(message: error.localizedDescription)
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
            
            let mainMenuScene = MainMenuScene()
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

extension StoreScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Handle buy button tap
            handleBuyButton(in: location)
            // Handle restore purcha button tap
            handleRestoreButton(in: location)
            // Handle back button tap
            handleBackButton(in: location)
            // Handle mute button tap
            handleMuteButton(in: location)
        }
    }
}

// MARK: - Alerts

extension StoreScene {
    /// Presents an alert controller with a given message.
    /// - Parameter message: The message to be displayed by the alert.
    private func showAlert(message: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let gameViewController = appDelegate.window?.rootViewController else {
            return
        }
        let alert = UIAlertController(title: "Shotty Bird", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        gameViewController.present(alert, animated: true)
    }
}

