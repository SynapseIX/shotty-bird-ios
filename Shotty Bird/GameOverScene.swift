//
//  GameOverScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/11/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let audioManager = AudioManager(file: "game_over_music", type: "mp3", loop: false)
    var muted = false
    
    let zPositionBg = CGFloat(-1)
    let zPositionMenuItems = CGFloat(Int.max)

    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        
        if DeviceModel.iPad {
            background.xScale = 0.7
            background.yScale = 0.7
        } else if DeviceModel.iPhone4 {
            background.xScale = 0.65
            background.yScale = 0.65
        } else {
            background.xScale = 0.55
            background.yScale = 0.55
        }
        
        background.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        background.zPosition = zPositionBg
        addChild(background)
        
        // Replace this with image
        let gameOverLabel = SKLabelNode(fontNamed:"Kenney-Bold")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 90
        gameOverLabel.zPosition = zPositionMenuItems
        gameOverLabel.position = CGPoint(x:CGRectGetMidX(frame), y:CGRectGetMidY(frame))
        addChild(gameOverLabel)
        
        audioManager.tryPlayMusic()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // TODO: setup this correctly
        audioManager.stopMusic()
        let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
        view?.presentScene(getMainMenuScene(), transition: transition)
    }
    
    private func getMainMenuScene() -> MainMenuScene {
        // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
        let scene = MainMenuScene(size: CGSize(width: 1024.0, height: 768.0))
        scene.scaleMode = .AspectFill
        
        return scene
    }
    
}
