//
//  BaseUIViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/18.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

class BaseUIViewController: UIViewController {
  
  var isDismiss: Bool? {
    didSet {
      guard let value = isDismiss else {
        return
      }
      if value {
        dismissInitView()
      }else {
        popInitView()
      }
    }
  }
  var popTitle: String? {
    didSet {
      guard let title = popTitle else {
        return
      }
      popNav.button.popLabel.text = title
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  func dismissInitView(){
    view.backgroundColor = .white
    view.addSubview(dismissNav)
    view.addSubview(baseView)
    dismissNav.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.height.equalTo(48)
    }
    baseView.snp.makeConstraints { (make) in
      make.top.equalTo(dismissNav.snp.bottom)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      //      make.bottom.equalTo(self.snp.bottom)
      make.height.equalTo(0)
    }
    
  }
  func popInitView(){
    view.backgroundColor = .white
    view.addSubview(popNav)
    view.addSubview(baseView)
    popNav.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.height.equalTo(48)
    }
    baseView.snp.makeConstraints { (make) in
      make.top.equalTo(popNav.snp.bottom)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      //      make.bottom.equalTo(self.snp.bottom)
      make.height.equalTo(0)
    }
    
  }
  lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var popNav: PopNavigationBar = {
    let view = PopNavigationBar()
    view.isUserInteractionEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false
    view.button.addTarget(self, action: #selector(event), for: .touchUpInside)
    return view
  }()
  lazy var dismissNav: DismissNavigationBar = {
    let view = DismissNavigationBar()
    view.button.addTarget(self, action: #selector(event), for: .touchUpInside)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}

extension BaseUIViewController {
  @objc func event(){
    if ((self.navigationController?.topViewController) != nil) {
      self.navigationController?.popViewController(animated: true)
    }else {
      self.dismiss(animated: true, completion: nil)
    }
  }
}

