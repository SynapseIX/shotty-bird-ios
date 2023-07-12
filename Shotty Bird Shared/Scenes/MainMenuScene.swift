//
//  MainMenuScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 6/29/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import SpriteKit

/// Main menu scene.
class MainMenuScene: BaseScene {
    override init(backgroundSpeed: BackgroundSpeed = .slow) {
        super.init(backgroundSpeed: backgroundSpeed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension MainMenuScene {
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
extension MainMenuScene {
    override func mouseDown(with event: NSEvent) {
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
}
#endif

