//
//  GameScene.swift
//  Shotty Bird Shared
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Main game scene.
class GameScene: BaseScene {
    
    private(set) var lastUpdateTime: CFTimeInterval = 0.0
    private(set) var lastSpawnTime: CFTimeInterval = 0.0
    private(set) var lastShotFiredTime: CFTimeInterval = 0.0
    
    private(set) var lives = 3
    private(set) var score: Int64 = 0
    
    var isMuted = false
    
    override init(backgroundSpeed: BackgroundSpeed = .slow) {
        super.init(backgroundSpeed: backgroundSpeed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        var timeSinceLast = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if timeSinceLast > 1 {
            timeSinceLast = 1 / 60
        }
        
        lastSpawnTime += timeSinceLast
        
        if lastSpawnTime > 0.2 {
            spawnEnemy()
            lastSpawnTime = 0
        }
    }
    
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
        enemy.physicsBody?.collisionBitMask = EnemyCollisionBitMask.enemy
        
        // Setup bird speed
        let minDuration = 2.0
        let maxDuration = 5.0
        let duration = TimeInterval.random(in: minDuration...maxDuration)
        enemy.flightSpeed = duration
        
        // Configure actions
        let flappingSpeed = duration <= 3 ? 1.0 / 120.0 : 1.0 / 60.0
        let flapAction = SKAction.animate(with: enemy.sprites, timePerFrame: flappingSpeed)
        let flyAction = SKAction.repeat(flapAction, count: 10)
        let moveAction = SKAction.move(to: CGPoint(x: -enemy.size.width * 2, y: enemy.position.y), duration: duration)
        let flyAndMoveAction = SKAction.group([flyAction, moveAction])
        
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([flyAndMoveAction, removeAction])
        
        // Run actions
        enemy.run(sequence)
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
}
#endif
