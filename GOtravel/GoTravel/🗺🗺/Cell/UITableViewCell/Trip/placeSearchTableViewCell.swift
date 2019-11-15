//
//  placeSearchTableViewCell.swift
//  GOtravel
//
//  Created by OOPSLA on 18/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class placeSearchTableViewCell : UITableViewCell {
  lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var addressLabel : UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var stackView : UIStackView = {
    let stack = UIStackView(arrangedSubviews: [titleLabel,addressLabel])
    stack.alignment = .fill
    stack.distribution = .fill
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    return stack
  }()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initView()
  }
  
  func initView(){
    self.backgroundColor = .white
    self.contentView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      //            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      //            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:20),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}
