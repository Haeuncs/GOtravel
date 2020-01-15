//
//  HomeMainViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/17.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import RealmSwift

class HomeMainViewController: UIViewController {
  
  private var viewModel: HomeViewModel!
  private var service: HomeModelService!
  
  var disposeBag = DisposeBag()
//  /// realm trip data
//  var tripData = BehaviorSubject(value: [countryRealm]())
//  let realm = try? Realm()
//  /// realm basic data
//  var countryRealmDB : List<countryRealm>?
  /// for titleView Animation
  var titleConstraint: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
//    print(Realm.Configuration.defaultConfiguration.fileURL!)

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    rx()
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
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    titleConstraint?.constant -= view.bounds.width

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    disposeBag = DisposeBag()
  }
  
  func setup(count: Int){
    self.pageControl.numberOfPages = count
    self.pageControl.currentPage = 0
    if count == 0 {
      emptyView.isHidden = false
    }else{
      emptyView.isHidden = true
    }
  }
  
  func rx(){
    service = HomeModelService()
    viewModel = HomeViewModel(service: self.service)
    
    viewModel.tripData.subscribe(onNext: { (arr) in
      self.setup(count: arr.count)
      })
    .disposed(by: disposeBag)
    
    viewModel.tripData.asObserver()
      .bind(to: tripCollectionView.rx.items(
        cellIdentifier: String(describing: TripCell.self),
        cellType: TripCell.self)) { row, model, cell in
          cell.configure(withDelegate: mainVC_CVC_ViewModel(model))
          cell.mainBackgroundView.backgroundColor = HSBrandomColor()
          cell.mainBackgroundView.layer.zeplinStyleShadows(color: cell.mainBackgroundView.backgroundColor ?? .white , alpha: 0.6, x: 0, y: 0, blur: 20, spread: 0)
          
    }
    .disposed(by: disposeBag)

    tripCollectionView.rx.modelSelected(countryRealm.self)
      .subscribe(onNext: { (country) in
        let tripViewController = TripDetailViewController()
        tripViewController.countryRealmDB = country
        let nav = UINavigationController(rootViewController: tripViewController)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    navView.dismissBtn.rx.tap
      .subscribe(onNext: { (_) in
        let setting = SettingViewController()
        self.navigationController?.pushViewController(setting, animated: true)
      }).disposed(by: disposeBag)
    
    navView.actionBtn.rx.tap
      .subscribe(onNext: { (_) in
        let placeVC = AddTripViewController()
        placeVC.categoryIndex = 1
        self.navigationController?.pushViewController(placeVC, animated: true)
      }).disposed(by: disposeBag)
    
    emptyView.addButton.rx.tap
      .subscribe(onNext: { (_) in
        let placeVC = AddTripViewController()
        placeVC.categoryIndex = 1
        self.navigationController?.pushViewController(placeVC, animated: true)
      }).disposed(by: disposeBag)
  }
  
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "")
    view.setLeftIcon(image: UIImage(named: "settings")!)
    view.setRightIcon(image: UIImage(named: "plus")!)
    return view
  }()
  lazy var titleView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "여행 일정"
    label.textColor = .blackText
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
  lazy var emptyView: HomeTripEmptyView = {
    let view = HomeTripEmptyView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
    return view
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
    
    middleGuideView.addSubview(emptyView)
    
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
    emptyView.snp.makeConstraints { (make) in
//      make.top.greaterThanOrEqualTo(middleGuideView.snp.top)
//      make.bottom.lessThanOrEqualTo(middleGuideView.snp.bottom)
//      make.height.equalTo(250)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.center.equalTo(middleGuideView.snp.center)
    }
  }
}

extension HomeMainViewController {

  @objc func changeCell(_ sender: UIPageControl) {
    let page: Int? = sender.currentPage
    self.tripCollectionView.selectItem(at: IndexPath(row: page ?? 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    //    var frame: CGRect = self.tripCollectionView.frame
    //    frame.origin.x = frame.size.width * CGFloat(page ?? 0)
    //    frame.origin.y = 0
    //    self.tripCollectionView.scrollRectToVisible(frame, animated: true)
  }
}

extension HomeMainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let myCell = cell as? TripCell {
      UIView.animate(withDuration: 1, animations: {
        myCell.planeImageView.alpha = 1
        myCell.planeImageView.transform = CGAffineTransform(translationX: 60
          , y: 0)
      })
    }
  }
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let myCell = cell as? TripCell {
      UIView.animate(withDuration: 1, animations: {
        myCell.planeImageView.alpha = 0
        myCell.planeImageView.transform = .identity
      })
    }
  }
}
extension HomeMainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return tripCollectionView.bounds.size
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}
extension HomeMainViewController: UIScrollViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let x = targetContentOffset.pointee.x
    let index = Int(x / tripCollectionView.frame.width)
    self.pageControl.currentPage = index
  }
  
}
