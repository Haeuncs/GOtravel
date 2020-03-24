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
  override var isSelected: Bool {
    get {
      return super.isSelected
    }
    set {
      //do something
      super.isSelected = newValue
      if newValue {
        self.imageView_.isHidden = false
      }else{
        self.imageView_.isHidden = true
      }
    }
  }
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
  lazy var imageView_: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "check_Pixelperfect")
    return view
  }()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initView()
  }
  
  func initView(){
    self.selectionStyle = .none
    self.backgroundColor = .white
    self.contentView.addSubview(stackView)
    self.contentView.addSubview(imageView_)
    
    NSLayoutConstraint.activate([
      //            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      //            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:20),
      stackView.trailingAnchor.constraint(lessThanOrEqualTo: imageView_.leadingAnchor),
      stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      imageView_.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
      imageView_.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      imageView_.heightAnchor.constraint(equalToConstant: 24),
      imageView_.widthAnchor.constraint(equalToConstant: 24)
      
    ])
  }
}
