//
//  DeviceModel.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/26/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import UIKit

/// Utility that allows device model identification based on device screen size.
struct DeviceModel {
    static let iPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
    static let iPhone14 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 844.0
    static let iPhone14Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 926.0
    static let iPhone14Pro = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 852.0
    static let iPhone14ProMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 932.0
    static let iPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1024.0
    static let iPadPro = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1366.0
    
    /// Determines if the device is a simulator or physical.
    static let isSimulator: Bool = {
        var isSim = false
        
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        
        return isSim
    }()
}

/// Utility struct to read a device screen size.
private struct ScreenSize {
    /// Screen width.
    static let width = UIScreen.main.bounds.size.width
    /// Screen height.
    static let height = UIScreen.main.bounds.size.height
    /// Maximum device screen length.
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    /// Minimum device length.
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

