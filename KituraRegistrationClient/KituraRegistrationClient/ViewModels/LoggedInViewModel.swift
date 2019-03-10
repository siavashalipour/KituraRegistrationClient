//
//  LoggedInViewModel.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 7/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action

struct LoggedInViewModel {
  
  // output:
  let emailValue = Variable<String>("")
  let things = Variable<[Thing]?>(nil)
  
  // internal:
  private let account: Account
  private let navigator: Navigator
  init(with account: Account, navigator: Navigator) {
    emailValue.value = account.email
    self.account = account
    self.navigator = navigator
  }
  
  func onAddThing() -> CocoaAction {
    return Action {
      let thing = [Thing.init(uuid: NSUUID.init().uuidString)]
      return AccountService.shared.add(things: thing, email: self.account.email, password: self.account.password).do(onNext: { (status) in
        switch status {
        case .authorise(let account):
          self.things.value = account.things.sorted(by: { $0.uuid > $1.uuid} )
        case .error(let error):
          print("!!!! \(error)")
        case .none:
          print("!!!! NONE")
        }
      }).flatMap { _ -> Observable<Void> in
        return Observable.just(())
      }
    }
  }
  
  func onLogout(input: UIViewController) -> CocoaAction {
    return Action {
      self.navigator.show(segue: .createAccount, sender: input)
      return Observable.just(())
    }
  }
}
