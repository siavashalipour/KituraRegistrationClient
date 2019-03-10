//
//  AccountService.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 5/1/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON

typealias JSONDictionary = [String: Any]

struct AccountObjectKey {
  
  static let email: String = "email"
  static let pwd: String = "password"
  static let things: String = "things"
}

enum AuthenticationStatus {
  case none
  case error(AuthenticationError)
  case authorise(Account)
}

enum AuthenticationError: Error {
  case server
  case badReponse
  case badCredentials
}

class AccountService {
  
  static var shared = AccountService()
  let baseURL = URL.init(string: "http://localhost:8080")!
  
  func register(with email: String, password: String) -> Observable<AuthenticationStatus> {
    let account = Account.init(email: email, password: password, things: [])
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(account) else { return Observable.just(AuthenticationStatus.error(AuthenticationError.server)) }
    return buildRequest(path: "register", jsonData: data).map() { data in
      let decoder = JSONDecoder()
      do {
        let accountObj: Account = try decoder.decode(Account.self, from: data)
        return AuthenticationStatus.authorise(accountObj)
      }
      catch let error {
        print("!!! \(error)")
        return AuthenticationStatus.none
      }
    }
  }
  func add(things: [Thing], email: String, password: String) -> Observable<AuthenticationStatus> {
    let account = Account.init(email: email, password: password, things: things)
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(account) else { return Observable.just(AuthenticationStatus.error(AuthenticationError.server)) }
    return buildRequest(path: "add", jsonData: data).map() { data in
      let decoder = JSONDecoder()
      do {
        let accountObj: Account = try decoder.decode(Account.self, from: data)
        return AuthenticationStatus.authorise(accountObj)
      }
      catch let error {
        print("!!! \(error)")
        return AuthenticationStatus.none
      }
    }
  }
  private func buildRequest(method: String = "POST", path: String, jsonData: Data) -> Observable<Data> {
    
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest.init(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    request.httpMethod = method
    
    let session = URLSession.shared
    
    return session.rx.data(request: request)
  }
}
