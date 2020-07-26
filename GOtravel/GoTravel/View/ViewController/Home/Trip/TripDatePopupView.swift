//
//  TripDatePopupView.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/16.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

class TripDetailPopupView: UIView {
 override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(contentView)
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)

    contentView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self)
      make.height.equalTo(40)
    }
    imageView.snp.makeConstraints { (make) in
      make.leading.centerY.equalTo(self)
      make.width.height.equalTo(28)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(imageView.snp.trailing).offset(18)
      make.centerY.equalTo(self)
      make.trailing.equalTo(self)
    }
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setup(image: UIImage,text: String) {
    imageView.image = image
    titleLabel.text = text
  }
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "atm")
    view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    return view
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = .m18
    return label
  }()

}
