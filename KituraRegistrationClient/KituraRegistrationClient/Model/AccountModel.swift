//
//  AccountModel.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 8/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation

typealias Codable = Decodable & Encodable

struct Account: Codable {
  
  let email: String
  let password: String
  var things: [Thing]
  
}

struct Thing: Codable {
  let uuid: String
}
