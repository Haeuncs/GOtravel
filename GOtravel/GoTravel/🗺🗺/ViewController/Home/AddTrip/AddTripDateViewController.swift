//
//  calendarViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 14/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import RealmSwift

import UIKit
import MapKit
import SnapKit

enum MyTheme {
  case light
  case dark
}
var ddayDB = 0
var nightDB = 0
var dayDate = Date()
var categoryArr = ["항공","숙박","쇼핑","식사","교통비","기타"]

class AddTripDateViewController: UIViewController {
  
  let realm = try! Realm()
  
  var saveCountryRealmData = countryRealm()
  
  var dayListDB = List<dayRealm>()
  var theme = MyTheme.dark
  //    let eventC = event()
  //    @IBAction func plusBtn(_ sender: Any) {
  //        eventC.sideMenu(selfV: self)
  //    }
  //    @IBAction func sideBtn(_ sender: Any) {
  //        panel?.openLeft(animated: true)
  //    }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "여행 기간 설정 🗓"
    initializeView()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.extendedLayoutIncludesOpaqueBars = true
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: true, completion: nil)
      customTabBarController.setSelectLine(index: 0)
    }
  }
  func saveRealmData(){
    // realm location print
    //        print(Realm.Configuration.defaultConfiguration.fileURL!)
    
    saveCountryRealmData.country = saveCountryRealmData.country
    saveCountryRealmData.city = saveCountryRealmData.city
    saveCountryRealmData.date = dayDate
    saveCountryRealmData.period = nightDB
    saveCountryRealmData.longitude = saveCountryRealmData.longitude
    saveCountryRealmData.latitude = saveCountryRealmData.latitude
    
    for i in 1...nightDB{
      // 디테일 기록 데이
      let dayRealmDB = dayRealm()
      dayRealmDB.day = i
      dayListDB.append(dayRealmDB)
      // 가계부 기록 데이
      let moneyRealmDB = moneyRealm()
      moneyRealmDB.day = i-1
      saveCountryRealmData.moneyList.append(moneyRealmDB)
    }
    
    let moneyRealmDB = moneyRealm()
    moneyRealmDB.day = nightDB
    saveCountryRealmData.moneyList.append(moneyRealmDB)
    
    saveCountryRealmData.dayList = dayListDB
    
    for i in 0..<categoryArr.count{
      let catecoryDB = categoryDetailRealm()
      catecoryDB.title = categoryArr[i]
      saveCountryRealmData.categoryList.append(catecoryDB)
      
    }
    try! realm.write {
      realm.add(saveCountryRealmData)
    }
    
    
  }
  func initializeView(){
        
    self.view.backgroundColor = .white
    let availableWidth = view.frame.width - 7 - 10
    let widthPerItem = availableWidth / 7
    view.addSubview(navView)
    view.addSubview(calenderView)
    navView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(44)
    }
    //        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
    calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive=true
    calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive=true
    //        calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 12).isActive=true
    calenderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
    calenderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
    calenderView.heightAnchor.constraint(equalToConstant: 70 + (widthPerItem * 6)).isActive=true
    
    view.addSubview(addBtn)
    addBtn.topAnchor.constraint(equalTo: calenderView.bottomAnchor,constant: 20).isActive=true
    //        ddayLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-5).isActive = true
    addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    addBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
    addBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive=true
    addBtn.heightAnchor.constraint(equalToConstant: 50).isActive=true
    
    
  }
  @objc func buttonClicked(){
    print("select")
    saveRealmData()
    self.navigationController?.popToRootViewController(animated: true)
  }
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "여행 기간 설정")
    view.setLeftIcon(image: UIImage(named: "back")!)
    view.dismissBtn.addTarget(self, action: #selector(popEvent), for: .touchUpInside)
    return view
  }()
  @objc func popEvent(){
    self.navigationController?.popViewController(animated: true)
  }
  let addBtn : UIButton = {
    let b = UIButton()
    b.translatesAutoresizingMaskIntoConstraints=false
    b.layer.cornerRadius = 5
    b.puls()
    b.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    b.isHidden = false
    b.setTitle("일정 추가하기", for: .normal)
    b.setTitleColor(.white, for: .normal)
    b.tag = 0
    b.isSelected = true
    b.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    return b
  }()
  
  let ddayLabel : UILabel = {
    let label = UILabel()
    label.text = ""
    label.textAlignment = .center
    label.font=UIFont.systemFont(ofSize: 20, weight: .heavy)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints=false
    return label
  }()
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
  }
  
  let calenderView: CalenderView = {
    let v=CalenderView(theme: MyTheme.dark)
    v.translatesAutoresizingMaskIntoConstraints=false
    return v
  }()
  
}
