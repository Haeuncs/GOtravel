//
//  DateCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/13.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

class DateCell: UICollectionViewCell {
  enum Layout {
    enum Unabled {
      static let textColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    enum Enabled {
      enum Background {
        static let defaultColor: UIColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        static let firstAndLastColor: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
      }
      static let textColor: UIColor = Style.activeCellLblColor
      static let selectedTextColor: UIColor = .white
    }
  }

  lazy var dayLabel: UILabel = {
    let label = UILabel()
    label.text = "00"
    label.textAlignment = .center
    label.font=UIFont.systemFont(ofSize: 16)
    label.textColor=Colors.darkGray
    label.translatesAutoresizingMaskIntoConstraints=false
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    backgroundColor = UIColor.clear
  }

  func configureLayout() {
    layer.cornerRadius = 5
    layer.masksToBounds = true

    contentView.addSubview(dayLabel)
    dayLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(contentView)
      make.centerY.equalTo(contentView)
    }
  }

  func today() {
    isUserInteractionEnabled = true
    dayLabel.textColor = .red
  }

  func enabledDay() {
    isUserInteractionEnabled = true
    dayLabel.textColor = Layout.Enabled.textColor
  }

  func unabledDay() {
    isUserInteractionEnabled = false
    dayLabel.textColor = Layout.Unabled.textColor
  }

  func selectedDay(isMiddle: Bool) {
    dayLabel.textColor = Layout.Enabled.selectedTextColor
    if isMiddle {
      backgroundColor = Layout.Enabled.Background.defaultColor
    }
    else {
      backgroundColor = Layout.Enabled.Background.firstAndLastColor
    }
  }
}
