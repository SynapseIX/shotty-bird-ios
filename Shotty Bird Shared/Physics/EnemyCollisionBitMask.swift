//
//  EnemyCollisionBitMask.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/3/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import Foundation

/// Defines values for collision bit masks in Physics bodies.
struct EnemyCollisionBitMask {
    static let enemy: UInt32 = 0x1 << 0
    static let missile: UInt32 = 0x1 << 1
}
