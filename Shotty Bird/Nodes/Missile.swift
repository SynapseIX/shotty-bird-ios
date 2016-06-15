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
    private let scaleAction = SKAction.scaleBy(0.8, duration: 0.1)
    private let scaleToZeroAndRemoveAction = SKAction.sequence([SKAction.scaleBy(0.0, duration: 0.1), SKAction.removeFromParent()])
    
    var delegate: GameScoreDelegate?
    
    init(delegate: GameScoreDelegate) {
        self.delegate = delegate
        let texture = SKTexture(imageNamed: sprites[0])
        
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.setScale(1.0)
        self.name = "missile"
        self.zPosition = 5
        
        let textures = [SKTexture(imageNamed: sprites[0]), SKTexture(imageNamed: sprites[1]), SKTexture(imageNamed: sprites[2])]
        
        let missileTextureAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.01)
        let repeatMissileTextureAnimation = SKAction.repeatAction(missileTextureAnimation, count: 2)
        let travelAction = SKAction.group([repeatMissileTextureAnimation, scaleAction])
        
        runAction(travelAction) {
            self.zPosition = 4
            self.validateCollision()
            
            self.runAction(travelAction) {
                self.zPosition = 3
                self.validateCollision()
                
                self.runAction(travelAction) {
                    self.zPosition = 2
                    self.validateCollision()
                    
                    self.runAction(travelAction) {
                        self.zPosition = 1
                        self.validateCollision()
                        
                        self.runAction(travelAction) {
                            self.zPosition = 0
                            self.validateCollision()
                            
                            self.runAction(travelAction) {
                                self.zPosition = -0.999
                                
                                self.runAction(travelAction) {
                                    self.zPosition = -0.998
                                    
                                    self.runAction(travelAction) {
                                        self.zPosition = -0.997
                                        self.runAction(self.scaleToZeroAndRemoveAction)
                                    }
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
                    let explosion = SKSpriteNode(imageNamed: "explosion_7")
                    explosion.xScale = xScaleTmp * 0.65
                    explosion.yScale = yScaleTmp * 0.65
                    explosion.position = positionTmp
                    explosion.zPosition = zPostionTmp
                    
                    let explosionAction = SKAction.animateWithTextures([SKTexture(imageNamed: "explosion_1"), SKTexture(imageNamed: "explosion_2"), SKTexture(imageNamed: "explosion_3"), SKTexture(imageNamed: "explosion_4"), SKTexture(imageNamed: "explosion_5"), SKTexture(imageNamed: "explosion_6"), SKTexture(imageNamed: "explosion_7"), SKTexture(imageNamed: "explosion_8"), SKTexture(imageNamed: "explosion_9"), SKTexture(imageNamed: "explosion_10"), SKTexture(imageNamed: "explosion_11"), SKTexture(imageNamed: "explosion_12")], timePerFrame: 0.03)
                    
                    explosion.runAction(SKAction.sequence([explosionAction, SKAction.removeFromParent()]))
                    gameScene.addChild(explosion)
                    
                    // Increase game score
                    gameScene.updateScore()
                    
                    // Check if the "Sniper" achievement need to be unlocked and report if necessary
                    if bird.zPosition == 0 && (bird as! Bird).flightSpeed == 3 {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let gameCenterHelper = appDelegate.gameCenterHelper
                        
                        if !gameCenterHelper.sniper.unlocked {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                gameCenterHelper.reportAchievement("co.profapps.Shotty_Bird.achievement.sniper", percentComplete: 100.0, showsCompletionBanner: true)
                            }
                        }
                    }
                    
                    // Stop the enumeration
                    stop.memory = true
                }
            })
        }
    }

}
