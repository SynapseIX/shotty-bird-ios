//
//  GameScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/5/16.
//  Copyright (c) 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var lastUpdateTime: CFTimeInterval = 0.0
    var lastSpawnTime: CFTimeInterval = 0.0
    
    let rotationAction = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0)
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    let playWingFlapSoundAction = SKAction.playSoundFileNamed("wing_flap.wav", waitForCompletion: false)
    let finishedMovedAction = SKAction.removeFromParent()
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        background.zPosition = -1
        background.xScale = 0.65
        background.yScale = 0.65
        
        addChild(background)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    }
   
    override func update(currentTime: CFTimeInterval) {
        var timeSinceLast = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if timeSinceLast > 1 {
            timeSinceLast = 1.0 / 60.0
        }
        
        lastSpawnTime += timeSinceLast
        
        if lastSpawnTime > 0.5 {
            lastSpawnTime = 0.0
            spawnBird()
        }
    }
    
    private func spawnBird() {
        let newBird = Bird()
        newBird.xScale = 0.2
        newBird.yScale = 0.2
        newBird.zPosition = 1
        newBird.yScale = -newBird.yScale;
        
        let minY = newBird.size.height * 3
        let maxY = frame.height - minY
        let rangeY = maxY - minY
        let birdY = (CGFloat(arc4random()) % rangeY) + minY
        
        newBird.position = CGPoint(x: frame.width + (newBird.size.width / 2), y: birdY)
        addChild(newBird)
        
        // Setup bird node Physics
        //newBird.physicsBody = SKPhysicsBody(texture: newBird.texture!, size: newBird.texture!.size())
        newBird.physicsBody = SKPhysicsBody(rectangleOfSize: newBird.size)
        newBird.physicsBody?.restitution = 1.0
        newBird.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        
        // Setup actions
        let minDuration = 1.5
        let maxDuration = 4.0
        let actualDuration = Double(arc4random()) / Double(UInt32.max) * abs(minDuration - maxDuration) + min(minDuration, maxDuration)
        
        let moveAction = SKAction.moveTo(CGPoint(x: -newBird.size.width / 2, y: newBird.position.y), duration: actualDuration)
        newBird.runAction(SKAction.sequence([playWingFlapSoundAction, rotationAction, moveAction, playBirdSoundAction, finishedMovedAction]))
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Handle missile - bird collision
        if firstBody.categoryBitMask == PhysicsCategory.Bird && secondBody.categoryBitMask == PhysicsCategory.Missile {
            print("Hit a bird with a missile...")
        }
    }
    
}
