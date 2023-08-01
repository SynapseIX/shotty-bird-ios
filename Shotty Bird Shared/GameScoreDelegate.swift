//
//  GameScoreDelegate.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/4/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import Foundation

/// Delegate object in charge of updating the game score.
protocol GameScoreDelegate {
    /// Executes logic to update the game score.
    mutating func updateScore(grantExtraLife: Bool)
}

