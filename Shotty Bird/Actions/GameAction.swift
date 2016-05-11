//
//  GameActions.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/10/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

struct GameAction {
    static let rotationAction = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0)
    static let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    static let playWingFlapSoundAction = SKAction.playSoundFileNamed("wing_flap.wav", waitForCompletion: false)
    static let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    static let finishedMovedAction = SKAction.removeFromParent()
}
