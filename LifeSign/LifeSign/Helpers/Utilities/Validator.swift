//
//  Validator.swift
//  LifeSign
//
//  Created by Haider Ali on 26/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import UIKit

class Validator: NSObject {
    
    static func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    static func validatePassword(password: String) -> Bool {
        /* let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,}$"
        
        /*
         
         ^                         Start anchor
         (?=.*[A-Z])               Ensure string has one uppercase letters.
         (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
         (?=.*[A-Z].*[A-Z].*[A-Z]) Ensure string has three uppercase letters.
         (?=.*[!@#$&*])            Ensure string has one special case letter.
         (?=.*[!@#$&*].*[!@#$&*])  Ensure string has two special case letter.
         (?=.*[0-9].*[0-9])        Ensure string has two digits.
         (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
         .{8}                      Ensure string is of fix length 8.
         .{8,}                     Ensure string is of minimum length 8.
         .{8,10}                   Ensure string is of minimum length 8 and maximum length 10.
         $                         End anchor.
         
         */
         return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) */
        return password.count == 6 || password.count > 6
    }
}
