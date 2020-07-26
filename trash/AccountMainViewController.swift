//
//  exchangeViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 17/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//
import UIKit

import RxCocoa
import RxSwift

class AccountMainViewController: UIViewController{
  var viewModel = AccountViewModel()
  var disposeBag = DisposeBag()
  
  // addDetailVC 에서 전달 받는 데이터
  var countryRealmDB = countryRealm()
  var selectDay = 0

  let realm = try! Realm()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationItem.title = "여행 경비"
    self.view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Defaull_style.mainTitleColor]
    self.navigationController?.navigationBar.tintColor = .black
    
    self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    
    let rightButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(self.addEvent))
    self.navigationItem.rightBarButtonItem = rightButton
    
    // 뷰 겹치는거 방지
    self.navigationController!.navigationBar.isTranslucent = false
    // 까만거 지우려고
    self.navigationController!.view.backgroundColor = .white
    
    attribute()
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
//    mainView.moneyLabel.moneyDayLabel.text = "￦ \(todayTotal.toNumber())"
//    mainView.moneyLabel.moneyTotalLabel.text = "￦ \(allTotal.toNumber())"
//
    mainView.belowView.moneyTV.reloadData()

  }
  func attribute(){
    mainView.viewModel = self.viewModel
    viewModel.selectedDayIndex.asObservable()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (index) in
        self.collectionViewSelected(index: index)
      }).disposed(by: disposeBag)
    mainView.belowView.moneyTV.rx.itemSelected
      .subscribe(onNext: { (index) in
        let vc = DirectAddAccountViewController()
        vc.editMoneyDetailRealm = self.countryRealmDB.moneyList[self.selectDay].detailList[index.row]
        self.navigationController?.pushViewController(vc, animated: true)
      }).disposed(by: disposeBag)
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
  let mainView: exchangeView = {
    let view = exchangeView()
    view.backgroundColor = Defaull_style.backgroundColor
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  @objc func addEvent(){
    let vc = DirectAddReceiptViewController()
    print(self.countryRealmDB)
    vc.realmMoneyList = self.countryRealmDB.moneyList[selectDay]
    self.navigationController?.pushViewController(vc, animated: true)
//    let vc = DirectAddAccountViewController()
//    vc.realmMoneyList = self.countryRealmDB.moneyList[selectDay]
////    vc.countryRealmDB = self.countryRealmDB
////    vc.selectDay = self.selectDay
//    self.navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - Logic
extension AccountMainViewController {
  func collectionViewSelected(index: Int){
    print("\(index) 이거는 addDataVC")
    selectDay = index
    
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
//    mainView.moneyLabel.moneyDayLabel.text = "￦ \(todayTotal.toNumber())"
//    mainView.moneyLabel.moneyTotalLabel.text = "￦ \(allTotal.toNumber())"

  }
}
