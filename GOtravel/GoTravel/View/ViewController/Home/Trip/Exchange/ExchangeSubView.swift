//
//  ExchangeSubView.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/16.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit

class ExchangeSubView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func initView() {
    self.addSubview(stackView)
    stackView.addArrangedSubview(dayView)
    stackView.addArrangedSubview(totalView)

    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top)
      make.left.equalTo(self.snp.left)
      make.right.equalTo(self.snp.right)
      make.bottom.equalTo(self.snp.bottom)
    }
  }
  lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = UIStackView.Distribution.fillEqually
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var dayView: AccountLabelView = {
    let view = AccountLabelView()
    view.descriptionLabel.text = "하루 합계"
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var totalView: AccountLabelView = {
    let view = AccountLabelView()
    view.descriptionLabel.text = "총합"
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}
class AccountLabelView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func initView(){
    self.addSubview(stackView)
    stackView.addArrangedSubview(descriptionLabel)
    stackView.addArrangedSubview(moneyLabel)

    stackView.snp.makeConstraints { (make) in
//      make.left.equalTo(self.snp.left)
//      make.right.equalTo(self.snp.right)
      make.centerX.equalTo(self.snp.centerX)
      make.centerY.equalTo(self.snp.centerY)
    }
  }
  lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.spacing = 16
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  /// 설명
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "하루"
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  /// money 표시
  lazy var moneyLabel: UILabel = {
    let label = UILabel()
    label.text = "￦ 100.000"
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
}

