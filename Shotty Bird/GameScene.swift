//
//  GameScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/5/16.
//  Copyright (c) 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let audioManager = AudioManager(file: "gameplay_music_1", type: "wav", loop: true)
    var muted = false
    
    let zPositionBg = CGFloat(-1)
    
    var lastUpdateTime: CFTimeInterval = 0.0
    var lastSpawnTime: CFTimeInterval = 0.0
    
    var lives = 3
    
    override func didMoveToView(view: SKView) {
        audioManager.tryPlayMusic()
        
        let background = SKSpriteNode(imageNamed: "background")
        
        if DeviceModel.iPad {
            background.xScale = 0.7
            background.yScale = 0.7
        } else if DeviceModel.iPhone4 {
            background.xScale = 0.65
            background.yScale = 0.65
        } else {
            background.xScale = 0.55
            background.yScale = 0.55
        }
        
        background.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        background.zPosition = zPositionBg
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
        
        if lastSpawnTime > 0.75 {
            lastSpawnTime = 0.0
            spawnBird()
        }
    }
    
    // MARK: - Spawn methods
    
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
        newBird.physicsBody = SKPhysicsBody(texture: newBird.texture!, size: newBird.texture!.size())
        newBird.physicsBody?.dynamic = false
        newBird.physicsBody?.restitution = 1.0
        newBird.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        
        // Setup actions
        let minDuration = 1.5
        let maxDuration = 4.0
        let actualDuration = Double(arc4random()) / Double(UInt32.max) * abs(minDuration - maxDuration) + min(minDuration, maxDuration)
        
        let moveAction = SKAction.moveTo(CGPoint(x: -newBird.size.width / 2, y: newBird.position.y), duration: actualDuration)
        
        newBird.runAction(SKAction.sequence([GameAction.playWingFlapSoundAction, GameAction.rotationAction, moveAction, GameAction.playBirdSoundAction, GameAction.finishedMovedAction])) {
            if newBird.position == CGPoint(x: -newBird.size.width / 2, y: newBird.position.y) {
                self.lives -= 1
                
                if self.lives == 2 {
                    
                } else if self.lives == 1 {
                
                } else if self.lives == 0 {
                    self.audioManager.stopMusic()
                    let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                    self.view?.presentScene(self.getGameOverScene(), transition: transition)
                }
            }
        }
    }
    
    private func getGameOverScene() -> GameOverScene {
        // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
        let scene = GameOverScene(size: CGSize(width: 1024.0, height: 768.0))
        scene.muted = muted
        scene.scaleMode = .AspectFill
        
        return scene
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
