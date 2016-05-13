//
//  GameUtils.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/12/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import Foundation

class GameUtils {

    class func randomBackground() -> [String] {
        let bg1 = ["bg1_layer1", "bg1_layer2", "bg1_layer3", "bg1_layer4", "bg1_layer5"]
        let bg2 = ["bg2_layer1", "bg2_layer2", "bg2_layer3", "bg2_layer4"]
        let bg3 = ["bg3_layer1", "bg3_layer2", "bg3_layer3", "bg3_layer4", "bg3_layer5"]
        let bg4 = ["bg4_layer1", "bg4_layer2", "bg4_layer3", "bg4_layer4", "bg4_layer5"]
        let bg5 = ["bg5_layer1", "bg5_layer2", "bg5_layer3", "bg5_layer4", "bg5_layer5"]
        let bg6 = ["bg6_layer1", "bg6_layer2", "bg6_layer3", "bg6_layer4", "bg6_layer5"]
        let bg7 = ["bg7_layer1", "bg7_layer2", "bg7_layer3", "bg7_layer4"]
        
        let bgs = [bg1, bg2, bg3, bg4, bg5, bg6, bg7]
        return bgs[Int(arc4random_uniform(UInt32(bgs.count)))]
    }

}
