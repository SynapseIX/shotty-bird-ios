//
//  BaseScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 6/29/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Represents the parallax background animation speed.
enum BackgroundSpeed {
    case fast
    case slow
}

/// Base scene.
class BaseScene: SKScene {
    
    /// Determines the speed of the parallax background animation.
    var backgroundSpeed: BackgroundSpeed
    
    /// Node that contains the sky texture.
    private var skyNode : SKSpriteNode!
    /// Sky node clone for parallax effect.
    private var skyNodeNext : SKSpriteNode!
    
    /// Farthestmost hill layer node.
    private var hillLayerNode1: SKSpriteNode!
    /// Clone node for parallax effect.
    private var hillLayerNode1Clone : SKSpriteNode!
    
    /// Mid hill layer node.
    private var hillLayerNode2: SKSpriteNode!
    /// Clone node for parallax effect.
    private var hillLayerNode2Clone : SKSpriteNode!
    
    /// Closes hill layer node.
    private var hillLayerNode3: SKSpriteNode!
    /// Clone node for parallax effect.
    private var hillLayerNode3Clone : SKSpriteNode!
    
    /// Time of last frame rendered.
    private var lastFrameTime: TimeInterval = 0
    
    /// Time since last frame was rendered.
    private var deltaTime: TimeInterval = 0
    
    init(backgroundSpeed: BackgroundSpeed) {
        self.backgroundSpeed = backgroundSpeed
        super.init(size: CGSize(width: 1024, height: 768))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        buildParallaxBackground()
    }
    
    /// Sets up and build the nodes used in the parallax background.
    private func buildParallaxBackground() {
        skyNode = SKSpriteNode(texture: SKTexture(imageNamed: "bg1_layer0"))
        skyNode.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        skyNodeNext = skyNode.copy() as? SKSpriteNode
        skyNodeNext.position = CGPoint(x: skyNode.position.x + skyNode.size.width,
                                       y: skyNode.position.y)
        
        hillLayerNode1 = SKSpriteNode(texture: SKTexture(imageNamed: "bg1_layer1"))
        hillLayerNode1.position = CGPoint(x: size.width / 2.0,
                                            y: size.height - 570)
        
        hillLayerNode1Clone = hillLayerNode1.copy() as? SKSpriteNode
        hillLayerNode1Clone.position = CGPoint(x: hillLayerNode1.position.x - hillLayerNode1.size.width,
                                                y: hillLayerNode1.position.y)
        
        hillLayerNode2 = SKSpriteNode(texture: SKTexture(imageNamed: "bg1_layer2"))
        hillLayerNode2.position = CGPoint(x: size.width / 2.0,
                                            y: size.height - 490)
        
        hillLayerNode2Clone = hillLayerNode2.copy() as? SKSpriteNode
        hillLayerNode2Clone.position = CGPoint(x: hillLayerNode2.position.x - hillLayerNode2.size.width,
                                                y: hillLayerNode2.position.y)
        
        hillLayerNode3 = SKSpriteNode(texture: SKTexture(imageNamed: "bg1_layer3"))
        hillLayerNode3.position = CGPoint(x: size.width / 2.0,
                                            y: size.height - 440)
        
        hillLayerNode3Clone = hillLayerNode3.copy() as? SKSpriteNode
        hillLayerNode3Clone.position = CGPoint(x: hillLayerNode3.position.x - hillLayerNode3.size.width,
                                                y: hillLayerNode3.position.y)

        self.addChild(skyNode)
        self.addChild(skyNodeNext)

        self.addChild(hillLayerNode1)
        self.addChild(hillLayerNode1Clone)

        self.addChild(hillLayerNode2)
        self.addChild(hillLayerNode2Clone)

        self.addChild(hillLayerNode3)
        self.addChild(hillLayerNode3Clone)
    }
    
    /// Animates the position change of background layers to create the parallax effect.
    /// - Parameters:
    ///   - backgroundLayerNode: A parallax background layer node.
    ///   - clonedBackgroundLayerNode: A clone of the background layer node.
    ///   - speed: The desired speed of the animation.
    private func animateBackground(backgroundLayerNode: SKSpriteNode, clonedBackgroundLayerNode: SKSpriteNode, speed: CGFloat) {
        var newPosition = CGPointZero
        
        // For both the sprite and its duplicate:
        for nodeToMove in [backgroundLayerNode, clonedBackgroundLayerNode] {
            
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
        
        let speedMultiplier = backgroundSpeed == .slow ? 0.33 : 1.0
        animateBackground(backgroundLayerNode: hillLayerNode1, clonedBackgroundLayerNode: hillLayerNode1Clone, speed: 200.0 * speedMultiplier)
        animateBackground(backgroundLayerNode: hillLayerNode2, clonedBackgroundLayerNode: hillLayerNode2Clone, speed: 750.0 * speedMultiplier)
        animateBackground(backgroundLayerNode: hillLayerNode3, clonedBackgroundLayerNode: hillLayerNode3Clone, speed: 1500.0 * speedMultiplier)
    }
}
