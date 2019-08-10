//
//  exchangeViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 17/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//
import UIKit
import RealmSwift

// collectionView Cell 클릭한 index알기
protocol exchangeCVCDelegate : class {
  func exchangeCVCDelegateDidTap(_ sender : exchangeCVCell)
  
  
}

class exchangeViewController : UIViewController, exchangeCVCDelegate{
  
  func exchangeCVCDelegateDidTap(_ sender: exchangeCVCell) {
    guard let tappedIndexPath = mainView.mainCV.indexPath(for: sender) else { return }
    
    //        print(sender)
    print("\(tappedIndexPath.row) 이거는 addDataVC")
    selectDay = tappedIndexPath.row
    
    mainView.belowView.countryRealmDB = self.countryRealmDB
    mainView.belowView.selectDay = self.selectDay
    mainView.belowView.moneyTV.reloadData()
    // 라벨 계산
    var todayTotal = 0
    print("selectDat = \(selectDay)")
    for i in countryRealmDB.moneyList[selectDay].detailList {
      todayTotal = Int(i.money) + todayTotal
    }
    var allTotal = 0
    for i in countryRealmDB.moneyList{
      for j in i.detailList{
        allTotal = allTotal + Int(j.money)
      }
    }
    mainView.moneyLabel.moneyDayLabel.text = "￦ \(todayTotal.toNumber())"
    mainView.moneyLabel.moneyTotalLabel.text = "￦ \(allTotal.toNumber())"
    
  }
  
  
  
  // addDetailVC 에서 전달 받는 데이터
  var countryRealmDB = countryRealm()
  var selectDay = 0
  
  let realm = try! Realm()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainView.delegate = self
    mainView.belowView.moneyTV.reloadData()
    self.navigationItem.title = "여행 경비"
    self.view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Defaull_style.mainTitleColor]
    self.navigationController?.navigationBar.tintColor = Defaull_style.subTitleColor
    
    self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    
    let rightButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(self.addEvent))
    self.navigationItem.rightBarButtonItem = rightButton
    
    // 뷰 겹치는거 방지
    self.navigationController!.navigationBar.isTranslucent = false
    // 까만거 지우려고
    self.navigationController!.view.backgroundColor = .white
    
    
    initView()
    
    // 데이터 보내기
    mainView.countryRealmDB = self.countryRealmDB
    mainView.selectDay = self.selectDay
    
    // 라벨 계산
    var todayTotal = 0
    print("selectDat = \(selectDay)")
    for i in countryRealmDB.moneyList[selectDay].detailList {
      todayTotal = Int(i.money) + todayTotal
    }
    var allTotal = 0
    for i in countryRealmDB.moneyList{
      for j in i.detailList{
        allTotal = allTotal + Int(j.money)
      }
    }
    mainView.moneyLabel.moneyDayLabel.text = "￦ \(todayTotal.toNumber())"
    mainView.moneyLabel.moneyTotalLabel.text = "￦ \(allTotal.toNumber())"
  }
  
  func initView(){
    //        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    self.view.addSubview(mainView)
    let mainViewPadding = CGFloat(20)
    
    mainView.backgroundColor = Defaull_style.topTableView
    mainView.layer.cornerRadius = CGFloat(Defaull_style.topTableViewCorner)
    
    
    NSLayoutConstraint.activate([
      mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: mainViewPadding),
      mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -mainViewPadding),
      mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: mainViewPadding),
      mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -mainViewPadding),
    ])
  }
  let mainView : exchangeView = {
    let view = exchangeView()
    view.backgroundColor = Defaull_style.backgroundColor
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  @objc func addEvent(){
    let vc = exchangeAddDataVC()
    vc.countryRealmDB = self.countryRealmDB
    vc.selectDay = self.selectDay
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
