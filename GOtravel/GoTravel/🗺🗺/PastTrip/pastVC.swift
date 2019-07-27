//
//  pastVC.swift
//  GOtravel
//
//  Created by OOPSLA on 02/03/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation                              
import UIKit
import CenteredCollectionView
import RealmSwift

class pastVC: UIViewController {
  //    @IBOutlet weak var subView: UIView!
  let selection = UISelectionFeedbackGenerator()
  let notification = UINotificationFeedbackGenerator()
  
  let centeredCollectionViewFlowLayout = CenteredCollectionViewFlowLayout()
  var collectionView: UICollectionView!
  
  let controlCenter = ControlCenterView()
  let cellPercentWidth: CGFloat = 0.8
  var scrollToEdgeEnabled = false
  
  var myBackgroundColor : UIColor?
  let realm = try? Realm()
  // 기본 저장 데이터
  var countryRealmDB : List<countryRealm>?
  
  @IBAction func addBtn(_ sender: Any) {
    let placeVC = placeSearchViewController()
    placeVC.categoryIndex = 1
    self.navigationController?.pushViewController(placeVC, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
    
    print("viewWillAppear")
    print(self.view.frame)
    print(self.view.bounds)
    
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewdidLoad")
    initView()
  }
  lazy var guideView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  func initView(){
    print(self.view.frame.height)
    
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Defaull_style.mainTitleColor]
    self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    
    self.navigationItem.title = "지난여행"
    title = self.navigationItem.title
    
    collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
    // Just to make the example pretty ✨
    collectionView.backgroundColor = .clear
    
    // delegate & data source
    controlCenter.delegate = self
    collectionView.delegate = self
    collectionView.dataSource = self
    
    // layout subviews
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.addArrangedSubview(collectionView)
    view.addSubview(guideView)
    guideView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      guideView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      guideView.leftAnchor.constraint(equalTo: view.leftAnchor),
      guideView.rightAnchor.constraint(equalTo: view.rightAnchor),
      guideView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      stackView.widthAnchor.constraint(equalToConstant: view.frame.width),
      stackView.heightAnchor.constraint(equalToConstant: view.frame.height/2),
      stackView.centerXAnchor.constraint(equalTo: guideView.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: guideView.centerYAnchor),
      
      ])
    // register collection cells
    collectionView.register(
      ProgrammaticCollectionViewCell.self,
      forCellWithReuseIdentifier: String(describing: ProgrammaticCollectionViewCell.self)
    )
    
    // configure layout
    centeredCollectionViewFlowLayout.itemSize = CGSize(
      width: self.view.bounds.width * cellPercentWidth,
      height:self.view.bounds.height/2
    )
    centeredCollectionViewFlowLayout.minimumLineSpacing = 20
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    
    self.navigationController?.navigationBar.isHidden = false
    self.tabBarController?.tabBar.isHidden = false
    
    // realm 데이터 정렬 ascending 오름차순 정렬 (dday가 적게 남은 순으로 정렬한다.)
    
    countryRealmDB = processingDateData()
    //        countryRealmDB = realm?.objects(countryRealm.self)
    //        countryRealmDB = countryRealmDB?.sorted(byKeyPath: "date", ascending: true)
  }
  func processingDateData() -> List<countryRealm>{
    let processedData = List<countryRealm>()
    
    // 1. load
    var countryRealmDB = realm?.objects(countryRealm.self)
    countryRealmDB = countryRealmDB?.sorted(byKeyPath: "date", ascending: true)
    // 2. processing
    if let countryRealmDB = countryRealmDB {
      for i in countryRealmDB {
        let startDay = i.date ?? Date()
        let endDate = Calendar.current.date(byAdding: .day, value: i.period, to: startDay)
        print(Date())
        print(startDay)
        print(endDate)
        if endDate ?? Date() < Date() {
          processedData.append(i)
        }
      }
    }
    print(processedData.count)
    return processedData
  }
  
}

extension pastVC: ControlCenterViewDelegate {
  func stateChanged(scrollDirection: UICollectionView.ScrollDirection) {
    centeredCollectionViewFlowLayout.scrollDirection = scrollDirection
  }
  
  func stateChanged(scrollToEdgeEnabled: Bool) {
    self.scrollToEdgeEnabled = scrollToEdgeEnabled
    
  }
}

extension pastVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    notification.notificationOccurred(.success)
    UIView.animate(withDuration: 0.3) {
      if let cell = collectionView.cellForItem(at: indexPath) as? ProgrammaticCollectionViewCell {
        cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
      }
    }
    
    let nav1 = UINavigationController()
    let detailView = addDetailViewController()
    nav1.viewControllers = [detailView]
    if let countryRealmDB = countryRealmDB {
      detailView.countryRealmDB = countryRealmDB[indexPath.row]
    }
    
    self.present(nav1, animated: true, completion: nil)
  }
  
}

extension pastVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return countryRealmDB?.count ?? 0
  }
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    UIView.animate(withDuration: 0.3) {
      if let cell = collectionView.cellForItem(at: indexPath) as? ProgrammaticCollectionViewCell {
        cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    UIView.animate(withDuration: 0.3) {
      if let cell = collectionView.cellForItem(at: indexPath) as? ProgrammaticCollectionViewCell {
        cell.contentView.transform = .identity
      }
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgrammaticCollectionViewCell.self), for: indexPath) as! ProgrammaticCollectionViewCell
    
    cell.configure(withDelegate: mainVC_CVC_ViewModel(countryRealmDB![indexPath.row]))
    print(countryRealmDB![indexPath.row])
    cell.contentView.transform = .identity
    // random color 를 cell의 background
    cell.contentView.backgroundColor = HSBrandomColor()
    
    return cell
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    print("Current centered index1: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    print("Current centered index2: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
  }
}
