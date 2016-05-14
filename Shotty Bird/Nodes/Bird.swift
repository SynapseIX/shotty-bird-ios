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
        // TODO: replace with animated explosion
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.xScale = xScaleTmp
        explosion.yScale = yScaleTmp
        explosion.position = positionTmp
        explosion.zPosition = zPostionTmp
        (delegate as! GameScene).addChild(explosion)
        
        // TODO: increase game score and move this logic to the contact delegate when missile is done
        delegate?.updateScore()
        
        // Remove the explosion node after 0.3 seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            explosion.runAction(SKAction.removeFromParent())
        }
    }

}
