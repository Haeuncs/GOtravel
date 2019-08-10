//
//  SettingTableViewCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/07/27.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func initView(){
    self.addSubview(titleLabel)
    self.addSubview(descriptionLabel)
    self.addSubview(bottomLineView)
    
    titleLabel.snp.makeConstraints{ (make) -> Void in
      make.top.equalTo(self.snp.top).offset(12)
      make.left.equalTo(self.snp.left).offset(16)
      make.right.equalTo(self.snp.right).offset(-16)
    }
    descriptionLabel.snp.makeConstraints{ (make) -> Void in
      make.top.equalTo(titleLabel.snp.bottom).offset(3)
      make.left.equalTo(self.snp.left).offset(16)
      make.right.equalTo(self.snp.right).offset(-16)
    }
    bottomLineView.snp.makeConstraints{ (make) -> Void in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
      make.left.equalTo(self.snp.left).offset(16)
      make.right.equalTo(self.snp.right).offset(-16)
      make.bottom.equalTo(self.snp.bottom).offset(0)
      make.height.equalTo(1)
    }
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "타이틀"
    label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
    label.textColor = Defaull_style.mainTitleColor
    return label
  }()
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    label.text = "설명"
    label.numberOfLines = 0
    label.textColor = Defaull_style.subTitleColor
    return label
  }()
  lazy var bottomLineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Defaull_style.lightGray
    return view
  }()
}
