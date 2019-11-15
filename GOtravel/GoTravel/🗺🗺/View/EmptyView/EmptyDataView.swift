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

class EmptyDataView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.spacing = 20
    stack.axis = .vertical
    stack.alignment = .center
    return stack
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .blackText
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "앗!"
    label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
    return label
  }()
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .blackText
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "데이터가 없어요!"
    label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    return label
  }()
  
  func initView(){
    self.addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(descriptionLabel)
    stackView.snp.makeConstraints{ make in
      make.centerX.equalTo(self.snp.centerX)
      make.centerY.equalTo(self.snp.centerY)
    }
  }
}

extension EmptyDataView {
  func initAnimate(){
    self.titleLabel.transform = .identity
  }
  func startAnimate(){
    let duration = 0.4
    let delay = 0.0
    let fullRotation = CGFloat(M_PI * 2)
    print(1/3 * fullRotation)
    UIView.animate(withDuration: duration, delay: delay, options: [.curveLinear], animations: {
      self.titleLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
      self.titleLabel.transform = CGAffineTransform(rotationAngle: .pi)
    }, completion : { finished in
      UIView.animate(withDuration: duration, delay: delay, options: [.curveLinear], animations: {
        self.titleLabel.transform = .identity
      })
    })
  }
}
