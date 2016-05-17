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
        addParallaxBackground()
        
        // Add tap to shoot node
        let tapToShoot = SKSpriteNode(imageNamed: "tap_to_shoot")
        tapToShoot.zPosition = zPositionMenuItems
        
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            tapToShoot.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame) - tapToShoot.size.height - 20)
        } else {
            tapToShoot.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame) - tapToShoot.size.height)
        }
        
        addChild(tapToShoot)
        
        // Add static explosion node
        let explosion = SKSpriteNode(imageNamed: "explosion_tutorial")
        explosion.xScale = 0.3
        explosion.yScale = 0.3
        explosion.zPosition = zPositionMenuItems
        explosion.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        addChild(explosion)
        
        // Add time your shots node
        let timeYourShots = SKSpriteNode(imageNamed: "time_your_shots")
        timeYourShots.zPosition = zPositionMenuItems
        
        if DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus {
            timeYourShots.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + timeYourShots.size.height + 20)
        } else {
            timeYourShots.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + timeYourShots.size.height)
        }
        
        addChild(timeYourShots)
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
        parallaxBackground?.setUpBackgrounds(bgLayers, size: size, fastestSpeed: 2.0, speedDecrease: 0.25)
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
