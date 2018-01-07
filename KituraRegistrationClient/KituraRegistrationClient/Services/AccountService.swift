//
//  AccountService.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 5/1/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import RxSwift
import RxCocoa

typealias JSONDictionary = [String: Any]

struct AccountObjectKey {
    
    static let email: String = "email"
    static let pwd: String = "password"
}

enum AuthenticationStatus {
    case none
    case error(AuthenticationError)
    case authorise(AccountModel)
}

enum AuthenticationError: Error {
    case server
    case badReponse
    case badCredentials
}

class AccountService {
    
    static var shared = AccountService()
    
    func register(with email: String, password: String) -> Observable<AuthenticationStatus> {
        let params = [AccountObjectKey.email: email,AccountObjectKey.pwd :password]
        let url = URL.init(string: "http://localhost:8080/register")
        
        var request = URLRequest.init(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        return session.rx.json(request: request)
            .map {
                guard let _ = $0 as? JSONDictionary else {
                    return .error(.badReponse)
                }
                let ac = AccountModel.init(email: email)
                return .authorise(ac)
        }
    }
}
