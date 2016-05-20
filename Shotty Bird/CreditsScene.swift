//
//  CreditsScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/18/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import SpriteKit

class CreditsScene: SKScene {
    
    var bgLayers = [String]()
    var parallaxBackground: ParallaxBackground?
    
    let zPositionMenuItems = CGFloat(Int.max)
    
    override func didMoveToView(view: SKView) {
        // Add parallax background
        addParallaxBackground()
        
        // Add credits node
        let itsProf = SKSpriteNode(imageNamed: "itsprof")
        itsProf.name = "itsprof"
        itsProf.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        itsProf.zPosition = zPositionMenuItems
        addChild(itsProf)
        
        // Add back button
        let backButton = SKSpriteNode(imageNamed: "back_button")
        backButton.name = "backButton"
        
        if DeviceModel.iPhone4 {
            backButton.position = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height + 20)
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
            backButton.position = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height - 20)
        } else {
            backButton.position = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height * 2)
        }
        
        backButton.zPosition = zPositionMenuItems
        addChild(backButton)
    }
    
    override func update(currentTime: NSTimeInterval) {
        parallaxBackground?.update()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let backButton = childNodeWithName("backButton") {
                if backButton.containsPoint(location) {
                    let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
                    view?.presentScene(getMainMenuScene(), transition: transition)
                }
            }
            
            if let itsProf = childNodeWithName("itsprof") {
                if itsProf.containsPoint(location) {
                    if let twitterURL = NSURL(string: "http://twitter.com/itsProf") {
                        UIApplication.sharedApplication().openURL(twitterURL)
                    }
                }
            }
        }
    }
    
    // MARK: - User interface methods
    
    private func addParallaxBackground() {
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgLayers, size: size, fastestSpeed: 2.0, speedDecrease: 0.25)
        addChild(parallaxBackground!)
    }
    
    private func getMainMenuScene() -> MainMenuScene {
        // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
        let scene = MainMenuScene(size: CGSize(width: 1024.0, height: 768.0))
        scene.scaleMode = .AspectFill
        
        return scene
    }
}
