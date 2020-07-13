//
//  PopNavigationBar.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/18.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PopNavigationBar: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(contentView)
    contentView.addSubview(button)
    
    contentView.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.bottom.equalTo(self.snp.bottom)
      make.height.equalTo(48)
    }
    
    button.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.lessThanOrEqualTo(contentView.snp.trailing)
      make.bottom.equalTo(contentView.snp.bottom)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var button: PopButton = {
    let btn = PopButton()
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()
}

class PopButton: UIButton{
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.isUserInteractionEnabled = false
    self.addSubview(contentView)
    contentView.addSubview(imageView_)
    contentView.addSubview(popLabel)
    
    contentView.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.bottom.equalTo(self.snp.bottom)
    }
    imageView_.snp.makeConstraints { (make) in
      make.leading.equalTo(contentView.snp.leading).offset(12)
      make.centerY.equalTo(contentView.snp.centerY)
    }
    popLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(contentView.snp.centerY)
      make.leading.equalTo(imageView_.snp.trailing).offset(4)
      make.trailing.equalTo(contentView.snp.trailing).offset(-16)
      
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var imageView_: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "back3X")
    return view
  }()
  lazy var popLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = ""
    label.font = .b18
    return label
  }()
  
}
