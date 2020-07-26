////
////  exchagneView.swift
////  GOtravel
////
////  Created by OOPSLA on 28/01/2019.
////  Copyright © 2019 haeun. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//import SnapKit
//
//protocol ExchangeTableCellProtocol {
//  var subTitle: String { get }
//  var mainTitle: String { get }
//  var numberTitle: String { get }
//}
//struct ExchangeTableCellViewModel: ExchangeTableCellProtocol{
//  var subTitle: String
//  
//  var mainTitle: String
//  
//  var numberTitle: String
//  
//  init(_ data: moneyDetailRealm) {
//    self.mainTitle = data.title
//    self.subTitle = data.subTitle
//    self.numberTitle = ""
//    
//  }
//}
//class ExchangeView: UIView,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//  
//  var viewModel: AccountViewModel?
//
//  // addDetailVC -> exchangeVC 에서 전달 받는 데이터
//  var countryRealmDB = countryRealm()
//  var selectDay = 0
//  
//  var moneyByDayCollectionView: UICollectionView = {
//    let flowLayout = UICollectionViewFlowLayout()
//    flowLayout.scrollDirection = .horizontal
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//    collectionView.translatesAutoresizingMaskIntoConstraints = false
//    collectionView.register(ExchangeCVCell.self, forCellWithReuseIdentifier: "exchangeCVCell")
//    collectionView.backgroundColor = UIColor.clear
//    collectionView.showsHorizontalScrollIndicator = false
//    return collectionView
//  }()
//  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//
//    self.addSubview(moneyByDayCollectionView)
//    self.addSubview(moneyLabel)
//    self.addSubview(belowView)
//    belowView.delegate = self
//    moneyByDayCollectionView.delegate = self
//    moneyByDayCollectionView.dataSource = self
//
//    moneyByDayCollectionView.snp.makeConstraints { (make) in
//      make.top.leading.trailing.equalTo(self)
//      make.height.equalTo(self.bounds.height / 12)
//    }
//
//    NSLayoutConstraint.activate([
//
//      moneyLabel.topAnchor.constraint(equalTo: moneyByDayCollectionView.bottomAnchor, constant: 5),
//      //            moneyLabel.bottomAnchor.constraint(equalTo: belowView.topAnchor),
//      moneyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//      moneyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//      moneyLabel.heightAnchor.constraint(equalToConstant: 60),
//
//      //            belowView.topAnchor.constraint(equalTo: mainCV.bottomAnchor, constant: 5),
//      belowView.topAnchor.constraint(equalTo: moneyLabel.bottomAnchor),
//      belowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//      belowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//      belowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//
//    ])
//    // 이전 뷰에서 선택된 셀 표시
//    let indexPathForFirstRow = NSIndexPath(item: selectDay, section: 0)
//    moneyByDayCollectionView.selectItem(at: indexPathForFirstRow as IndexPath, animated: true, scrollPosition: .centeredHorizontally)
//
//    belowView.countryRealmDB = self.countryRealmDB
//    belowView.selectDay = self.selectDay
//
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  override func layoutSubviews() {
//    super.layoutSubviews()
//  }
//
//  let moneyLabel: ExchangeSubView = {
//    let label = ExchangeSubView()
//    label.translatesAutoresizingMaskIntoConstraints = false
//    return label
//  }()
//  
//  // 테이블뷰
//  let belowView: ExchangeTV = {
//    let view = ExchangeTV()
//    view.layer.cornerRadius = 10
//    view.backgroundColor = UIColor.clear
//    view.translatesAutoresizingMaskIntoConstraints = false
//    return view
//  }()
//  func reloadMoneyLabels(index: Int){
//    // 라벨 계산
//    var todayTotal = 0
//    print("selectDat = \(index)")
//    for i in countryRealmDB.moneyList[index].detailList {
//      todayTotal = Int(i.money) + todayTotal
//    }
//    var allTotal = 0
//    for i in countryRealmDB.moneyList{
//      for j in i.detailList{
//        allTotal = allTotal + Int(j.money)
//      }
//    }
//
//  }
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return countryRealmDB.moneyList.count
//  }
//  
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "exchangeCVCell",
//            for: indexPath) as? ExchangeCVCell else {
//      return UICollectionViewCell()
//    }
//    cell.dayLabel.text = "\(indexPath.row) 일"
//    cell.layer.cornerRadius = 5
//    cell.backgroundColor = .white
//    // 여행 전 가계부
//    if indexPath.row == 0 {
//      cell.dayLabel.text = "여행 전"
//    }
//    
//    //        cell.backgroundColor = .red
//    return cell
//  }
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//  {
//    
//    return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
//  }
//  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//  {
//    
//    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//  }
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    viewModel?.selectedDayIndex.onNext(indexPath.row)
//  }
//}
