//
//  AccountApi.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 5/1/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation

class AccountApi {
//    struct Account {
//        let name: String
//        let address: String
//        let phone: String
//        
//        static let empty = Account(name: "", address: "", phone: "")
//    }
//    static var shared: AccountApi {
//        return AccountApi()
//    }
//    func doLoginWith(username: String, password: String) -> Observable<Account> {
//        return buildLoginRequestWith(username: username, password: password).map({ json in
//            return Account(name: json[""].string ?? "",
//                           address: json[""].string ?? "",
//                           phone: json[""].string ?? "")
//        })
//    }
//    
//    private func buildLoginRequestWith(username: String, password: String) -> Observable<JSON> {
//        let params: [String: Any] = ["AppleDeviceId":"", "Email":username,"Password":password,"AndroidUniqueId":""]
//        let url = URL.init(string: "https://connectdev1.mobileden.com.au/api/prod/e72f1bbf-27f5-440a-a9da-de763d9aaa08/1/7wp28dKFv5APhzDoraUZKve8VSY6Z50H/Authentication/Login?returnUserDetails=true&?expiry=false")
//        
//        var request = URLRequest.init(url: url!)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//        request.httpBody = jsonData
//        request.httpMethod = "GET"
//        
//        let session = URLSession.shared
//        
//        return session.rx.data(request: request).map { JSON(data: $0) }
//    }
}
