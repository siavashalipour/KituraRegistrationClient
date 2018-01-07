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
    
//    let status = Variable(AuthenticationStatus.none)
//
    static var shared = AccountService()
//
//    fileprivate init() {}
//
//    func login(with email: String, password: String) -> Observable<AuthenticationStatus> {
//        let params: [String: Any] = ["AppleDeviceId":"", "Email":email,"Password":password,"AndroidUniqueId":""]
//        let url = URL.init(string: "[]")
//
//        var request = URLRequest.init(url: url!)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//        request.httpBody = jsonData
//        request.httpMethod = "POST"
//
//        let session = URLSession.shared
//
//        return session.rx.json(request: request)
//            .map {
//                guard let json = $0 as? JSONDictionary else {
//                    return .error(.badReponse)
//                }
//                if let fname = json["FirstName"] as? String, let lname = json["LastName"] as? String {
//                    let ac = AccountModel.init(firstName: fname, lastName: lname, email: email)
//                    return .authorise(ac)
//                } else {
//                    return .error(.badReponse)
//                }
//        }
//    }
    
    func register(with email: String, password: String) -> Observable<AuthenticationStatus> {
        let params: [String: Any] = [AccountObjectKey.email: email,AccountObjectKey.pwd :password]
        let url = URL.init(string: "[]")
        
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
