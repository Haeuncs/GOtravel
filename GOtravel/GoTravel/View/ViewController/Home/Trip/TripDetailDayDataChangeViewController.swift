//
//  changeDetailOfDayViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 20/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SnapKit

protocol changeDelegate : class {
  func showAlert(longitude : Double, latitude : Double, title : String)
}

// detailVC 에서 cell 선택 시 이동하는 수정 뷰
class TripDetailDayDataChangeViewController : UIViewController{
  //detailVC에서 받는 데이터
  var detailRealmDB : detailRealm?
  var countryRealmDB : countryRealm?
  
  let realm = try! Realm()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if detailRealmDB != nil {
      let setData = mainView as? changeDetailView;
      // 기존 데이터 입력
      setData?.detailRealmDB = detailRealmDB
      setData?.titleTextInput.text = detailRealmDB?.title
      setData?.mainTitle.text = (countryRealmDB?.city)! + " " + "여행"
      setData?.miniMemoTextInput.text = detailRealmDB?.oneLineMemo
      setData?.memoTextInput.text = detailRealmDB?.memo
      setData?.colorPik = detailRealmDB?.color ?? "default"
    }
  }
  
  func initView(){
    view.addSubview(navView)
    self.view.addSubview(mainView)
    view.backgroundColor = .white
    
    mainView.delegate = self
    
    initLayoutConstraint()
  }
  func initLayoutConstraint(){
    
    let mainViewPadding = CGFloat(10)
    navView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(44)
    }
    NSLayoutConstraint.activate([
      mainView.topAnchor.constraint(equalTo: navView.bottomAnchor, constant: mainViewPadding),
      mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -mainViewPadding),
      mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: mainViewPadding),
      mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -mainViewPadding),
    ])
  }
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "")
    view.setButtonDoneText(title: "저장")
    view.setLeftForBack()
    view.dismissBtn.addTarget(self, action: #selector(cancelBtn), for: .touchUpInside)
    view.actionBtn.addTarget(self, action: #selector(saveBtn), for: .touchUpInside)
    return view
  }()

  let mainView : changeDetailView = {
    let view = changeDetailView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 1
    view.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  @objc func cancelBtn(){
    self.navigationController?.popViewController(animated: true)
  }
  @objc func saveBtn(){
    let setData = mainView as? changeDetailView;
    if setData?.colorPik == "" {
      setData?.colorPik = "default"
    }
    try! realm.write {
      detailRealmDB?.color = setData!.colorPik
      detailRealmDB?.title = setData!.titleTextInput.text!
      detailRealmDB?.startTime = setData!.startTime
      detailRealmDB?.EndTime = setData!.endTime
      detailRealmDB?.memo = setData!.memoTextInput.text!
      detailRealmDB?.oneLineMemo = setData!.miniMemoTextInput.text!
    }
    
    self.navigationController?.popViewController(animated: true)
  }
}
// Delegate
extension TripDetailDayDataChangeViewController : changeDelegate {
  func showAlert(longitude : Double, latitude : Double, title : String) {
    let titleAddSub = title.replacingOccurrences(of: " ", with: "+")
    let alertController = UIAlertController(title: "길찾기", message: "길찾기에 사용할 어플을 선택하세요.", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "애플 지도", style: .default, handler: {(_) in
      let text = "http://maps.apple.com/?q=\(titleAddSub)&sll=\(latitude),\(longitude)&z=10&t=s"
      let encoded = text.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
      
      UIApplication.shared.open(URL(string: encoded!)!, options: [:], completionHandler: nil)
    }))
    alertController.addAction(UIAlertAction(title: "구글 지도", style: .default, handler:{(_) in
      if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
        let text = "comgooglemaps://?q=\(titleAddSub)&center=\(latitude),\(longitude)&zoom=15&views=transit"
        let encoded = text.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //한글 검색어도 사용할 수 있도록 함
        
        UIApplication.shared.openURL(URL(string:
          encoded!)!)
      } else {
        print("Can't use comgooglemaps://");
      }
    }))
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    
    self.present(alertController, animated: true, completion: nil)
    
  }
  
}
