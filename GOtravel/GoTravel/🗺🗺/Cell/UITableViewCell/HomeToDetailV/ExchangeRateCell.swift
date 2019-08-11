//
//  ExchangeRateCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/10.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class ExchangeRateCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initView() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(bottomLineView)
    contentView.addSubview(moneyLabel)
    
    titleLabel.snp.makeConstraints{ (make) -> Void in
      make.top.equalTo(contentView.snp.top).offset(12)
      make.left.equalTo(contentView.snp.left).offset(16)
      make.right.equalTo(contentView.snp.right).offset(-16)
    }
    moneyLabel.snp.makeConstraints{ (make) in
      make.centerY.equalTo(contentView.snp.centerY)
      make.right.equalTo(contentView.snp.right).offset(-16)
    }
    descriptionLabel.snp.makeConstraints{ (make) -> Void in
      make.top.equalTo(titleLabel.snp.bottom).offset(3)
      make.left.equalTo(contentView.snp.left).offset(16)
      make.right.equalTo(contentView.snp.right).offset(-16)
    }
    bottomLineView.snp.makeConstraints{ (make) -> Void in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
      make.left.equalTo(contentView.snp.left).offset(16)
      make.right.equalTo(contentView.snp.right).offset(-16)
      make.bottom.equalTo(contentView.snp.bottom).offset(0)
      make.height.equalTo(1)
    }

  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "타이틀"
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.textColor = Defaull_style.mainTitleColor
    return label
  }()
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.text = "설명"
    label.textColor = Defaull_style.mainTitleColor
    return label
  }()
  lazy var moneyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    label.text = "설명"
    label.textColor = Defaull_style.mainTitleColor
    return label
  }()
  lazy var bottomLineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Defaull_style.lightGray
    return view
  }()

}
