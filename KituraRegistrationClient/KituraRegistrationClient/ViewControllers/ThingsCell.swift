//
//  ThingsCell.swift
//  KituraRegistrationClient
//
//  Created by Siavash on 8/3/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import Foundation
import SnapKit


final class ThingsCell: UITableViewCell {
  
  private lazy var title: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.textAlignment = .left
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupUI()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  private func setupUI() {
    _ = contentView.subviews.map({$0.removeFromSuperview})
    
    contentView.addSubview(title)
    title.snp.makeConstraints { (make) in
      make.left.equalTo(16)
      make.right.equalTo(-16)
      make.center.equalToSuperview()
    }
  }
  func config(with thing: Thing) {
    title.text = thing.uuid
  }
}
