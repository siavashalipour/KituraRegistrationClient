//
//  LoggedInViewController.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 7/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxCocoa
import SnapKit

final class LoggedInViewController: UIViewController {
  
  
  private var navigator: Navigator!
  private var viewModel: LoggedInViewModel!
  private let bag = DisposeBag()
  private lazy var emailLabel = UILabel().then {
    $0.textColor = .black
    $0.textAlignment = .left
  }
  private lazy var addThingsButton = UIButton().then { (btn) in
    btn.setTitle("Add Things", for: .normal)
    btn.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), for: .normal)
    btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    btn.layer.cornerRadius = 16
    btn.layer.masksToBounds = true
  }
  private lazy var logoutButton = UIButton().then { (btn) in
    btn.setTitle("Log Out", for: .normal)
    btn.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), for: .normal)
    btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    btn.layer.cornerRadius = 16
    btn.layer.masksToBounds = true
  }
  private lazy var thingsTable = UITableView().then { (table) in
    table.register(ThingsCell.self, forCellReuseIdentifier: String(describing: ThingsCell.self))
    table.estimatedRowHeight = 70
    table.allowsSelection = false
    table.dataSource = self
    table.delegate = self
  }
  // TODO: Add table to show the items
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: LoggedInViewModel) -> LoggedInViewController {
    return storyboard.instantiateViewController(ofType: LoggedInViewController.self).then { vc in
      vc.navigator = navigator
      vc.viewModel = viewModel
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.setHidesBackButton(true, animated: false)
    title = "Logged In"
    setupUI()
    bindViewMode()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  private func bindViewMode() {
    viewModel.emailValue.asObservable().bind(to: emailLabel.rx.text).disposed(by: bag)
    addThingsButton.rx.action = viewModel.onAddThing()
    logoutButton.rx.action = viewModel.onLogout(input: self)
    viewModel.things.asDriver().drive(onNext: { [weak self] _ in self?.thingsTable.reloadData() }).disposed(by: bag)
  }
  private func setupUI() {
    _ = view.subviews.map { $0.removeFromSuperview() }
    
    view.addSubview(emailLabel)
    emailLabel.snp.makeConstraints { (make) in
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(30)
      make.left.equalTo(Constants.margin)
    }
    
    view.addSubview(logoutButton)
    logoutButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(-40)
      make.left.equalTo(Constants.margin)
      make.height.equalTo(Constants.btnHeight)
      make.right.equalTo(-Constants.margin)
    }
    view.addSubview(addThingsButton)
    addThingsButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(logoutButton.snp.top).offset(-8)
      make.left.equalTo(Constants.margin)
      make.height.equalTo(Constants.btnHeight)
      make.right.equalTo(-Constants.margin)
    }
    
    view.addSubview(thingsTable)
    thingsTable.snp.makeConstraints { (make) in
      make.top.equalTo(emailLabel.snp.bottom).offset(10)
      make.bottom.equalTo(addThingsButton.snp.top).offset(-8)
      make.left.right.equalToSuperview()
    }
  }
}
extension LoggedInViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.things.value?.count ?? 0
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(ofType: ThingsCell.self)
    if let item = viewModel.things.value?[indexPath.row] {
      cell.config(with: item)
    }
    return cell
  }
}
