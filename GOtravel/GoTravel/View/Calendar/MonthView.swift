//
//  MonthView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import SnapKit

protocol MonthViewDelegate: class {
  func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {
  private enum Layout {
    enum ArrowIcon {
      static let width: CGFloat = 41
      static let height: CGFloat = 41
    }
    enum ArrowStack {
      static let space: CGFloat = 27
    }
  }
  var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  var currentMonthIndex = 0
  var currentYear: Int = 0
  var delegate: MonthViewDelegate?

  let lblName: UILabel = {
    let lbl=UILabel()
    lbl.text="Default Month Year text"
    lbl.textColor = .black
    lbl.textAlignment = .left
    lbl.font = .sb24
    lbl.translatesAutoresizingMaskIntoConstraints=false
    return lbl
  }()

  lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [btnLeft, btnRight])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    //    stack.alignment = .center
    stack.spacing = Layout.ArrowStack.space
    return stack
  }()

  let btnRight: UIButton = {
    let btn = UIButton()
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setImage(UIImage(named: "RightIcon"), for: .normal)
    btn.imageView?.contentMode = .scaleAspectFit
    btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
    btn.layer.zeplinStyleShadows(color: UIColor.black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    btn.clipsToBounds = false
    return btn
  }()

  let btnLeft: UIButton = {
    let btn = UIButton()
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setImage(UIImage(named: "LeftIcon"), for: .normal)
    btn.imageView?.contentMode = .scaleAspectFit
    btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
    btn.layer.zeplinStyleShadows(color: UIColor.black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    btn.clipsToBounds = false
    return btn
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor=UIColor.clear
    
    currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    currentYear = Calendar.current.component(.year, from: Date())
    
    setupViews()
  }

  func setupViews() {
    lblName.text="\(currentYear)년 \(currentMonthIndex + 1)월"
    self.addSubview(lblName)
    self.addSubview(stackView)
    lblName.snp.makeConstraints { (make) in
      make.leading.equalTo(self.snp.leading)
      make.centerY.equalTo(self.snp.centerY)
    }
    stackView.snp.makeConstraints { (make) in
      make.centerY.equalTo(self)
      make.trailing.equalTo(self.snp.trailing)
      make.leading.lessThanOrEqualTo(lblName.snp.trailing)
    }
    btnLeft.snp.makeConstraints { (make) in
      make.width.equalTo(Layout.ArrowIcon.width)
      make.height.equalTo(Layout.ArrowIcon.height)
    }
    btnRight.snp.makeConstraints { (make) in
      make.width.equalTo(Layout.ArrowIcon.width)
      make.height.equalTo(Layout.ArrowIcon.height)
    }
  }

  @objc func btnLeftRightAction(sender: UIButton) {
    if sender == btnRight {
      currentMonthIndex += 1
      if currentMonthIndex > 11 {
        currentMonthIndex = 0
        currentYear += 1
      }
    } else {
      currentMonthIndex -= 1
      if currentMonthIndex < 0 {
        currentMonthIndex = 11
        currentYear -= 1
      }
    }
    lblName.text = "\(currentYear)년 \(currentMonthIndex + 1)월"
    delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

