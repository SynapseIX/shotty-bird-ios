//
//  TutorialScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/17/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene {
    
    var bgLayers = [String]()
    var parallaxBackground: ParallaxBackground?
    
    let zPositionMenuItems = CGFloat(Int.max)
    var muted = false
    
    // MARK: - Scene methods
    
    override func didMoveToView(view: SKView) {
        // Add parallax background
        addParallaxBackground()
        
        // Setup tutorial textures
        let textures = [SKTexture(imageNamed: "tutorial_1"), SKTexture(imageNamed: "tutorial_2"), SKTexture(imageNamed: "tutorial_3"), SKTexture(imageNamed: "tutorial_4"), SKTexture(imageNamed: "tutorial_5")]
        
        // Setup animation actions
        let spriteAnimationAction = SKAction.animateWithTextures(textures, timePerFrame: 0.45)
        let repeatAnimationAction = SKAction.repeatActionForever(spriteAnimationAction)
        
        // Setup and add tutorial node
        let tutorial = SKSpriteNode(texture: textures.first)
        
        // Scale based on device model
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            tutorial.setScale(0.8)
        }
        
        tutorial.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        tutorial.runAction(repeatAnimationAction)
        addChild(tutorial)
    }
    
    override func update(currentTime: NSTimeInterval) {
        parallaxBackground?.update()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let gameScene = getGameScene() {
            gameScene.muted = muted
            gameScene.bgLayers = parallaxBackground!.bgLayers
            
            let transition = SKTransition.crossFadeWithDuration(1.0)
            view?.presentScene(gameScene, transition: transition)
        }
    }
    
    // MARK: - User interface methods
    
    private func addParallaxBackground() {
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgLayers, size: size, fastestSpeed: 2.0, speedDecrease: 0.6)
        addChild(parallaxBackground!)
    }
    
    private func getGameScene() -> GameScene? {
        if let scene = GameScene(fileNamed:"GameScene") {
            scene.scaleMode = .AspectFill
            return scene
        }
        
        return nil
    }

}
