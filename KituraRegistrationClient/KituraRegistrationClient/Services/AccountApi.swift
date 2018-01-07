//
//  AccountApi.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 5/1/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class AccountApi {
    
    struct Account {
        let email: String
        static let empty = Account(email: "")
    }
    
    static var shared: AccountApi = AccountApi()
    
    func doRegister(email: String, password: String) -> Observable<Account> {
        return buildRegisterRequestWith(email: email, password: password).map({ json in
            return Account(email: json[AccountObjectKey.email].string ?? "")
        })
    }
    
    private func buildRegisterRequestWith(email: String, password: String) -> Observable<JSON> {
        let params: [String: Any] = [AccountObjectKey.email: email, AccountObjectKey.pwd: password]
        let url = URL.init(string: "http://localhost:8080/register")
        
        var request = URLRequest.init(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        return session.rx.data(request: request).map { try JSON(data: $0) }
    }
}
