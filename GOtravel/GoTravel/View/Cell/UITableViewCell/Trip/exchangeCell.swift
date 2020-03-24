//
//  exchangeCell.swift
//  GOtravel
//
//  Created by OOPSLA on 01/02/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import SnapKit
import UIKit

class exchangeCVCell : UICollectionViewCell {
  
  override var isSelected: Bool {
    didSet {
      if self.isSelected {
        dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        indicator.backgroundColor = .butterscotch
      }else{
        dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        indicator.backgroundColor = .clear
      }
    }
  }
  lazy var indicator: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 5/2
    view.backgroundColor = .clear
    return view
  }()

  lazy var dayLabel : UILabel = {
    let label = UILabel()
    label.text = "1일"
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.textColor = Defaull_style.dateColor
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layoutInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func layoutInit(){
    contentView.backgroundColor = .white
    contentView.layer.cornerRadius = 60/2
    contentView.clipsToBounds = false
    contentView.layer.zeplinStyleShadows(color: .black, alpha: 0.13, x: 0, y: 3, blur: 8, spread: 0)

    contentView.addSubview(dayLabel)
    contentView.addSubview(indicator)

    
    NSLayoutConstraint.activate([
      dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
      ])
    indicator.snp.makeConstraints{ (make) in
      make.width.equalTo(5)
      make.height.equalTo(5)
      make.top.equalTo(dayLabel.snp.top).offset(-4)
      make.left.equalTo(dayLabel.snp.right).offset(0.5)
    }

  }
  
}
