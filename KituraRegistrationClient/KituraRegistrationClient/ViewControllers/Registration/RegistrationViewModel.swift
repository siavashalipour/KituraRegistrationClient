//
//  AccountViewModel.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 5/1/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

struct RegistrationViewModel {
  
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
  func onRegister(input: UIViewController) -> CocoaAction {
    return CocoaAction { _ in
      return AccountService.shared.register(with: self.emailVariable.value, password: self.passwordVariable.value).flatMap { status -> Observable<Void> in
        switch status {
        case .none, .error(_):
          // TODO: Show Error
          break
        case .authorise(let account):
          DispatchQueue.main.async {
            self.navigator.show(segue: .loggedIn(LoggedInViewModel(with: account, navigator: self.navigator)), sender: input)
          }
        }
        return Observable.just(())
      }
    }
  }
  func onAlreadyHaveAnAccount(input: UIViewController) -> CocoaAction {
    return Action {
      self.navigator.show(segue: .signin, sender: input)
      return Observable.just(())
    }
  }
}

