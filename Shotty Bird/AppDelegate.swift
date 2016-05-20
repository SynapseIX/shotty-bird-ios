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

    func applicationWillResignActive(application: UIApplication) {
        let gameViewController = window?.rootViewController as! GameViewController
        let skView = gameViewController.view as! SKView
        
        if let currentScene = skView.scene {
            if currentScene is GameScene && !skView.paused {
                (currentScene as! GameScene).togglePause()
            }
        }
    }


}

