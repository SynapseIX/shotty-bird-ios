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
    
    init(delegate: GameScoreDelegate) {
        let birds = ["bird_fat_green", "bird_normal_blue", "bird_normal_orange", "bird_skinny_green", "bird_skinny_red", "bird_yellow_fat"]
        
        let texture = SKTexture(imageNamed: birds[Int(arc4random_uniform(UInt32(birds.count)))])
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.delegate = delegate
        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        runAction(GameAction.playExplosionSoundAction)
        
        userInteractionEnabled = false
        physicsBody = nil
        
        let texture = SKTexture(imageNamed: "explosion")
        self.texture = texture
        size = texture.size()
        
        // TODO: increase game score and move this logic to the contact delegate when missile is done
        delegate?.updateScore()
        
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.runAction(SKAction.removeFromParent())
        }
    }

}
