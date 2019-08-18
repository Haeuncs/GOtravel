//
//  pastVC.swift
//  GOtravel
//
//  Created by OOPSLA on 02/03/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation                              
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import RealmSwift

class pastVC: UIViewController {
  //    @IBOutlet weak var subView: UIView!
  let selection = UISelectionFeedbackGenerator()
  let notification = UINotificationFeedbackGenerator()
  
  var disposeBag = DisposeBag()
  /// realm trip data
  var tripData = BehaviorSubject(value: [countryRealm]())
  let realm = try? Realm()
  // 기본 저장 데이터
  var countryRealmDB : List<countryRealm>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    rx()
    processingDateData()
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    disposeBag = DisposeBag()
  }
  func rx(){
    tripData.asObservable()
      .bind(to: tripCollectionView.rx.items(
        cellIdentifier: String(describing: TripCell.self),
        cellType: TripCell.self)) { row, model, cell in
          cell.configure(withDelegate: mainVC_CVC_ViewModel(model))
          cell.mainBackgroundView.backgroundColor = HSBrandomColor()
          cell.mainBackgroundView.layer.zeplinStyleShadows(color: cell.mainBackgroundView.backgroundColor ?? .white , alpha: 0.3, x: 0, y: 15, blur: 15, spread: 0)
          
      }.disposed(by: disposeBag)
    
    tripCollectionView.rx.modelSelected(countryRealm.self)
      .subscribe(onNext: { (country) in
        let tripViewController = TripDetailViewController()
        tripViewController.countryRealmDB = country
        let nav = UINavigationController(rootViewController: tripViewController)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
//    navView.dismissBtn.rx.tap
//      .subscribe(onNext: { (_) in
//        let setting = SettingViewController()
//        self.navigationController?.pushViewController(setting, animated: true)
//      }).disposed(by: disposeBag)
//    
//    navView.actionBtn.rx.tap
//      .subscribe(onNext: { (_) in
//        let placeVC = AddTripViewController()
//        placeVC.categoryIndex = 1
//        self.navigationController?.pushViewController(placeVC, animated: true)
//      }).disposed(by: disposeBag)
  }

  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.isHidden = true
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "")
    return view
  }()
  lazy var middleGuideView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var tripCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collect.isPagingEnabled = true
    collect.backgroundColor = .white
    collect.register(
      TripCell.self,
      forCellWithReuseIdentifier: String(describing: TripCell.self))
    collect.translatesAutoresizingMaskIntoConstraints = false
    return collect
  }()
  func initView(){
    view.backgroundColor = .white
    tripCollectionView.delegate = self
    
    view.addSubview(navView)
    view.addSubview(middleGuideView)
    middleGuideView.addSubview(tripCollectionView)
    
    navView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(44)
    }
    middleGuideView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    tripCollectionView.snp.makeConstraints { (make) in
      make.centerX.equalTo(middleGuideView.snp.centerX)
      make.centerY.equalTo(middleGuideView.snp.centerY)
      make.height.equalTo(middleGuideView.snp.height)
      make.width.equalTo(middleGuideView.snp.width)
    }
  }

  func processingDateData(){
    let processedData = List<countryRealm>()
    
    // 1. load
    var countryRealmDB = realm?.objects(countryRealm.self)
    countryRealmDB = countryRealmDB?.sorted(byKeyPath: "date", ascending: true)
    // 2. processing
    if let countryRealmDB = countryRealmDB {
      for i in countryRealmDB {
        let startDay = i.date ?? Date()
        let endDate = Calendar.current.date(byAdding: .day, value: i.period, to: startDay)
        if endDate ?? Date() < Date() {
          processedData.append(i)
        }
      }
    }
    print(processedData.count)
    tripData.onNext(Array(processedData))
  }
}

extension pastVC: UICollectionViewDelegate {
  
}
extension pastVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return tripCollectionView.bounds.size
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  
}
