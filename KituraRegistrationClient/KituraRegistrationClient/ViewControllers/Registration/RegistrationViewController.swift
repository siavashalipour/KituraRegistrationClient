//
//  ViewController.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 5/1/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import RxGesture

class RegistrationViewController: UIViewController {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var pwdField: UITextField!
  @IBOutlet weak var registerBtn: UIButton!
  @IBOutlet weak var alreadyHaveAccountButton: UIButton!
  
  private var navigator: Navigator!
  private var viewModel: RegistrationViewModel!
  private let bag = DisposeBag()
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> RegistrationViewController {
    return storyboard.instantiateViewController(ofType: RegistrationViewController.self).then { vc in
      vc.navigator = navigator
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
    registerBtn.isEnabled = false
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Create Account"
    self.navigationItem.setHidesBackButton(true, animated: false)
    bindViewModel()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  private func bindViewModel() {
    view.rx.tapGesture().subscribe(onNext: { (_) in
      self.view.endEditing(true)
    })
    .disposed(by: bag)
    
    viewModel = RegistrationViewModel.init(email: emailField.rx.text.orEmpty.asDriver(), password: pwdField.rx.text.orEmpty.asDriver(), navigator: navigator)
    
    viewModel.emailValid.drive(onNext: { (isCorrect) in
      self.emailField.textColor = isCorrect ? UIColor.black : UIColor.red
    })
    .disposed(by: bag)
    
    viewModel.passwordValid.drive(onNext: { (isCorrect) in
      self.pwdField.textColor = isCorrect ? UIColor.black : UIColor.red
    })
    .disposed(by: bag)
    
    viewModel.credintialValid.drive(registerBtn.rx.isEnabled).disposed(by: bag)
    registerBtn.rx.action = viewModel.onRegister(input: self)
    alreadyHaveAccountButton.rx.action = viewModel.onAlreadyHaveAnAccount(input: self)
  }
  private func setupUI() {
    registerBtn.setBackgroundImage(UIImage.from(color: .lightGray), for: .disabled)
    registerBtn.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.2196078431, green: 0.4352941176, blue: 0.5568627451, alpha: 1)), for: .normal)
    registerBtn.layer.cornerRadius = 16
    registerBtn.layer.masksToBounds = true 
  }
}

