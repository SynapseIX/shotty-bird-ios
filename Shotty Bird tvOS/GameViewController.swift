//
//  GameViewController.swift
//  Shotty Bird tvOS
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MainMenuScene(backgroundSpeed: .slow)
        
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }
}

