//
//  AppDelegate.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/5/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        if let gameViewController = window?.rootViewController as? GameViewController {
            let skView = gameViewController.view as! SKView
            
            if skView.scene is MainMenuScene {
                let mainMenuScene = skView.scene as! MainMenuScene
                
                if let audioSession = mainMenuScene.audioManager.audioSession {
                    if !audioSession.otherAudioPlaying {
                        mainMenuScene.audioManager.tryPlayMusic()
                    } else {
                        mainMenuScene.audioManager.audioPlayer?.pause()
                    }
                }
            }
            
            if skView.scene is GameScene {
                let gameScene = skView.scene as! GameScene
                
                if let audioSession = gameScene.audioManager.audioSession {
                    if !audioSession.otherAudioPlaying {
                        gameScene.audioManager.tryPlayMusic()
                    }  else {
                        gameScene.audioManager.audioPlayer?.pause()
                    }
                }
            }
        }
    }


}

