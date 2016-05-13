//
//  GameScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/5/16.
//  Copyright (c) 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bgLayers = [String]()
    var parallaxBackground: ParallaxBackground?
    
    var audioManager = AudioManager(file: "gameplay_music", type: "wav", loop: true)
    var muted = false
    
    let zPositionBg = CGFloat(-1)
    let zPositionMenuItems = CGFloat(Int.max)
    
    var lastUpdateTime: CFTimeInterval = 0.0
    var lastSpawnTime: CFTimeInterval = 0.0
    
    var lives = 3
    var score = 0
    
    override func didMoveToView(view: SKView) {
        // Setup audio manager
        audioManager.audioPlayer?.volume = !muted ? 1.0 : 0.0
        audioManager.audioPlayer?.enableRate = true
        audioManager.tryPlayMusic()
        
        // Add background
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgLayers, size: size, fastestSpeed: 10.0, speedDecrease: 3.0)
        
        addChild(parallaxBackground!)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        // Add first life node
        let firstLife = SKSpriteNode(imageNamed: "life")
        
        if DeviceModel.iPhone4 {
            firstLife.position = CGPoint(x: CGRectGetMinX(frame) + firstLife.size.width / 2 + 20, y: CGRectGetMaxY(frame) - firstLife.size.height - 20)
        } else if DeviceModel.iPad {
            firstLife.position = CGPoint(x: CGRectGetMinX(frame) + firstLife.size.width / 2 + 20, y: CGRectGetMaxY(frame) - firstLife.size.height / 2 - 20)
        } else {
            firstLife.position = CGPoint(x: CGRectGetMinX(frame) + firstLife.size.width / 2 + 20, y: CGRectGetMaxY(frame) - firstLife.size.height * 2)
        }
        
        firstLife.name = "life1"
        firstLife.zPosition = zPositionMenuItems
        addChild(firstLife)
        
        // Add second life node
        let secondLife = SKSpriteNode(imageNamed: "life")
        
        if DeviceModel.iPhone4 {
            secondLife.position = CGPoint(x: CGRectGetMinX(frame) + secondLife.size.width * 2 - 10, y: CGRectGetMaxY(frame) - secondLife.size.height - 20)
        } else if DeviceModel.iPad {
            secondLife.position = CGPoint(x: CGRectGetMinX(frame) + secondLife.size.width * 2 - 10, y: CGRectGetMaxY(frame) - secondLife.size.height / 2 - 20)
        } else {
            secondLife.position = CGPoint(x: CGRectGetMinX(frame) + secondLife.size.width * 2 - 10, y: CGRectGetMaxY(frame) - secondLife.size.height * 2)
        }
        
        secondLife.name = "life2"
        secondLife.zPosition = zPositionMenuItems
        addChild(secondLife)
        
        // Add third life node
        let thirdLife = SKSpriteNode(imageNamed: "life")
        
        if DeviceModel.iPhone4 {
            thirdLife.position = CGPoint(x: CGRectGetMinX(frame) + thirdLife.size.width * 3 - 5, y: CGRectGetMaxY(frame) - thirdLife.size.height - 20)
        } else if DeviceModel.iPad {
            thirdLife.position = CGPoint(x: CGRectGetMinX(frame) + thirdLife.size.width * 3 - 5, y: CGRectGetMaxY(frame) - thirdLife.size.height / 2 - 20)
        } else {
            thirdLife.position = CGPoint(x: CGRectGetMinX(frame) + thirdLife.size.width * 3 - 5, y: CGRectGetMaxY(frame) - thirdLife.size.height * 2)
        }
        
        thirdLife.name = "life3"
        thirdLife.zPosition = zPositionMenuItems
        addChild(thirdLife)
        
        // Add score node
        let scoreLabel = SKLabelNode(fontNamed:"Kenney-Bold")
        scoreLabel.text = "0"
        scoreLabel.fontSize = 35
        scoreLabel.zPosition = zPositionMenuItems
        scoreLabel.name = "score"
        
        if DeviceModel.iPad {
            scoreLabel.position = CGPoint(x: CGRectGetMaxX(frame) - 35, y: CGRectGetMaxY(frame) - 65)
        } else if DeviceModel.iPhone4 {
            scoreLabel.position = CGPoint(x: CGRectGetMaxX(frame) - 35, y: CGRectGetMaxY(frame) - 115)
        } else {
            scoreLabel.position = CGPoint(x: CGRectGetMaxX(frame) - 35, y: CGRectGetMaxY(frame) - 160)
        }
        
        addChild(scoreLabel)
        
        // Add mute button
        let muteButton = muted ? SKSpriteNode(imageNamed: "mute_button") : SKSpriteNode(imageNamed: "unmute_button")
        
        if DeviceModel.iPhone4 {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height + 20)
        } else if DeviceModel.iPad {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height - 20)
        } else {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height * 2)
        }
        
        muteButton.name = "muteButton"
        muteButton.zPosition = zPositionMenuItems
        addChild(muteButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let muteButton = childNodeWithName("muteButton") as? SKSpriteNode {
                if muteButton.containsPoint(location) {
                    audioManager.audioPlayer?.volume = muted ? 1.0 : 0.0
                    muted = audioManager.audioPlayer?.volume == 0.0 ? true : false
                    
                    muteButton.texture = muted ? SKTexture(imageNamed: "mute_button") : SKTexture(imageNamed: "unmute_button")
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        parallaxBackground?.update()
        
        var timeSinceLast = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if timeSinceLast > 1 {
            timeSinceLast = 1.0 / 60.0
        }
        
        lastSpawnTime += timeSinceLast
        
        if score < 10 {
            if lastSpawnTime > 1.5 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        } else if score >= 10 && score < 25 {
            if lastSpawnTime > 1.0 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        } else if score >= 25 && score < 40 {
            if lastSpawnTime > 0.75 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        } else if score >= 40 {
            if lastSpawnTime > 0.5 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        }
    }
    
    // MARK: - Spawn methods
    
    private func spawnBird() {
        let newBird = Bird(delegate: self)
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
        newBird.physicsBody = SKPhysicsBody(rectangleOfSize: newBird.size)
        //newBird.physicsBody = SKPhysicsBody(texture: newBird.texture!, size: newBird.texture!.size())
        newBird.physicsBody?.dynamic = false
        newBird.physicsBody?.restitution = 1.0
        newBird.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        
        // Setup actions
        let minDuration = 2.00
        let maxDuration = 3.75
        let actualDuration = Double(arc4random()) / Double(UInt32.max) * abs(minDuration - maxDuration) + min(minDuration, maxDuration)
        
        let moveAction = SKAction.moveTo(CGPoint(x: -newBird.size.width / 2, y: newBird.position.y), duration: actualDuration)
        
        let sequence = muted ? SKAction.sequence([GameAction.rotationAction, moveAction, GameAction.finishedMovedAction]) : SKAction.sequence([GameAction.playWingFlapSoundAction, GameAction.rotationAction, moveAction, GameAction.playBirdSoundAction, GameAction.finishedMovedAction])
        
        // Runs action sequence and executes completion closure to determine if a bird escaped
        newBird.runAction(sequence) {
            if newBird.position == CGPoint(x: -newBird.size.width / 2, y: newBird.position.y) {
                self.lives -= 1
                
                if self.lives == 2 {
                    let node = self.childNodeWithName("life1") as! SKSpriteNode
                    node.texture = SKTexture(imageNamed: "death")
                } else if self.lives == 1 {
                    let node = self.childNodeWithName("life2") as! SKSpriteNode
                    node.texture = SKTexture(imageNamed: "death")
                } else if self.lives == 0 {
                    let node = self.childNodeWithName("life3") as! SKSpriteNode
                    node.texture = SKTexture(imageNamed: "death")
                    
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
        scene.bgLayers = bgLayers
        scene.scaleMode = .AspectFill
        
        return scene
    }
    
}

extension GameScene: GameScoreDelegate {
    
    func updateScore() {
        score += 1
        
        if score == 10 {
            audioManager.audioPlayer?.rate = 1.05
        }
        
        if score == 25 {
            audioManager.audioPlayer?.rate = 1.10
        }
        
        if score == 40 {
            audioManager.audioPlayer?.rate = 1.15
        }
        
        if score == 50 {
            audioManager.audioPlayer?.rate = 1.20
        }
        
        if score == 60 {
            audioManager.audioPlayer?.rate = 1.25
        }
        
        if score == 70 {
            audioManager.audioPlayer?.rate = 1.30
        }
        
        if score == 80 {
            audioManager.audioPlayer?.rate = 1.35
        }
        
        if score == 85 {
            audioManager.audioPlayer?.rate = 1.40
        }
        
        if score == 90 {
            audioManager.audioPlayer?.rate = 1.45
        }
        
        if score == 100 {
            audioManager.audioPlayer?.rate = 1.45
        }
        
        if let node = childNodeWithName("score") as? SKLabelNode {
            if score == 10 || score == 100 || score == 1000 {
                node.position = CGPoint(x: node.position.x - 10, y: node.position.y)
            }
            
            node.text = "\(score)"
        }
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
