//
//  ErrorHandler.swift
//  LifeSign
//
//  Created by Haider Ali on 25/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler: NSObject {
    
    static func handleError(errors: [String], inController: UIViewController) {
        var message = ""
        for error in errors {
            message = message + "\n" + error
        }
        AlertController.showAlert(witTitle: AppStrings.getAlertString(), withMessage: message, style: .danger, controller: inController)
    }
}
