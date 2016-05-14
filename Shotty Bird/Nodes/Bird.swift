//
//  Bird.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/7/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class Bird: SKSpriteNode {
    
    var delegate: GameScoreDelegate?
    var sprites: [String]
    
    init(delegate: GameScoreDelegate) {
        sprites = GameUtils.randomBird()
        
        let texture = SKTexture(imageNamed: sprites[0])
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.delegate = delegate
        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder not implemented...")
    }
    
    // TODO: this must be done when testing a collision between missile and bird
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Store last x and y scales, postion and zPosition values from bird
        let xScaleTmp = xScale
        let yScaleTmp = yScale
        let positionTmp = position
        let zPostionTmp = zPosition
        
        // Remove bird node
        runAction(SKAction.sequence([GameAction.playExplosionSoundAction, SKAction.removeFromParent()]))
        
        // Add explosion node with the last bird's parameters
        let explosion = SKSpriteNode(imageNamed: "explosion_1")
        explosion.xScale = xScaleTmp
        explosion.yScale = yScaleTmp
        explosion.position = positionTmp
        explosion.zPosition = zPostionTmp
        
        let explosionAction = SKAction.animateWithTextures([SKTexture(imageNamed: "explosion_1"), SKTexture(imageNamed: "explosion_2"), SKTexture(imageNamed: "explosion_3"), SKTexture(imageNamed: "explosion_4"), SKTexture(imageNamed: "explosion_5"), SKTexture(imageNamed: "explosion_6"), SKTexture(imageNamed: "explosion_7"), SKTexture(imageNamed: "explosion_8"), SKTexture(imageNamed: "explosion_9"), SKTexture(imageNamed: "explosion_10"), SKTexture(imageNamed: "explosion_11"), SKTexture(imageNamed: "explosion_12")], timePerFrame: 0.03)
        explosion.runAction(explosionAction)
        
        (delegate as! GameScene).addChild(explosion)
        
        // TODO: increase game score and move this logic to the contact delegate when missile is done
        delegate?.updateScore()
        
        // Remove the explosion node after 0.3 seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.03 * 13 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            explosion.runAction(SKAction.removeFromParent())
        }
    }

}
