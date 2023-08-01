//
//  GameViewController.swift
//  Shotty Bird iOS
//
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import GameplayKit
import UIKit
import SpriteKit

/// Game's root view controller.
class GameViewController: UIViewController {
    
    @IBOutlet weak var loadingOverlay: UIView!
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenuScene(backgroundSpeed: .slow)
        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = false
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

