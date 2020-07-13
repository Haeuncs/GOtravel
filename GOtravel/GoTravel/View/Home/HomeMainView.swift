//
//  HomeMainView.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/03/26.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeMainView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // View ✨
  func initView() {
    self.addSubview(navView)
    self.addSubview(titleView)
    titleView.addSubview(titleLabel)
    self.addSubview(middleGuideView)
    middleGuideView.addSubview(tripCollectionView)
    self.addSubview(pageControl)
    
    middleGuideView.addSubview(emptyView)
    
    navView.snp.makeConstraints { (make) in
      make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.height.equalTo(44)
    }
    titleView.snp.makeConstraints{ make in
      make.top.greaterThanOrEqualTo(navView.snp.bottom)
      make.trailing.equalTo(self.snp.trailing)
      make.bottom.equalTo(middleGuideView.snp.top)
    }
    
    titleLabel.snp.makeConstraints{ make in
      make.top.greaterThanOrEqualTo(titleView.snp.top)
      make.leading.equalTo(titleView.snp.leading).offset(16)
      make.trailing.equalTo(titleView.snp.trailing)
      make.bottom.equalTo(titleView.snp.bottom)
    }
    middleGuideView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom).offset(60)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-60)
    }
    tripCollectionView.snp.makeConstraints { (make) in
      make.centerX.equalTo(middleGuideView.snp.centerX)
      make.centerY.equalTo(middleGuideView.snp.centerY)
      make.height.equalTo(middleGuideView.snp.height)
      make.width.equalTo(middleGuideView.snp.width)
    }
    pageControl.snp.makeConstraints{make in
      make.top.equalTo(middleGuideView.snp.bottom)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
    }
    emptyView.snp.makeConstraints { (make) in
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.center.equalTo(middleGuideView.snp.center)
    }
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
    label.textColor = .black
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
    return page
  }()
  lazy var emptyView: HomeTripEmptyView = {
    let view = HomeTripEmptyView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
    return view
  }()

}
