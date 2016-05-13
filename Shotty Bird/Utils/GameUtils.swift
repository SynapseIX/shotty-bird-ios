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
        let bg1 = ["bg1_layer1", "bg1_layer2", "bg1_layer3", "bg1_layer4", "bg1_layer5"];
        let bg2 = ["bg2_layer1", "bg2_layer2", "bg2_layer3", "bg2_layer4"];
        
        let bgs = [bg1, bg2]
        return bgs[Int(arc4random()) % bgs.count]
    }

}
