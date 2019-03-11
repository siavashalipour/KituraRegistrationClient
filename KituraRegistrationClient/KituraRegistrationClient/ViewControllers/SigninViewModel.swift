//
//  SigninViewModel.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 11/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct SigninViewModel {
  
  // input
  let emailValid: Driver<Bool>
  let passwordValid: Driver<Bool>
  
  // output
  let credintialValid: Driver<Bool>
  
  private let navigator: Navigator
  private let emailVariable = Variable<String>("")
  private let passwordVariable = Variable<String>("")
  private let bag = DisposeBag()
  
  init(email: Driver<String>, password: Driver<String>, navigator: Navigator) {
    emailValid = email.map{ Validator.validate(email: $0) }
    passwordValid = password.map { Validator.validate(password: $0) }
    credintialValid = Driver.combineLatest(emailValid, passwordValid) { $0 && $1 }
    
    email.drive(emailVariable).disposed(by: bag)
    password.drive(passwordVariable).disposed(by: bag)
    self.navigator = navigator
    
  }
  
  func onLogin(input: UIViewController) -> CocoaAction {
    return Action { _ in
      AccountService.shared.login(email: self.emailVariable.value, password: self.passwordVariable.value).flatMap { response -> Observable<Void> in
        switch response {
        case .authorise(let acc):
          let vm = LoggedInViewModel.init(with: acc, navigator: self.navigator)
          DispatchQueue.main.async {
            self.navigator.show(segue: .loggedIn(vm), sender: input)
          }
        case .none,.error(_):
          break // handle error
        }
        return Observable.just(())
      }
    }
  }
}
