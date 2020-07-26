////
////  BottomButton.swift
////  GOtravel
////
////  Created by LEE HAEUN on 2020/01/19.
////  Copyright © 2020 haeun. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class BottomButton: UIButton {
//  var title: String? {
//    didSet {
//      if title != nil {
//        titleLabel_.text = title!
//      }
//    }
//  }
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    initView()
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  func initView(){
//    self.backgroundColor = .turquoiseBlue
//    self.layer.cornerRadius = 8
//    self.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 6, blur: 6, spread: 0)
//    self.addSubview(titleLabel_)
//    titleLabel_.snp.makeConstraints { (make) in
//      make.centerX.equalTo(self.snp.centerX)
//      make.centerY.equalTo(self.snp.centerY)
//    }
//
//  }
//  
//  lazy var titleLabel_: UILabel = {
//    let label = UILabel()
//    label.translatesAutoresizingMaskIntoConstraints = false
//    label.text = ""
//    label.font = .b26
//    label.textColor = .white
//    return label
//  }()
//  
//}
