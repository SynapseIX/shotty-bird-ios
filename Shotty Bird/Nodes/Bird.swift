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
    var flightSpeed = 0.0
    
    init(sprites: [String], delegate: GameScoreDelegate) {
        self.sprites = sprites
        self.delegate = delegate
        
        let texture = SKTexture(imageNamed: sprites[0])
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        super.name = "bird"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder not implemented...")
    }

}
