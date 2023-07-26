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
        
        if lastSpawnTime > 2 {
            spawnEnemy()
            lastSpawnTime = 0
        }
    }
    
    /// Creates and positions UI elements to be displayed during gameplay.
    /// - Number of lives
    /// - Score
    /// - Pause Button
    /// - Mute button
    func setupUI() {
        
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
        let maxY = size.height - enemy.size.height / 2
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

// MARK: - Touch-based event handling

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Limit taps to shoot missiles based on current bird spawn times and last touch time
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
        // TODO: implement
    }
}

