//
//  GameScene.swift
//  Shotty Bird Shared
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Main game scene.
class GameScene: BaseScene {
    
    /// Fixed position on the z-axis for UI elements.
    private let zPositionUIElements = CGFloat(Int.max)
    
    /// Last time update method was called.
    private(set) var lastUpdateTime: CFTimeInterval = 0.0
    /// Lat time an enemy spawned.
    private(set) var lastSpawnTime: CFTimeInterval = 0.0
    /// Last time a shot was fired.
    private(set) var lastShotFiredTime: CFTimeInterval = 0.0
    
    /// Number of lives remaining.
    private(set) var lives = 3
    /// Game score.
    private(set) var score: Int64 = 0
    
    /// Controls how many seconds has to pass before spawning a new enemy.
    private var spawnFrequency: TimeInterval = 2
    
    /// Audio manager to play background music.
    let audioManager = AudioManager(file: "TwinEngines-JeremyKorpas", type: "mp3", loop: true)
    
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
        
        var timeSinceLast = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if timeSinceLast > 1 {
            timeSinceLast = 1 / 60
        }
        
        lastSpawnTime += timeSinceLast
        
        if lastSpawnTime > spawnFrequency {
            spawnEnemy()
            lastSpawnTime = 0
        }
    }
    
    // MARK: - Gameplay Elements
    
    /// Spawns and animates a new enemy node.
    func spawnEnemy() {
        // Assign enemy nodes depth and scaling
        let zPosEnemy = CGFloat(arc4random_uniform(5))
        var scale: EnemyScale
        
        switch zPosEnemy {
        case 4:
            scale = .large
        case 3:
            scale = .medium
        case 2:
            scale = .small
        case 1:
            scale = .smaller
        case 0:
            scale = .smallest
        default:
            scale = .large
        }
        
        // Initialize enemy node
        let enemy = Enemy(enemyType: .raven, scale: scale)
        enemy.zPosition = zPosEnemy
        
        // Set starting point and add node
        let minY = CGFloat(200)
        let maxY = size.height - enemy.size.height / 2 - 70 * 1.5 - 5
        let randomY = CGFloat.random(in: minY...maxY)
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: randomY)
        addChild(enemy)
        
        // Setup enemy node Physics
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.restitution = 1.0
        enemy.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.enemy
        
        // Setup enemy speed
        let minDuration = 2.0
        let maxDuration = 5.0
        let duration = TimeInterval.random(in: minDuration...maxDuration)
        enemy.flightSpeed = duration
        
        // Configure actions
        var flappingSpeed: TimeInterval
        switch duration {
        case 2..<3:
            flappingSpeed = 1.0 / 120.0
        case 3..<4:
            flappingSpeed = 1.0 / 90.0
        case 4...5:
            flappingSpeed = 1.0 / 60.0
        default:
            flappingSpeed = 0.0
        }
        
        let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
        let flapAction = SKAction.animate(with: enemy.sprites, timePerFrame: flappingSpeed)
        let flappingSoundAction = SKAction.playSoundFileNamed("wing_flap.wav", waitForCompletion: false)
        let flyAction = SKAction.repeat(flapAction, count: Int(duration / 0.2))
        let moveAction = SKAction.move(to: CGPoint(x: -enemy.size.width / 2, y: enemy.position.y), duration: duration)
        let flyAndMoveAction = SKAction.group([flyAction, moveAction])
        let removeAction = SKAction.removeFromParent()
        
        let sequence = audioManager.isMuted ? SKAction.sequence([flyAndMoveAction, removeAction])
                               : SKAction.sequence([flappingSoundAction, flyAndMoveAction, playBirdSoundAction, removeAction])
        
        // Run actions
        enemy.run(sequence)
    }
    
    /// Shoots a missile sprite node.
    /// - Parameter location: The location where the node should appear.
    private func shootMissile(in location: CGPoint) {
        let missile = Missile(delegate: self)
        missile.position = location
        
        // Setup missile's Physics
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody?.isDynamic = false
        missile.physicsBody?.restitution = 0.0
        missile.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.missile
        
        if !audioManager.isMuted {
            missile.run(SKAction.playSoundFileNamed("shot", waitForCompletion: false))
        }
        
        addChild(missile)
    }
}

// MARK: - UI configuration

extension GameScene {
    /// Creates and positions UI elements to be displayed during gameplay.
    /// - Number of lives
    /// - Score
    /// - Pause Button
    /// - Mute button
    private func setupUI() {
        addLifeNodes()
        addScoreNode()
        addPauseButton()
        addMuteButton()
    }
    
    /// Adds life nodes.
    private func addLifeNodes() {
        // Needed to position UI elements at the bottom of the screen
        let screenCompensation: CGFloat = isPhone ? 0 : -20
        
        // TODO: add 4th life if watched ad or purchased no ads
        let lifeNode1 = SKSpriteNode(imageNamed: "life")
        lifeNode1.position = CGPoint(x: CGRectGetMinX(frame) + lifeNode1.size.width / 2 + 20, y: CGRectGetMaxY(frame) - lifeNode1.size.height - screenCompensation)
        lifeNode1.name = "life1"
        lifeNode1.zPosition = zPositionUIElements
        addChild(lifeNode1)
        
        let lifeNode2 = SKSpriteNode(imageNamed: "life")
        lifeNode2.position = CGPoint(x: CGRectGetMinX(frame) + lifeNode2.size.width * 2 - 10, y: CGRectGetMaxY(frame) - lifeNode2.size.height - screenCompensation)
        lifeNode2.name = "life2"
        lifeNode2.zPosition = zPositionUIElements
        addChild(lifeNode2)
        
        let lifeNode3 = SKSpriteNode(imageNamed: "life")
        lifeNode3.position = CGPoint(x: CGRectGetMinX(frame) + lifeNode3.size.width * 3 - 5, y: CGRectGetMaxY(frame) - lifeNode3.size.height - screenCompensation)
        lifeNode3.name = "life3"
        lifeNode3.zPosition = zPositionUIElements
        addChild(lifeNode3)
    }
    
    /// Adds the score node.
    private func addScoreNode() {
        guard let font = UIFont(name: "Kenney-Bold", size: 35) else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributes: [NSAttributedString.Key: Any] = [.font: font,
                                                         .foregroundColor: UIColor.white,
                                                         .strokeColor: UIColor.black,
                                                         .strokeWidth: -10,
                                                         .paragraphStyle: paragraphStyle]
        
        let attributedString = NSAttributedString(string: "0", attributes: attributes)
        let scoreNode = AttributedLabelNode(size: CGSize(width: 165.0, height: 65.0))
        scoreNode.attributedString = attributedString
        let position = isPhone ? CGPoint(x: CGRectGetMaxX(frame) - scoreNode.size.width / 2 - 10, y: CGRectGetMaxY(frame) - scoreNode.size.height * 2 - 10)
                               : CGPoint(x: CGRectGetMaxX(frame) - scoreNode.size.width / 2 - 10, y: CGRectGetMaxY(frame) - scoreNode.size.height / 2 - 10)
        scoreNode.position = position
        scoreNode.name = "score"
        scoreNode.zPosition = zPositionUIElements
        addChild(scoreNode)
    }
    
    /// Adds the pause button node.
    private func addPauseButton() {
        // Needed to position UI elements at the bottom of the screen
        let screenCompensation: CGFloat = isPhone ? 0 : -20
        let pauseButton = SKSpriteNode(imageNamed: "pause_button")
        pauseButton.position = CGPoint(x: CGRectGetMinX(frame) + pauseButton.size.width + screenCompensation, y: CGRectGetMinY(frame) + pauseButton.size.height + screenCompensation)
        pauseButton.name = "pauseButton"
        pauseButton.zPosition = zPositionUIElements
        addChild(pauseButton)
    }
    
    /// Intercepts the pause button tap and processes it.
    /// - Parameter location: Tap locatiopn on screen.
    /// - Returns: Value of `true` if the pause button was tapped.
    private func handlePauseButton(in location: CGPoint) -> Bool {
        guard let view = view,
              let pauseButton = childNode(withName: "pauseButton") as? SKSpriteNode else {
            return false
        }
        if pauseButton.contains(location) {
            if view.isPaused {
                pauseButton.texture = SKTexture(imageNamed: "pause_button")
                audioManager.tryPlayMusic()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    view.isPaused = false
                }
            } else {
                pauseButton.texture = SKTexture(imageNamed: "play_button_icon")
                audioManager.pause()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    view.isPaused = true
                }
            }
            return true
        }
        return false
    }
    
    
    /// Adds the mute button.
    private func addMuteButton() {
        // Needed to position UI elements at the bottom of the screen
        let screenCompensation: CGFloat = isPhone ? 20 : -20
        let muteButton = audioManager.isMuted ? SKSpriteNode(imageNamed: "mute_button") : SKSpriteNode(imageNamed: "unmute_button")
        muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height + screenCompensation)
        muteButton.name = "muteButton"
        muteButton.zPosition = zPositionUIElements
        addChild(muteButton)
    }
    
    /// Handles the mute button tap event.
    /// - Parameter location: A point where the screen is tapped.
    /// - Returns: Value of `true` if the mute button was tapped.
    private func handleMuteButton(in location: CGPoint) -> Bool {
        guard let muteButton = childNode(withName: "muteButton") as? SKSpriteNode else {
            return false
        }
        if muteButton.contains(location) {
            audioManager.isMuted.toggle()
            muteButton.texture = audioManager.isMuted ? SKTexture(imageNamed: "mute_button") : SKTexture(imageNamed: "unmute_button")
            return true
        }
        return false
    }
}

// MARK: - Touch-based event handling

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Handle pause button tap
            if handlePauseButton(in: location) {
                return
            }
            // Handle mute button tap
            if handleMuteButton(in: location) {
                return
            }
            // Shoot a missile
            if lastShotFiredTime == 0.0 {
                shootMissile(in: location)
                lastShotFiredTime = CACurrentMediaTime()
            } else {
                let deltaTime = CACurrentMediaTime() - lastShotFiredTime
                if deltaTime >= spawnFrequency / 3 {
                    shootMissile(in: location)
                    lastShotFiredTime = CACurrentMediaTime()
                }
            }
        }
    }
}

// MARK: - GameScoreDelegate

extension GameScene: GameScoreDelegate {
    func updateScore() {
        score += 1
        
        if score % 10 == 0 {
            audioManager.increasePlaybackRate(by: 0.2)
        }
        
        // Update score label with new score
        guard let node = childNode(withName: "score") as? AttributedLabelNode,
              let font =  UIFont(name: "Kenney-Bold", size: 35) else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributes: [NSAttributedString.Key: Any] = [.font: font,
                                                         .foregroundColor: UIColor.white,
                                                         .strokeColor: UIColor.black,
                                                         .strokeWidth: -10,
                                                         .paragraphStyle: paragraphStyle]
        node.attributedString = NSAttributedString(string: "\(score)", attributes: attributes)
    }
}

