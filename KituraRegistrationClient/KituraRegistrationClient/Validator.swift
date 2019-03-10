//
//  Validator.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 7/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation

struct Validator {
  
  static func validate(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }
  
  static func validate(password: String) -> Bool {
    let capitalLetterRegEx  = ".*[A-Z]+.*"
    let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
    return texttest.evaluate(with: password) && password.count > 8
  }
}
