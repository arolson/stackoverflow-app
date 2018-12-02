//
//  ViewControllerExtension.swift
//  Stack Overflowing With Questions
//
//  Created by Andrew Olson on 12/1/18.
//  Copyright © 2018 Andrew Olson. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

extension UIViewController {
    func presentError(message: String) {
        performUIUpdatesOnMain {
            let alert = SCLAlertView()
            alert.showError("Error", subTitle: message)
        }
    }
    
    func showNotification(message: String) {
        performUIUpdatesOnMain {
            let alert = SCLAlertView()
            alert.showInfo("Notice", subTitle: message)
        }
    }
}
