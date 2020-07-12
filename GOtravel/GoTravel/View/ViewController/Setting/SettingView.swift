//
//  settingV.swift
//  GOtravel
//
//  Created by OOPSLA on 04/03/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SettingView : UIView {
  
  var delegate: ViewControllerDelegate?
  
  // FIXIT : 테이블 뷰 셀에 추가할 배열
  //    var tableCellArr = ["알림 설정","백업"]
  var tableCellArr = ["문의 하기","오픈소스 라이선스"]
  let tableCellList: [SettingList] = [
    SettingList(title: "문의하기", description: "오류나 개선 사항이 있으면 말씀해주세요."),
    SettingList(title: "오픈소스 라이센스", description: "앱 개발에 쓰인 오픈소스입니다.")
  ]
  
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
  func initView() {
    self.addSubview(table)
    table.delegate = self
    table.dataSource = self
    NSLayoutConstraint.activate([
      table.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
      table.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
      table.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
      table.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
      ])
  }
  let table : UITableView = {
    let table = UITableView()
    table.separatorStyle = .none
    table.backgroundColor = DefaullStyle.topTableView
    table.translatesAutoresizingMaskIntoConstraints  = false
    table.register(SettingTableViewCell.self, forCellReuseIdentifier: String(describing: SettingTableViewCell.self))
    return table
  }()
  
}

extension SettingView : UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      sendEmail()
    }else{
      let vc = OpenSourceLicenseViewController()
      delegate?.push(viewContorller: vc)
    }
  }
}
extension SettingView : UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableCellList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingTableViewCell.self), for: indexPath) as! SettingTableViewCell
    cell.titleLabel.text = tableCellList[indexPath.row].title
    
    cell.descriptionLabel.text = tableCellList[indexPath.row].description
    
    if indexPath.row == tableCellList.count - 1 {
      cell.bottomLineView.isHidden = true
    }
    return cell
  }
  
}
extension SettingView: MFMailComposeViewControllerDelegate{
  func sendEmail() {
    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients(["haeun.developer@gmail.com"])
      mail.setMessageBody("문의합니다.", isHTML: true)
      
      delegate?.presentView(viewContorller: mail)
    } else {
      // show failure alert
      let alertController = UIAlertController(title: "오류 😢", message: "mail 앱에 계정이 연결되어 있지 않아요.\nhaeun.developer@gmail.com 으로 보내주세요.", preferredStyle: .alert)
      let action = UIAlertAction(title: "확인", style: .default) { (action:UIAlertAction) in
        print("확인 클릭");
      }
      alertController.addAction(action)
      delegate?.presentView(viewContorller: alertController)

    }
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true)
  }
}

