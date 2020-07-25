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

enum TravelContentType {
    case traveling
    case past
    case future
}

class HomeMainViewController: UIViewController {
  
  private var viewModel: HomeViewModel!
  private var service: HomeModelService!
  
  var disposeBag = DisposeBag()
  /// for titleView Animation
  var titleConstraint: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    //    print(Realm.Configuration.defaultConfiguration.fileURL!)

    initView()
    rx()
    viewModel.getTripData()

    NotificationCenter.default.addObserver(
        self,
        selector: #selector(tripDataChanged),
        name: .tripDataChange,
        object: nil
    )

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: false, completion: nil)
    }
    
    navigationController?.navigationBar.isHidden = true

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
  }
  
  func setup(count: Int){
    contentView.pageControl.numberOfPages = count
    contentView.pageControl.currentPage = 0
    if count == 0 {
      contentView.emptyView.isHidden = false
    }else{
      contentView.emptyView.isHidden = true
    }
  }
  
  func initView(){
    view.backgroundColor = .white
    contentView.tripCollectionView.delegate = self
    
    view.addSubview(contentView)
    contentView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    titleConstraint = contentView.titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    titleConstraint?.constant -= view.bounds.width
    titleConstraint?.isActive = true

  }
  
  func rx(){
    service = HomeModelService()
    viewModel = HomeViewModel(service: self.service)
    
    viewModel.tripData
        .distinctUntilChanged({ $0.count == $1.count })
        .subscribe(onNext: { [weak self] (arr) in
      self?.setup(count: arr.count)
    })
      .disposed(by: disposeBag)
    
    viewModel.tripData.asObserver()
      .bind(to: contentView.tripCollectionView.rx.items(
        cellIdentifier: String(describing: TripCell.self),
        cellType: TripCell.self)) { _, model, cell in
          cell.configure(withDelegate: MainVCCVCViewModel(model))
            cell.mainBackgroundView.backgroundColor = UIColor().HSBrandomColor()
          cell.mainBackgroundView.layer.zeplinStyleShadows(color: cell.mainBackgroundView.backgroundColor ?? .white , alpha: 0.6, x: 0, y: 0, blur: 20, spread: 0)
          
    }
    .disposed(by: disposeBag)
    
    contentView.tripCollectionView.rx.modelSelected(TripDataType.self)
      .subscribe(onNext: { [weak self] (tripData) in
        let tripViewController = TripDetailMainViewController(trip: tripData.trip)
        let nav = UINavigationController(rootViewController: tripViewController)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self?.present(nav, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    contentView.navView.dismissBtn.rx.tap
      .subscribe(onNext: { [weak self](_) in
        let setting = SettingViewController()
        self?.navigationController?.pushViewController(setting, animated: true)
      }).disposed(by: disposeBag)
    
    contentView.navView.actionBtn.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        let placeVC = AddTripViewControllerNew()
        //        placeVC.categoryIndex = 1
        self?.navigationController?.pushViewController(placeVC, animated: true)
      }).disposed(by: disposeBag)
    
    contentView.emptyView.addButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        let placeVC = AddTripViewControllerNew()
        //        placeVC.categoryIndex = 1
        self?.navigationController?.pushViewController(placeVC, animated: true)
      }).disposed(by: disposeBag)
  }
  
  lazy var contentView: HomeMainView = {
    let view = HomeMainView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}

extension HomeMainViewController {
  @objc func changeCell(_ sender: UIPageControl) {
    let page: Int? = sender.currentPage
    contentView.tripCollectionView.selectItem(at: IndexPath(row: page ?? 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
  }

    @objc func tripDataChanged() {
        viewModel.getTripData()
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
    return contentView.tripCollectionView.bounds.size
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}

extension HomeMainViewController: UIScrollViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let x = targetContentOffset.pointee.x
    let index = Int(x / contentView.tripCollectionView.frame.width)
    contentView.pageControl.currentPage = index
  }
  
}
