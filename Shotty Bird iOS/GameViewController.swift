//
//  GameViewController.swift
//  Shotty Bird iOS
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let scene = MainMenuScene(backgroundSpeed: .slow)
        let scene = GameScene(backgroundSpeed: .fast)
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
//        skView.showsPhysics = true
        skView.ignoresSiblingOrder = false
        skView.presentScene(scene)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeLeft
        } else {
            return [.landscapeLeft, .landscapeRight]
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

