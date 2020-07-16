//
//  ExchangeCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/16.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit

class ExchangeCell: UITableViewCell {
  override func prepareForReuse() {

  }
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setLayout()

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setLayout() {

//    self.backgroundColor = .butterscotch
//    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
    insideView.layer.cornerRadius = 4
    insideView.layer.zeplinStyleShadows(color: .black, alpha: 0.07, x: 0, y: 10, blur: 10, spread: 0)
    insideView.clipsToBounds = false

    contentView.addSubview(insideView)
    insideView.addSubview(leftStack)
    leftStack.addArrangedSubview(label1)
    leftStack.addArrangedSubview(label2)
    insideView.addSubview(label3)

    NSLayoutConstraint.activate([
      insideView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
      insideView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
      insideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      insideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

      insideView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

      leftStack.centerYAnchor.constraint(equalTo: insideView.centerYAnchor, constant: 0),
      leftStack.leftAnchor.constraint(equalTo: insideView.leftAnchor, constant: 14),

      label3.centerYAnchor.constraint(equalTo: insideView.centerYAnchor, constant: 0),
      label3.rightAnchor.constraint(equalTo: insideView.rightAnchor, constant: -14),

    ])

  }
  let insideView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    return view
  }()
  lazy var leftStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 8
    return stack
  }()
  let label1: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "호텔"
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    return label
  }()
  let label2: UILabel = {
    let label = UILabel()
    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.text = "도쿄 호텔 비용"
    label.textColor = .black
    return label
  }()
  let label3: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    return label
  }()

}
