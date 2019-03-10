//
//  Storyboard+.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 7/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import UIKit

extension UIStoryboard {
  func instantiateViewController<T>(ofType type: T.Type) -> T {
    return instantiateViewController(withIdentifier: String(describing: type)) as! T
  }
}
