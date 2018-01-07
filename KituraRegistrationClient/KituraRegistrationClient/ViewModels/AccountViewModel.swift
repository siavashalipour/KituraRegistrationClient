//
//  AccountViewModel.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 5/1/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import RxSwift
import RxCocoa

struct AccountViewModel {

    var account: Driver<AccountModel>?
    let credintialValid: Driver<Bool>

    init(email: Driver<String>, password: Driver<String>) {

        let emailValid = email
            .distinctUntilChanged()
            .throttle(0.3)
            .map{ $0.utf8.count > 3}

        let passwordValid = password
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 3}

        credintialValid = Driver.combineLatest(emailValid, passwordValid) { $0 && $1 }
    }

    func register(with email: String, password: String) -> Observable<AuthenticationStatus> {
        return AccountService.shared.register(with: email,password: password)
    }
    
}

struct AccountModel {
    
    let email: String
}
