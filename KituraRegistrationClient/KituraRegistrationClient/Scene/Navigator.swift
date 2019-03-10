//
//  Navigator.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 7/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Navigator {
  lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
  
  // MARK: - segues list
  enum Segue {
    case createAccount
    case loggedIn(LoggedInViewModel)
  }
  
  // MARK: - invoke a single segue
  func show(segue: Segue, sender: UIViewController) {
    switch segue {
    case .createAccount:
      show(target: RegistrationViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard), sender: sender)
    case .loggedIn(let user):
      show(target: LoggedInViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: user), sender: sender)
    }
    
  }
  
  private func show(target: UIViewController, sender: UIViewController) {
    if let nav = sender as? UINavigationController {
      //push root controller on navigation stack
      nav.pushViewController(target, animated: false)
      return
    }
    
    if let nav = sender.navigationController {
      //add controller to navigation stack
      nav.pushViewController(target, animated: true)
    } else {
      //present modally
      sender.present(target, animated: true, completion: nil)
    }
  }
}

