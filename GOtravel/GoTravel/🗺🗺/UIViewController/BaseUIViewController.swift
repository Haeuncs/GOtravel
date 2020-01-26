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
    view.addSubview(contentView)
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
    contentView.snp.makeConstraints { (make) in
      make.top.equalTo(dismissNav.snp.bottom)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
      make.bottom.equalTo(view.snp.bottom)
    }
  }
  func popInitView(){
    view.backgroundColor = .white
    view.addSubview(popNav)
    view.addSubview(baseView)
    view.addSubview(contentView)
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
    contentView.snp.makeConstraints { (make) in
      make.top.equalTo(popNav.snp.bottom)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
      make.bottom.equalTo(view.snp.bottom)
    }
    
  }
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

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
    if isDismiss! {
      self.dismiss(animated: true, completion: nil)
    }else {
      self.navigationController?.popViewController(animated: true)
    }
  }
}

