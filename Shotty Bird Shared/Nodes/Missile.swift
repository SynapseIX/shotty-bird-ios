//
//  Missile.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/4/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Represents a missle used to shoot down enemies.
class Missile: SKSpriteNode {
    
    /// The node name.
    static let nodeName = "missile"
    
    /// The named images for the missile sprite.
    private var sprites = ["missile_1", "missile_2", "missile_3"]
    /// A scale animation that provides the perfection of a missile going inside the screen.
    private let scaleAction = SKAction.scale(by: 0.75, duration: 0.05)
    /// Remove the node once scaling has reached 0.0.
    private let scaleToZeroAndRemoveAction = SKAction.sequence([SKAction.scale(by: 0.0, duration: 0.05), SKAction.removeFromParent()])
    
    /// Game score delegate
    let delegate: GameScoreDelegate
    
    /// Creates a new `Missile` object.
    /// - Parameter delegate: The `GameScoreDelegate` object.
    init(delegate: GameScoreDelegate) {
        self.delegate = delegate
        let texture = SKTexture(imageNamed: sprites[0])
        
        super.init(texture: texture, color: .clear, size: texture.size())
        setScale(1.0)
        name = Missile.nodeName
        zPosition = 10
        
        let textures = [SKTexture(imageNamed: sprites[0]),
                        SKTexture(imageNamed: sprites[1]),
                        SKTexture(imageNamed: sprites[2])]
        
        let missileTextureAnimation = SKAction.animate(with: textures, timePerFrame: 0.01)
        let repeatMissileTextureAnimation = SKAction.repeat(missileTextureAnimation, count: 2)
        let travelAction = SKAction.group([repeatMissileTextureAnimation, scaleAction])
        
        run(travelAction) {
            self.zPosition = 9
            self.validateCollision()
            
            self.run(travelAction) {
                self.zPosition = 8
                self.validateCollision()
                
                self.run(travelAction) {
                    self.zPosition = 7
                    self.validateCollision()
                    
                    self.run(travelAction) {
                        self.zPosition = 6
                        self.validateCollision()
                        
                        self.run(travelAction) {
                            self.zPosition = 5
                            self.validateCollision()
                            
                            self.run(travelAction) {
                                self.zPosition = 4
                                self.validateCollision()
                                
                                self.run(travelAction) {
                                    self.zPosition = 3
                                    self.validateCollision()
                                    
                                    self.run(travelAction) {
                                        self.zPosition = 2
                                        self.validateCollision()
                                        
                                        self.run(travelAction) {
                                            self.zPosition = 1
                                            self.validateCollision()
                                            
                                            self.run(travelAction) {
                                                self.zPosition = 0
                                                self.validateCollision()
                                                
                                                self.run(travelAction) {
                                                    self.zPosition = -0.999
                                                    
                                                    self.run(travelAction) {
                                                        self.zPosition = -0.998
                                                        
                                                        self.run(travelAction) {
                                                            self.zPosition = -0.997
                                                            self.run(self.scaleToZeroAndRemoveAction)
                                                        }
                                                    }
                                                }
                                            }
                                        }
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
    
    /// Validates the collision between a missile and an enemy.
    private func validateCollision() {
        guard let gameScene = delegate as? GameScene else {
            return
        }
        gameScene.enumerateChildNodes(withName: Enemy.nodeName) { node, stop in
            guard let enemy = node as? Enemy else {
                return
            }
            if self.intersects(enemy) && self.zPosition == enemy.zPosition {
                // Store last x and y scales, postion and zPosition values from bird
                let xScaleTmp = enemy.xScale
                let yScaleTmp = enemy.yScale
                let positionTmp = enemy.position
                let zPostionTmp = enemy.zPosition
                let isMuted = gameScene.audioManager.isMuted
                
                // Remove missile
                self.run(SKAction.removeFromParent())
                
                // Explosion sound action
                let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
                
                if !isMuted {
                    enemy.run(SKAction.sequence([playExplosionSoundAction, SKAction.removeFromParent()]))
                } else {
                    enemy.run(SKAction.removeFromParent())
                }
                
                // Add explosion node with the last enemy's parameters
                let explosion = SKSpriteNode(imageNamed: "explosion_7")
                explosion.xScale = xScaleTmp * 0.65
                explosion.yScale = yScaleTmp * 0.65
                explosion.position = positionTmp
                explosion.zPosition = zPostionTmp
                
                let explosionAction = SKAction.animate(with: [SKTexture(imageNamed: "explosion_1"),
                                                              SKTexture(imageNamed: "explosion_2"),
                                                              SKTexture(imageNamed: "explosion_3"),
                                                              SKTexture(imageNamed: "explosion_4"),
                                                              SKTexture(imageNamed: "explosion_5"),
                                                              SKTexture(imageNamed: "explosion_6"),
                                                              SKTexture(imageNamed: "explosion_7"),
                                                              SKTexture(imageNamed: "explosion_8"),
                                                              SKTexture(imageNamed: "explosion_9"),
                                                              SKTexture(imageNamed: "explosion_10"),
                                                              SKTexture(imageNamed: "explosion_11"),
                                                              SKTexture(imageNamed: "explosion_12")],
                                                       timePerFrame: 0.03)
                
                explosion.run(SKAction.sequence([explosionAction, SKAction.removeFromParent()]))
                gameScene.addChild(explosion)

                // Increase game score and grant extra life if needed
                gameScene.updateScore(grantExtraLife: enemy.zPosition == 0)

                // Check if the "Sniper" achievement need to be unlocked and report if necessary
                if enemy.zPosition == 0 && enemy.flightSpeed == 2.0 {
                    let gameCenterHelper = GameCenterHelper.shared
                    guard let achievement = gameCenterHelper.getAchievement(with: Constants.sniper) else {
                        return
                    }
                    if achievement.percentComplete != 100 {
                        DispatchQueue.main.async {
                            gameCenterHelper.reportAchievement(identifier: achievement.identifier, percentComplete: 100.0, showsCompletionBanner: true)
                        }
                    }
                }
                
                // Stop the enumeration
                stop.pointee = true
            }
        }
    }
}

