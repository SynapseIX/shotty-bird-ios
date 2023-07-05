//
//  GameScene.swift
//  Shotty Bird Shared
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Main game scene.
class GameScene: BaseScene {
    
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
    
    /// Audio manager to play background music.
    let audioManager = AudioManager(file: "TwinEngines-JeremyKorpas", type: "mp3", loop: true)
    /// Flag that determines if audio is muted.
    var isMuted = false
    
    override init(backgroundSpeed: BackgroundSpeed = .slow) {
        super.init(backgroundSpeed: backgroundSpeed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupAudioManager()
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
    
    /// Spawns and animates a new enemy node.
    func spawnEnemy() {
        let enemy = Enemy(enemyType: .raven)
        
        // Assign enemy nodes depth and scaling
        let zPosEnemy = CGFloat(arc4random_uniform(5))
        enemy.zPosition = zPosEnemy
        var scale: CGFloat = 0
        switch zPosEnemy {
        case 4:
            scale = 1.5
        case 3:
            scale = 1.25
        case 2:
            scale = 1.0
        case 1:
            scale = 0.75
        case 0:
            scale = 0.50
        default:
            break
        }
        enemy.xScale = -scale
        enemy.yScale = scale
        
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
        
        let sequence = isMuted ? SKAction.sequence([flyAndMoveAction, removeAction])
                               : SKAction.sequence([flappingSoundAction, flyAndMoveAction, playBirdSoundAction, removeAction])
        
        // Run actions
        enemy.run(sequence)
    }
    
    private func shootMissile(in location: CGPoint) {
        let missile = Missile(delegate: self)
        missile.position = location
        
        // Setup missile's Physics
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody?.isDynamic = false
        missile.physicsBody?.restitution = 0.0
        missile.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.missile
        
        if !isMuted {
            missile.run(SKAction.playSoundFileNamed("shot", waitForCompletion: false))
        }
        
        addChild(missile)
    }
    
    // MARK: - Audio methods
        
    private func setupAudioManager() {
        audioManager.player?.enableRate = true
        audioManager.tryPlayMusic()
        audioManager.player?.volume = isMuted ? 0.0 : AudioManager.maxVolume
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
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
                if deltaTime >= lastSpawnTime * 0.5 {
                    shootMissile(in: location)
                    lastShotFiredTime = CACurrentMediaTime()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        if lastShotFiredTime == 0.0 {
            shootMissile(in: location)
            lastShotFiredTime = CACurrentMediaTime()
        } else {
            let deltaTime = CACurrentMediaTime() - lastShotFiredTime
            if deltaTime >= lastSpawnTime * 0.5 {
                shootMissile(in: location)
                lastShotFiredTime = CACurrentMediaTime()
            }
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
}
#endif

// MARK: - GameScoreDelegate

extension GameScene: GameScoreDelegate {
    func updateScore() {
        // TODO: implement
    }
}
