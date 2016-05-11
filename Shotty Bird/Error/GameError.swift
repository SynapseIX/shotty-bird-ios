//
//  AppError.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/10/16.
//  Copyright © 2016 Jorge Tapia. All rights reserved.
//

import UIKit

class GameError {
    
    class func handleAsAlert(title: String?, message: String?, presentingViewController: UIViewController, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: { action in
            completion?()
        })
        
        alert.addAction(dismissAction)
        presentingViewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func handleAsLog(message: String?) {
        if let message = message {
            NSLog("Error: \(message)")
        }
    }
    
}
