//
//  OpenSourceViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/07/27.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class OpenSourceViewController: UIViewController {
  let openSourceArr: [openSource] = [
    openSource(title: "IQKeyboardManagerSwift", license: License.IQKeyboardManagerSwiftLicense.rawValue),
    openSource(title: "CenteredCollectionView", license: License.CenteredCollectionViewLicense.rawValue),
    openSource(title: "EasyTipView", license: License.EasyTipView.rawValue),
    openSource(title: "SnapKit", license: License.SnapKit.rawValue),
    openSource(title: "Realm", license: License.RealmLicense.rawValue),
    openSource(title: "GoogleMaps", license: License.GoogleMapsLicense.rawValue),
    openSource(title: "Icon Image", license: "Icon made by [https://www.flaticon.com/authors/smashicons] from www.flaticon.com"),
    openSource(title: "App Icon Image", license: "Icon made by [https://www.flaticon.com/authors/photo3idea_studio] from www.flaticon.com")
  ]
  override func viewDidLoad() {
    self.navigationItem.title = "오픈소스 라이선스"
    self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Defaull_style.mainTitleColor]
    self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    initView()
  }
  func initView() {
//    tableView.delegate = self
    self.view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
      tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      ])
  }

  lazy var tableView: UITableView = {
    let table = UITableView()
    table.delegate = self
    table.dataSource = self
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(SettingTableViewCell.self, forCellReuseIdentifier: String(describing: SettingTableViewCell.self))
    return table
  }()
}

extension OpenSourceViewController: UITableViewDelegate {
  
}
extension OpenSourceViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return openSourceArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingTableViewCell.self), for: indexPath) as! SettingTableViewCell
    cell.titleLabel.text = openSourceArr[indexPath.row].title
    cell.descriptionLabel.text = openSourceArr[indexPath.row].license
    return cell
    
  }
  
  
}
