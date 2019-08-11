//
//  addDetailTableViewCellInsideTableViewCell.swift
//  GOtravel
//
//  Created by OOPSLA on 17/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
class addDetailTableViewCellInsideTableViewCell : UITableViewCell{
  var timeLabelIsHidden : Bool = true
  var memoLabelIsHidden : Bool = true
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    //        print("sub test style")
    contentView.backgroundColor = .white
    timeLabel.text = ""
    oneLineMemo.text = ""
    titleLabel.text = ""
    
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initView(){
    // stack 으로 time과 title 관리함.
    stackView.addArrangedSubview(timeLabel)
    stackView.addArrangedSubview(oneLineMemo)
    stackView.addArrangedSubview(titleLabel)
    
    //        mainView.addSubview(timeLabel)
    //        mainView.addSubview(titleLabel)
    //        contentView.addSubview(mainView)
    
    colorParentView.addSubview(colorView)
    
    detailInfoWithcolorView.addArrangedSubview(colorParentView)
    detailInfoWithcolorView.addArrangedSubview(stackView)
    
    contentView.addSubview(detailInfoWithcolorView)
    
    let stackMultiplerWidth = NSLayoutConstraint(item: colorParentView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 0.1, constant: 0.0)
    
    NSLayoutConstraint.activate([
      stackMultiplerWidth,
      
      // main stack
      detailInfoWithcolorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      detailInfoWithcolorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      detailInfoWithcolorView.topAnchor.constraint(equalTo: contentView.topAnchor),
      detailInfoWithcolorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      //            colorParentView.topAnchor.constraint(equalTo: detailInfoWithcolorView.topAnchor),
      //            colorParentView.bottomAnchor.constraint(equalTo: detailInfoWithcolorView.bottomAnchor),
      //
      //            stackView.topAnchor.constraint(equalTo: detailInfoWithcolorView.topAnchor),
      //            stackView.bottomAnchor.constraint(equalTo: detailInfoWithcolorView.bottomAnchor),
      
      colorView.centerXAnchor.constraint(equalTo: colorParentView.centerXAnchor),
      colorView.centerYAnchor.constraint(equalTo: colorParentView.centerYAnchor),
      colorView.widthAnchor.constraint(equalToConstant: 10),
      colorView.heightAnchor.constraint(equalToConstant: 10),
      
      
      
    ])
  }
  let detailInfoWithcolorView : UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .fill
    //        stack.backgroundColor = UIColor.clear
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  let stackView : UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  var colorParentView : UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var colorView : UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.red
    view.layer.cornerRadius = 10/2
    // 타원 그리기
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var mainView : UIView = {
    let view = UIView()
    //        view.backgroundColor = .green
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 16)
    //        label.backgroundColor = .blue
    //        label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var timeLabel : UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    label.textColor = Defaull_style.subTitleColor
    label.numberOfLines = 0
    label.isHidden = true
    
    //        label.backgroundColor = .red
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var oneLineMemo : UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    label.textColor = Defaull_style.subTitleColor
    label.numberOfLines = 0
    label.isHidden = true
    //        label.backgroundColor = .red
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
}
