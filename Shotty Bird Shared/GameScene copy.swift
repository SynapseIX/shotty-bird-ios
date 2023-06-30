//
//  GameScene.swift
//  Shotty Bird Shared
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Main game scene.
class GameScene: SKScene {
    
    // Sky
    var skyNode : SKSpriteNode
    var skyNodeNext : SKSpriteNode
    
    // Foreground hills
    var distantHillsNode : SKSpriteNode
    var distantHillsNodeNext : SKSpriteNode
    
    // Time of last frame
    var lastFrameTime: TimeInterval = 0
    
    // Time since last frame
    var deltaTime: TimeInterval = 0
    
    override init(size: CGSize) {
        skyNode = SKSpriteNode(texture: SKTexture(imageNamed: "bg1_layer5"))
        skyNode.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        skyNodeNext = skyNode.copy() as! SKSpriteNode
        skyNodeNext.position = CGPoint(x: skyNode.position.x + skyNode.size.width,
                                       y: skyNode.position.y)
        
        // Prepare the background hill sprites
        distantHillsNode = SKSpriteNode(texture: SKTexture(imageNamed: "bg1_layer1"))
        distantHillsNode.position = CGPoint(x: size.width / 2.0,
                                            y: size.height - 284)
        
        distantHillsNodeNext = distantHillsNode.copy() as! SKSpriteNode
        distantHillsNodeNext.position = CGPoint(x: distantHillsNode.position.x - distantHillsNode.size.width,
                                                y: distantHillsNode.position.y)
        
        super.init(size: size)
        
        self.addChild(skyNode)
        self.addChild(skyNodeNext)
        
        self.addChild(distantHillsNode)
        self.addChild(distantHillsNodeNext)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // Move a pair of sprites leftward based on a speed value;
    // when either of the sprites goes off-screen, move it to the
    // right so that it appears to be seamless movement
    func moveNode(node: SKSpriteNode, nextNode: SKSpriteNode, speed: CGFloat) -> Void {
        var newPosition: CGPoint = .zero
        
        for nodeToMove in [node, nextNode] {
            // Shift the sprite rightward based on the speed
            newPosition = nodeToMove.position
            newPosition.x += speed * deltaTime
            nodeToMove.position = newPosition
            
            // If this sprite is now offscreen (i.e., its leftmost edge is
            // farther right than the scene's rightmost edge):
            if nodeToMove.frame.minX > self.frame.maxX {
                // Shift it over so that it's now to the immediate left
                // of the other sprite.
                // This means that the two sprites are effectively
                // leap-frogging each other as they both move.
                nodeToMove.position =
                CGPoint(x: nodeToMove.position.x - nodeToMove.size.width * 2,
                        y: nodeToMove.position.y)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        deltaTime = currentTime - lastFrameTime
        lastFrameTime = currentTime
        moveNode(node: distantHillsNode, nextNode: distantHillsNodeNext, speed: 4000.0)
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
}
#endif

