//
//  Missile.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/17/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import SpriteKit
import GameKit

class Missile: SKSpriteNode {
    
    private var sprites = ["missile_1", "missile_2", "missile_3"]
    var delegate: GameScoreDelegate?
    
    init(delegate: GameScoreDelegate) {
        self.delegate = delegate
        let texture = SKTexture(imageNamed: sprites[0])
        
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = "missile"
        self.zPosition = 5
        
        let textures = [SKTexture(imageNamed: sprites[0]), SKTexture(imageNamed: sprites[1]), SKTexture(imageNamed: sprites[2])]
        
        let missileTextureAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        let repeatMissileTextureAnimation = SKAction.repeatAction(missileTextureAnimation, count: 1)
        
        runAction(repeatMissileTextureAnimation) {
            self.setScale(0.85)
            self.zPosition = 4
            self.validateCollision()
            
            self.runAction(repeatMissileTextureAnimation) {
                self.setScale(0.7)
                self.zPosition = 3
                self.validateCollision()
                
                self.runAction(repeatMissileTextureAnimation) {
                    self.setScale(0.55)
                    self.zPosition = 2
                    self.validateCollision()
                    
                    self.runAction(repeatMissileTextureAnimation) {
                        self.setScale(0.4)
                        self.zPosition = 1
                        self.validateCollision()
                        
                        self.runAction(repeatMissileTextureAnimation) {
                            self.setScale(0.25)
                            self.zPosition = 0
                            self.validateCollision()
                            
                            self.runAction(repeatMissileTextureAnimation) {
                                self.setScale(0.1)
                                self.zPosition = -0.999
                                
                                self.runAction(repeatMissileTextureAnimation) {
                                    self.setScale(0.05)
                                    self.zPosition = -0.998
                                    
                                    self.runAction(SKAction.removeFromParent())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder not implemented...")
    }
    
    // MARK: - Collision methods
    
    private func validateCollision() {
        if let gameScene = self.delegate as? GameScene {
            gameScene.enumerateChildNodesWithName("bird", usingBlock: { (bird, stop) in
                if self.intersectsNode(bird) && self.zPosition == bird.zPosition {
                    // Store last x and y scales, postion and zPosition values from bird
                    let xScaleTmp = bird.xScale
                    let yScaleTmp = bird.yScale
                    let positionTmp = bird.position
                    let zPostionTmp = bird.zPosition
                    let muted = gameScene.muted
                    
                    // Remove missile
                    self.runAction(SKAction.removeFromParent())
                    
                    // Remove bird node
                    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
                    
                    if !muted {
                        bird.runAction(SKAction.sequence([playExplosionSoundAction, SKAction.removeFromParent()]))
                    } else {
                        bird.runAction(SKAction.removeFromParent())
                    }
                    
                    // Add explosion node with the last bird's parameters
                    let explosion = SKSpriteNode(imageNamed: "explosion_1")
                    explosion.xScale = xScaleTmp
                    explosion.yScale = yScaleTmp
                    explosion.position = positionTmp
                    explosion.zPosition = zPostionTmp
                    
                    let explosionAction = SKAction.animateWithTextures([SKTexture(imageNamed: "explosion_1"), SKTexture(imageNamed: "explosion_2"), SKTexture(imageNamed: "explosion_3"), SKTexture(imageNamed: "explosion_4"), SKTexture(imageNamed: "explosion_5"), SKTexture(imageNamed: "explosion_6"), SKTexture(imageNamed: "explosion_7"), SKTexture(imageNamed: "explosion_8"), SKTexture(imageNamed: "explosion_9"), SKTexture(imageNamed: "explosion_10"), SKTexture(imageNamed: "explosion_11"), SKTexture(imageNamed: "explosion_12")], timePerFrame: 0.03)
                    explosion.runAction(explosionAction)
                    
                    gameScene.addChild(explosion)
                    
                    // Increase game score
                    gameScene.updateScore()
                    
                    // Remove the explosion node after 0.3 seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.03 * 13 * Double(NSEC_PER_SEC)))
                    dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                        explosion.runAction(SKAction.removeFromParent())
                    }
                    
                    // Check if the "Sniper" achievement need to be unlocked
                    if bird.zPosition == 0 && (bird as! Bird).flightSpeed == 3 {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            let achievement = GKAchievement(identifier: "co.profapps.Shotty_Bird.achievement.sniper")
                            achievement.percentComplete = 100.0
                            GKAchievement.reportAchievements([achievement], withCompletionHandler: nil)
                        }
                    }
                    
                    // Stop the enumeration
                    stop.memory = true
                }
            })
        }
    }

}
