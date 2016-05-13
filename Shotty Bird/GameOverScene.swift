//
//  GameOverScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/11/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var bgLayers = [String]()
    var parallaxBackground: ParallaxBackground?
    
    let audioManager = AudioManager(file: "game_over_music", type: "mp3", loop: false)
    var muted = false
    
    let zPositionBg = CGFloat(-1)
    let zPositionMenuItems = CGFloat(Int.max)

    override func didMoveToView(view: SKView) {
        audioManager.audioPlayer?.volume = !muted ? 1.0 : 0.0
        audioManager.tryPlayMusic()
        
        // Add background
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgLayers, size: size, fastestSpeed: 2.0, speedDecrease: 0.25)
        addChild(parallaxBackground!)
        
        // TODO: Replace this with image and complete scene
        let label = ASAttributedLabelNode(size: size)
        
        if let font =  UIFont(name: "Kenney-Bold", size: 90) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Center
            
            let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName: UIColor.whiteColor(),
                              NSStrokeColorAttributeName: UIColor.blackColor(), NSStrokeWidthAttributeName: -10, NSParagraphStyleAttributeName: paragraphStyle]
            
            label.attributedString = NSAttributedString(string: "Game Over", attributes: attributes)
            label.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
            label.zPosition = zPositionMenuItems
            addChild(label)
        }
    }
    
    override func willMoveFromView(view: SKView) {
        for node in children {
            node.removeFromParent()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // TODO: setup this correctly
        audioManager.stopMusic()
        let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
        view?.presentScene(getMainMenuScene(), transition: transition)
    }
    
    override func update(currentTime: NSTimeInterval) {
        parallaxBackground?.update()
    }
    
    private func getMainMenuScene() -> MainMenuScene {
        // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
        let scene = MainMenuScene(size: CGSize(width: 1024.0, height: 768.0))
        scene.muted = muted
        scene.scaleMode = .AspectFill
        
        return scene
    }
    
}
