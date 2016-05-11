//
//  DeviceModel.swift
//  Footprints
//
//  Created by Jorge Tapia on 11/11/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit

struct DeviceModel {
    static let iPhone4 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength < 568.0
    static let iPhone5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 568.0
    static let iPhone6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 667.0
    static let iPhone6Plus = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 736.0
    static let iPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.maxLength == 1024.0
}

private struct ScreenSize {
    static let width = UIScreen.mainScreen().bounds.size.width
    static let height = UIScreen.mainScreen().bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}
