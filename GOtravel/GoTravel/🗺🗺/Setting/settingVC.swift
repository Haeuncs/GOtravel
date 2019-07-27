//
//  settingVC.swift
//  GOtravel
//
//  Created by OOPSLA on 04/03/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class settingVC : UIViewController {
  override func viewDidLoad() {
    self.navigationItem.title = "설정"
    self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Defaull_style.mainTitleColor]
    self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    initView()
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let indexPath = belowView.table.indexPathForSelectedRow {
      belowView.table.deselectRow(at: indexPath, animated: true)
    }
  }
  func initView() {
    belowView.delegate = self
    self.view.addSubview(belowView)
    NSLayoutConstraint.activate([
      belowView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
      belowView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      belowView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      belowView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      ])
  }
  // 테이블뷰
  let belowView : settingV = {
    let view = settingV()
    view.layer.cornerRadius = 10
    view.backgroundColor = UIColor.clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
}

extension settingVC: ViewControllerDelegate {
  func presentView(viewContorller: UIViewController) {
    if let indexPath = belowView.table.indexPathForSelectedRow {
      belowView.table.deselectRow(at: indexPath, animated: true)
    }
    self.present(viewContorller, animated: true)
  }
  
  func push(viewContorller: UIViewController) {
    navigationController?.pushViewController(viewContorller, animated: true)
  }
  
}
