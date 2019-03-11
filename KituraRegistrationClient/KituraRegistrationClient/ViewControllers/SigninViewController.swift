//
//  SigninViewController.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 11/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

final class SigninViewController: UIViewController {
  
  private lazy var emailField: UITextField = {
    let txt = UITextField()
    txt.textAlignment = .left
    txt.placeholder = "Email"
    txt.keyboardType = .emailAddress
    txt.borderStyle = .roundedRect
    txt.autocapitalizationType = .none
    return txt
  }()
  
  private lazy var pwdField: UITextField = {
    let txt = UITextField()
    txt.textAlignment = .left
    txt.placeholder = "Password"
    txt.keyboardType = .asciiCapable
    txt.isSecureTextEntry = true
    txt.borderStyle = .roundedRect
    return txt
  }()

  private lazy var loginButton: UIButton = {
    let btn = UIButton()
    btn.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)), for: .disabled)
    btn.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), for: .normal)
    btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .disabled)
    btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    btn.setTitle("Log in", for: .normal)
    btn.layer.cornerRadius = 16
    btn.layer.masksToBounds = true
    return btn
  }()
  private var navigator: Navigator!
  private var viewModel: SigninViewModel!
  private let bag = DisposeBag()
  
  static func createWith(navigator: Navigator) -> SigninViewController {
    return SigninViewController().then { vc in
      vc.navigator = navigator
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loginButton.isEnabled = false
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()
  }
  
  private func setupUI() {
    _ = view.subviews.map { $0.removeFromSuperview() }
    
    view.backgroundColor = .white
    
    view.addSubview(emailField)
    emailField.snp.makeConstraints { (make) in
      make.left.equalTo(16)
      make.right.equalTo(-16)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
      make.height.equalTo(Constants.txtFieldHeight)
    }
    
    view.addSubview(pwdField)
    pwdField.snp.makeConstraints { (make) in
      make.left.right.equalTo(emailField)
      make.top.equalTo(emailField.snp.bottom).offset(10)
      make.height.equalTo(Constants.txtFieldHeight)
    }
    
    view.addSubview(loginButton)
    loginButton.snp.makeConstraints { (make) in
      make.left.equalTo(16)
      make.height.equalTo(Constants.btnHeight)
      make.right.equalTo(-16)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
    }
    
  }
  
  private func bindViewModel() {
    let viewModel = SigninViewModel.init(email: emailField.rx.text.orEmpty.asDriver(), password: pwdField.rx.text.orEmpty.asDriver(), navigator: navigator)
    
    view.rx.tapGesture().subscribe(onNext: { (_) in
      self.view.endEditing(true)
    })
      .disposed(by: bag)
    
    viewModel.emailValid.drive(onNext: { (isCorrect) in
      self.emailField.textColor = isCorrect ? UIColor.black : UIColor.red
    })
      .disposed(by: bag)
    
    viewModel.passwordValid.drive(onNext: { (isCorrect) in
      self.pwdField.textColor = isCorrect ? UIColor.black : UIColor.red
    })
      .disposed(by: bag)
    
    viewModel.credintialValid.drive(loginButton.rx.isEnabled).disposed(by: bag)
    loginButton.rx.action = viewModel.onLogin(input: self)
    
  }
}
