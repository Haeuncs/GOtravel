//
//  addDetailView.swift
//  GOtravel
//
//  Created by OOPSLA on 18/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit

import SnapKit

class TripDescriptionView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // titleView label 정의
  var countryLabel: UILabel = {
    let label = UILabel()
    label.text = "일본 여행 🗺"
    label.textColor = .black
    label.font = .sb28
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var subLabel: UILabel = {
    let label = UILabel()
    label.text = "오사카 교토"
    label.textColor = .black
    label.font = .sb17
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  var dateLabel: UILabel = {
    let label = UILabel()
    label.text = "2019.02.10~2019.02.16 5박6일"
    label.textColor = .black
    label.font = .sb17
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var moneyBtn: UIButton = {
    let btn = UIButton()
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setImage(UIImage(named: "changeSmashicons"), for: .normal)
    btn.imageView?.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
    btn.imageView?.contentMode = .scaleAspectFit
    btn.layer.cornerRadius = 38 / 2
    btn.backgroundColor = .white
    btn.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 0, blur: 4, spread: 0)
    
    return btn
  }()
  
  func initView() {
    
    addSubview(countryLabel)
    addSubview(subLabel)
    addSubview(dateLabel)
    addSubview(moneyBtn)
    
    countryLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(self)
      make.top.equalTo(self.snp.top).offset(8)
    }
    subLabel.snp.makeConstraints { (make) in
      make.top.equalTo(countryLabel.snp.bottom).offset(8)
      make.leading.trailing.equalTo(self)
    }
    dateLabel.snp.makeConstraints { (make) in
      make.top.equalTo(subLabel.snp.bottom).offset(8)
      make.leading.trailing.equalTo(self)
      make.bottom.equalTo(self.snp.bottom)
    }
    moneyBtn.snp.makeConstraints { (make) in
      make.width.height.equalTo(38)
      make.trailing.equalTo(self.snp.trailing)
      make.centerY.equalTo(self.snp.centerY)
    }
  }
  
}
class TripDateView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  func initView(){
    
    self.addSubview(contentView)
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(dateLabel)
    stackView.addArrangedSubview(dayOfTheWeek)
    
    contentView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self)
    }
    stackView.snp.makeConstraints { (make) in
      make.center.equalTo(contentView)
//      make.top.leading.trailing.bottom.equalTo(contentView)
      
    }
  }
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution =  .equalSpacing
    stack.spacing = 8
    return stack
  }()
  let dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .sb17
    label.textColor = .black
    label.text = "test"
    label.numberOfLines = 0
    ////        label.layer.cornerRadius = 8
    //        label.layer.borderWidth = 1
    //        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let dayOfTheWeek: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .sb17
    label.textColor = .black
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
}
class AddDetailViewCellButtonView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    initView()
  }
  lazy var addButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "morePixelPerfect"), for: .normal)
    button.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//    button.layer.zeplinStyleShadows(color: UIColor(red: 1.0, green: 250.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0), alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    return button
  }()
  let view: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  func initView(){
    self.addSubview(addButton)
    addButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(self)
      make.centerY.equalTo(self)
    }
  }
  
}
