//
//  CustomNavigationBarView.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/10.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit

class CustomNavigationBarView: UIView {
  var _setText: String = ""
  var setText: String{
    get {
      return _setText
    }
    set (new) {
      titleLabel.text = new
      if new == "" {
//        bottomLine.backgroundColor = .clear
      }else{
//        bottomLine.backgroundColor = .grey03
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .white
    self.addSubview(titleLabel)
    self.addSubview(dismissBtn)
    self.addSubview(actionBtn)
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      dismissBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      dismissBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7),
      dismissBtn.widthAnchor.constraint(equalToConstant: 44),
      dismissBtn.heightAnchor.constraint(equalToConstant: 44),
      
      actionBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      actionBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7),
      actionBtn.widthAnchor.constraint(equalToConstant: 44),
      actionBtn.heightAnchor.constraint(equalToConstant: 44),
      ])
  }
  func setLeftIcon(image: UIImage) {
    let imageProcessed = resizedImageWith(image: image, targetSize: CGSize(width: 22, height: 22))
    dismissBtn.setImage(imageProcessed, for: .normal)
  }
  func setRightIcon(image: UIImage) {
    let imageProcessed = resizedImageWith(image: image, targetSize: CGSize(width: 22, height: 22))
    actionBtn.setImage(imageProcessed, for: .normal)
  }
  func setLeftForPop(){
    dismissBtn.setImage(resizedImageWith(image: UIImage(named: "x")!, targetSize: CGSize(width: 22, height: 22)), for: .normal)
  }
  func setLeftForBack(){
    dismissBtn.setImage(resizedImageWith(image: UIImage(named: "back")!, targetSize: CGSize(width: 22, height: 22)), for: .normal)
  }
  func setTitle(title: String){
    titleLabel.text = title
  }
  func setButtonTitle(title: String){
    actionBtn.setTitle(title, for: .normal)
  }
  func setButtonEnabled(enabled: Bool){
    actionBtn.isEnabled = enabled
  }
  func setLeftText(title:String) {
    dismissBtn.setTitle(title, for: .normal)
    dismissBtn.setTitleColor(Defaull_style.mainTitleColor, for: .normal)
  }

  func setButtonEditText(title: String){
    actionBtn.setTitle(title, for: .normal)
    actionBtn.setTitleColor(Defaull_style.lightGray, for: .normal)
  }
  func setButtonDoneText(title: String){
    actionBtn.setTitle(title, for: .normal)
    actionBtn.setTitleColor(Defaull_style.mainTitleColor, for: .normal)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "레이블"
    label.font = UIFont.sb18
    label.textColor = .black
    return label
  }()
  
  lazy var dismissBtn : UIButton = {
    let btn = UIButton()
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setImage(UIImage(named: "icnXNew"), for: .normal)
    btn.imageView?.contentMode = .scaleAspectFit
    return btn
  }()
  
  lazy var actionBtn : UIButton = {
    let btn = UIButton()
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setTitle("", for: .normal)
    btn.titleLabel?.textAlignment = .center
    btn.titleLabel?.font = UIFont.sb18
    btn.setTitleColor(Defaull_style.mainTitleColor, for: .normal)
    btn.setTitleColor(Defaull_style.lightGray, for: .disabled)
    return btn
  }()
  
}
