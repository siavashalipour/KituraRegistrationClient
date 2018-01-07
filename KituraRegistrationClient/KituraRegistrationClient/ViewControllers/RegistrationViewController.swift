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

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerBtn.setTitleColor(.white, for: .normal)
        registerBtn.setTitleColor(.lightGray, for: .disabled)
        
        let vm = AccountViewModel.init(email: emailField.rx.text.orEmpty.asDriver(), password: pwdField.rx.text.orEmpty.asDriver())
        
        vm.credintialValid
            .drive(onNext: { (valid) in
                self.registerBtn.isEnabled = valid
            })
            .disposed(by: bag)
        
        registerBtn.rx.tap
            .withLatestFrom(vm.credintialValid)
            .filter{ $0 }
            .flatMapLatest { [unowned self] valid -> Observable<AuthenticationStatus> in
                vm.register(with: self.emailField.text!, password: self.pwdField.text!)
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { autenticationStatus in
                switch autenticationStatus {
                case .none:
                    break
                case .authorise(let ac):
                    print("\(ac.email)")
                    break
                case .error(let error):
                    print(error)
                }
            })
            .disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

