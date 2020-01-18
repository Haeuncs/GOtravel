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
  var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  var currentMonthIndex = 0
  var currentYear: Int = 0
  var delegate: MonthViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor=UIColor.clear
    
    currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    currentYear = Calendar.current.component(.year, from: Date())
    
    setupViews()
    
    //        btnLeft.isEnabled=false
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
    lblName.text="\(currentYear)년 \(currentMonthIndex + 1)월"
    delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
  }
  
  func setupViews() {
    lblName.text="\(currentYear)년 \(currentMonthIndex + 1)월"
    self.addSubview(lblName)
    self.addSubview(stackView)
    lblName.snp.makeConstraints { (make) in
//      make.top.equalTo(self.snp.top)
      make.leading.equalTo(self.snp.leading)
      make.centerY.equalTo(self.snp.centerY)
//      make.bottom.equalTo(self.snp.bottom)
    }
    stackView.snp.makeConstraints { (make) in
      make.height.equalTo(self.snp.height)
      make.trailing.equalTo(self.snp.trailing)
      make.leading.greaterThanOrEqualTo(lblName.snp.trailing)
    }
    btnLeft.snp.makeConstraints { (make) in
      make.width.equalTo(45)
      make.height.equalTo(45)
    }
btnRight.snp.makeConstraints { (make) in
  make.width.equalTo(45)
  make.height.equalTo(45)
}
//    self.addSubview(lblName)
//    lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
//    lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
//    lblName.widthAnchor.constraint(equalToConstant: 150).isActive=true
//    lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
//    lblName.text="\(currentYear)년 \(currentMonthIndex + 1)월"
    
//    self.addSubview(btnRight)
//    btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
//    btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
//    btnRight.widthAnchor.constraint(equalToConstant: 50).isActive=true
//    btnRight.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
//
//    self.addSubview(btnLeft)
//    btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
//    btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
//    btnLeft.widthAnchor.constraint(equalToConstant: 50).isActive=true
//    btnLeft.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
  }
  
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
    let stack = UIStackView(arrangedSubviews: [btnRight, btnLeft])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
//    stack.alignment = .center
    stack.spacing = 18
    return stack
  }()

  let btnRight: UIButton = {
    let btn=UIButton()
//    btn.setTitle(">", for: .normal)
//    btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
    btn.setImage(UIImage(named: "arrowTop"), for: .normal)
    btn.imageView?.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
    btn.imageView?.contentMode = .scaleAspectFit
    btn.translatesAutoresizingMaskIntoConstraints=false
    btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
    btn.layer.cornerRadius = 45/2
    btn.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 3, y: 3, blur: 6, spread: 0)
    btn.backgroundColor = .white

    return btn
  }()
  
  let btnLeft: UIButton = {
    let btn=UIButton()
    //    btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
    btn.setImage(UIImage(named: "arrowBottom"), for: .normal)
    btn.imageView?.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
    btn.imageView?.contentMode = .scaleAspectFit
    btn.translatesAutoresizingMaskIntoConstraints=false
    btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
    btn.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 3, y: 3, blur: 6, spread: 0)
    btn.layer.cornerRadius = 45/2
    btn.backgroundColor = .white
    return btn
  }()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

