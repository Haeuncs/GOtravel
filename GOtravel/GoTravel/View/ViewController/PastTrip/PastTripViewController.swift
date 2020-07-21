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

class PastTripViewController: UIViewController {
  //    @IBOutlet weak var subView: UIView!
  let selection = UISelectionFeedbackGenerator()
  let notification = UINotificationFeedbackGenerator()
  
  let emptyView = PastTripEmptyView()
  
  var disposeBag = DisposeBag()
  /// realm trip data
  var tripData = BehaviorSubject(value: [TravelDataType]())
  let realm = try? Realm()
  // 기본 저장 데이터
  var countryRealmDB: List<countryRealm>?
  /// for titleView Animation
  var titleConstraint: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    rx()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    processingDateData()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    titleConstraint?.constant = 0
    UIView.animate(withDuration: 0.6,
                   delay: 0,
                   options: [.curveEaseOut],
                   animations: { [weak self] in
                    self?.view.layoutIfNeeded()
      }, completion: nil)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    disposeBag = DisposeBag()
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    titleConstraint?.constant -= view.bounds.width
  }
  
  func rx(){
    tripData.asObservable()
      .bind(to: tripCollectionView.rx.items(
        cellIdentifier: String(describing: TripCell.self),
        cellType: TripCell.self)) { _, model, cell in
          cell.configure(withDelegate: MainVCCVCViewModel(model))
          cell.mainBackgroundView.backgroundColor = HSBrandomColor()
          cell.mainBackgroundView.layer.zeplinStyleShadows(color: cell.mainBackgroundView.backgroundColor ?? .white , alpha: 0.3, x: 0, y: 15, blur: 15, spread: 0)
          
    }.disposed(by: disposeBag)
    
    tripCollectionView.rx.modelSelected(countryRealm.self)
      .subscribe(onNext: { (country) in
        let tripViewController = TripDetailMainViewController()
        tripViewController.countryRealmDB = country
        let nav = UINavigationController(rootViewController: tripViewController)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
  }
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.isHidden = true
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "")
    return view
  }()
  lazy var titleView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "지난 여행"
    label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    return label
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
    collect.showsHorizontalScrollIndicator = false
    collect.isPagingEnabled = true
    collect.backgroundColor = .white
    collect.register(
      TripCell.self,
      forCellWithReuseIdentifier: String(describing: TripCell.self))
    collect.translatesAutoresizingMaskIntoConstraints = false
    return collect
  }()
  lazy var pageControl: UIPageControl = {
    let page = UIPageControl()
    page.currentPageIndicatorTintColor = .black
    page.pageIndicatorTintColor = .grey03
    page.translatesAutoresizingMaskIntoConstraints = false
    page.addTarget(self, action: #selector(changeCell), for: .touchUpInside)
    return page
  }()
  
  func initView(){
    view.backgroundColor = .white
    tripCollectionView.delegate = self
    
        view.addSubview(navView)
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        view.addSubview(middleGuideView)
        middleGuideView.addSubview(tripCollectionView)
        view.addSubview(pageControl)
        navView.snp.makeConstraints { (make) in
          make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
          make.left.equalTo(view.snp.left)
          make.right.equalTo(view.snp.right)
          make.height.equalTo(44)
        }
        titleView.snp.makeConstraints{ make in
          make.top.greaterThanOrEqualTo(navView.snp.bottom)
    //      make.left.equalTo(view.snp.left)
          make.right.equalTo(view.snp.right)
          make.bottom.equalTo(middleGuideView.snp.top)
        }
        titleConstraint = titleView.leftAnchor.constraint(equalTo: view.leftAnchor)
        titleConstraint?.constant -= view.bounds.width
        titleConstraint?.isActive = true
        
        titleLabel.snp.makeConstraints{ make in
          make.top.greaterThanOrEqualTo(titleView.snp.top)
          make.left.equalTo(titleView.snp.left).offset(16)
          make.right.equalTo(titleView.snp.right)
          make.bottom.equalTo(titleView.snp.bottom)
        }
        middleGuideView.snp.makeConstraints { (make) in
          make.top.equalTo(navView.snp.bottom).offset(60)
          make.left.equalTo(view.snp.left)
          make.right.equalTo(view.snp.right)
          make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        tripCollectionView.snp.makeConstraints { (make) in
          make.centerX.equalTo(middleGuideView.snp.centerX)
          make.centerY.equalTo(middleGuideView.snp.centerY)
          make.height.equalTo(middleGuideView.snp.height)
          make.width.equalTo(middleGuideView.snp.width)
        }
        pageControl.snp.makeConstraints{make in
          make.top.equalTo(middleGuideView.snp.bottom)
          make.left.equalTo(view.snp.left)
          make.right.equalTo(view.snp.right)
        }
  }
  
  func processingDateData(){
    var processedData = List<countryRealm>()
    
    // 1. load
    guard var countryRealmDB = realm?.objects(countryRealm.self) else {
        tripData.onNext([])
        return
    }
    
    countryRealmDB = countryRealmDB.sorted(byKeyPath: "date", ascending: true)

    var processedTravel = HomeModelService.pastTravel(data: countryRealmDB)
    // 3. order
    processedTravel.sort { (($0.countryData.date)?.compare($1.countryData.date!))! == .orderedDescending }
    
    if processedTravel.count == 0 {
      tripCollectionView.backgroundView = emptyView
    }else{
      tripCollectionView.backgroundView = .none
    }
    self.pageControl.numberOfPages = processedData.count
    self.pageControl.currentPage = 0
    tripData.onNext(Array(processedTravel))
  }
  @objc func changeCell(_ sender: UIPageControl) {
    let page: Int? = sender.currentPage
    self.tripCollectionView.selectItem(at: IndexPath(row: page ?? 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
  }

}

extension PastTripViewController: UICollectionViewDelegate {
  
}
extension PastTripViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return tripCollectionView.bounds.size
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}
extension PastTripViewController: UIScrollViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let x = targetContentOffset.pointee.x
    let index = Int(x / tripCollectionView.frame.width)
    self.pageControl.currentPage = index
  }
  
}
