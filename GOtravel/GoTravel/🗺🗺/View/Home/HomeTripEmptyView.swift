//
//  HomeTripEmptyView.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/16.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import SnapKit


class HomeTripEmptyView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(stackView)
    stackView.addSubview(imageView)
    stackView.addSubview(titleLabel)
    stackView.addSubview(addButton)

    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.bottom.equalTo(self.snp.bottom)
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
    }
    addButton.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.height.equalTo(48)
      make.width.equalTo(190)
      make.bottom.equalTo(stackView.snp.bottom)
      make.centerX.equalTo(stackView.snp.centerX)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    view.image = UIImage(named: "luggageFreepik")
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = .sb24
    return label
  }()
  lazy var addButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("일정 추가 하기", for: .normal)
    button.titleLabel?.font = .b18
    button.backgroundColor = .tealish
    button.layer.cornerRadius = 18
    button.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    return button
  }()
}
