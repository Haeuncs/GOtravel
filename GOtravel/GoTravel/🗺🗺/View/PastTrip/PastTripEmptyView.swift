//
//  EmptyDataView.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/11/12.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import SnapKit

/// Empty 데이터일 때 보이는 뷰

class PastTripEmptyView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  func initView(){
    self.addSubview(stackView)
    stackView.addSubview(imageView)
    stackView.addSubview(titleLabel)
    stackView.snp.makeConstraints { (make) in
//      make.top.lessThanOrEqualTo(self.snp.top)
      make.leading.lessThanOrEqualTo(self.snp.leading)
      make.trailing.greaterThanOrEqualTo(self.snp.trailing)
//      make.bottom.greaterThanOrEqualTo(self.snp.bottom)
      make.centerY.equalTo(self.snp.centerY)
      make.centerX.equalTo(self.snp.centerX)
    }
    imageView.snp.makeConstraints { (make) in
      make.height.equalTo(128)
      make.width.equalTo(128)
      make.top.equalTo(stackView.snp.top)
      make.centerX.equalTo(stackView.snp.centerX)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(imageView.snp.bottom).offset(28)
      make.centerX.equalTo(stackView.snp.centerX)
      make.bottom.equalTo(stackView.snp.bottom)
    }
  }
  lazy var stackView: UIView = {
    let stack = UIView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    //    stack.axis = .vertical
    //    stack.alignment = .center
    return stack
  }()
  lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "mapsAndLocationFreepik")
    view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 8, blur: 6, spread: 0)
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "지난 여행이 없어요."
    label.font = .sb24
    return label
  }()
}

extension PastTripEmptyView {
}
