//
//  addDetailTableViewCellInsideTableViewCell.swift
//  GOtravel
//
//  Created by OOPSLA on 17/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - 데이터가 없는 날짜의 테이블 뷰 셀
class TripDetailEmptyTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
   initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initView(){
    self.addSubview(topSpaceView)
    self.addSubview(view)
    self.addSubview(bottomSpaceView)
    view.addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)

    topSpaceView.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top)
      make.leading.trailing.equalTo(self)
      make.height.equalTo(4)
    }
    view.snp.makeConstraints { (make) in
      make.top.equalTo(topSpaceView.snp.bottom)
      make.leading.equalTo(self.snp.leading).offset(8)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
    }
    bottomSpaceView.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.bottom)
      make.leading.trailing.bottom.equalTo(self)
      make.height.equalTo(8)
    }
    stackView.snp.makeConstraints { (make) in
      make.center.equalTo(view)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
    }
//    addButton.snp.makeConstraints { (make) in
//      make.width.equalTo(52)
//      make.height.equalTo(28)
//    }
  }
  lazy var topSpaceView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var bottomSpaceView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var view: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 8
    view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    return view
  }()

  lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .equalSpacing
    stack.spacing = 5
    return stack
  }()

  lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.text = "🏷 일정이 없어요"
    label.textAlignment = .center
    label.font = .sb11
    label.lineBreakMode = .byTruncatingTail
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var addButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("추가", for: .normal)
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = .sb17
    button.tintColor = .white
    button.backgroundColor = .greyishTeal
    button.layer.cornerRadius = 8
    button.layer.zeplinStyleShadows(color: .greyishTeal, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    return button
  }()
}

class AddDetailTableViewCellInsideTableViewCell : UITableViewCell{
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
    self.addSubview(topSpaceView)
    self.addSubview(view)
    self.addSubview(bottomSpaceView)
    view.addSubview(colorView)
    view.addSubview(stackView)
    stackView.addArrangedSubview(oneLineMemo)
    stackView.addArrangedSubview(titleLabel)
    
    topSpaceView.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top)
      make.leading.trailing.equalTo(self)
      make.height.equalTo(4)
    }
    view.snp.makeConstraints { (make) in
      make.top.equalTo(topSpaceView.snp.bottom)
      make.leading.equalTo(self.snp.leading).offset(8)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
    }
    bottomSpaceView.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.bottom)
      make.leading.trailing.bottom.equalTo(self)
      make.height.equalTo(8)
    }
    colorView.snp.makeConstraints { (make) in
      make.width.height.equalTo(8)
      make.centerY.equalTo(view)
      make.leading.equalTo(view).offset(8)
    }
    stackView.snp.makeConstraints { (make) in
      make.leading.equalTo(colorView.snp.trailing).offset(12)
      make.trailing
        .equalTo(view)
//      make.top.bottom.lessThanOrEqualTo(self)
      make.centerY.equalTo(view)
    }
  }
  lazy var view: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 8
    view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    return view
  }()

  lazy var topSpaceView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var bottomSpaceView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
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
    stack.alignment = .leading
    stack.distribution =  .equalSpacing
    stack.spacing = 4
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
    view.layer.cornerRadius = 8/2
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
    label.font = .sb17
    label.lineBreakMode = .byTruncatingTail
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var timeLabel : UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    label.textColor = .black
    label.numberOfLines = 0
    label.isHidden = true
    
    //        label.backgroundColor = .red
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var oneLineMemo : UILabel = {
    let label = UILabel()
    label.font = .r12
    label.lineBreakMode = .byTruncatingTail
    label.textColor = .black
    label.isHidden = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
}
