//
//  GameViewController.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/5/16.
//  Copyright (c) 2016 Jorge Tapia. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    var bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
    let gameCenterHelper = GameCenterHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
        let scene = MainMenuScene(size: CGSize(width: 1024.0, height: 768.0))
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.multipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = false
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
        // Authenticate with Game Center
        gameCenterHelper.authenticateLocalPlayer(self, completion: nil)
        
        // Setup AdMob
        setupAdMob()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - AdMob methods
    
    private func setupAdMob() {
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        let adSize = DeviceModel.iPad || DeviceModel.iPadPro ? kGADAdSizeLargeBanner: kGADAdSizeBanner
        
        bannerView = GADBannerView(adSize: adSize)
        let size = bannerView.frame.size
        
        bannerView.frame = CGRect(x: CGRectGetMidX(view.frame) - size.width / 2, y: CGRectGetMaxY(view.frame) - size.height, width: size.width, height: size.height)
        bannerView.adUnitID = "ca-app-pub-5774553422556987/1715679355"
        bannerView.rootViewController = self
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "f97ebef80402c771d179c92d8c815c02"]; // TODO: Remove this when submitting to App Store
        
        bannerView.loadRequest(request)
        view.addSubview(bannerView)
        
        bannerView.hidden = true
    }
}
