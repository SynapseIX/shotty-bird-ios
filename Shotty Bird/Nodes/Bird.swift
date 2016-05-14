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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let tmpSize = size
        let tmpPosition = position
        
        runAction(GameAction.playExplosionSoundAction)
        runAction(SKAction.removeFromParent())
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.size = tmpSize
        explosion.position = tmpPosition
        (delegate as! GameScene).addChild(explosion)
        
        // TODO: increase game score and move this logic to the contact delegate when missile is done
        delegate?.updateScore()
        
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            explosion.runAction(SKAction.removeFromParent())
        }
    }

}
