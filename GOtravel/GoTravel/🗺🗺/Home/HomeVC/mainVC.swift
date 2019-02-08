//
//  ViewController.swift
//  Example
//
//  Created by Benjamin Emdon on 2016-12-28.
//  Copyright © 2016 Benjamin Emdon.
//

import UIKit
import CenteredCollectionView
import RealmSwift

class mainVC: UIViewController {
    @IBOutlet weak var subView: UIView!
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
    var countryRealmDB : Results<countryRealm>?
    
    @IBAction func addBtn(_ sender: Any) {
        let placeVC = placeSearchViewController()
        placeVC.categoryIndex = 1
        self.navigationController?.pushViewController(placeVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        print("viewWillAppear")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidLoad")
        initView()
    }
    func initView(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Defaull_style.mainTitleColor]
        self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
        self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
        
        self.navigationItem.title = "일정"
        title = self.navigationItem.title
        
        collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
        // Just to make the example pretty ✨
        collectionView.backgroundColor = UIColor.clear
        // delegate & data source
        controlCenter.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // layout subviews
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(collectionView)
        subView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: self.subView.frame.width),
            stackView.heightAnchor.constraint(equalToConstant: self.subView.frame.height/2),
            stackView.centerXAnchor.constraint(equalTo: self.subView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.subView.centerYAnchor),
            
            ])
        
        // register collection cells
        collectionView.register(
            ProgrammaticCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: ProgrammaticCollectionViewCell.self)
        )
        
        // configure layout
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: subView.bounds.width * cellPercentWidth,
            height:self.subView.frame.height/2
        )
        centeredCollectionViewFlowLayout.minimumLineSpacing = 20
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        // realm 데이터 정렬 ascending 오름차순 정렬 (dday가 적게 남은 순으로 정렬한다.)
        
        countryRealmDB = realm?.objects(countryRealm.self)
        countryRealmDB = countryRealmDB?.sorted(byKeyPath: "date", ascending: true)
    }
}

extension mainVC: ControlCenterViewDelegate {
    func stateChanged(scrollDirection: UICollectionView.ScrollDirection) {
        centeredCollectionViewFlowLayout.scrollDirection = scrollDirection
    }
    
    func stateChanged(scrollToEdgeEnabled: Bool) {
        self.scrollToEdgeEnabled = scrollToEdgeEnabled
        
    }
}

extension mainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as? ProgrammaticCollectionViewCell
        UIView.animate(withDuration: 0.3) {
            if (cell != nil) {
                cell!.contentView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
        notification.notificationOccurred(.success)
        let nav1 = UINavigationController()
        let detailView = addDetailViewController()
        nav1.viewControllers = [detailView]
        detailView.selectIndex = indexPath.row
        
        self.present(nav1, animated: true, completion: nil)
    }
    
}

extension mainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryRealmDB?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgrammaticCollectionViewCell.self), for: indexPath) as! ProgrammaticCollectionViewCell
        
        cell.configure(withDelegate: mainVC_CVC_ViewModel(countryRealmDB![indexPath.row]))
        cell.contentView.transform = .identity
        // random color 를 cell의 background
        myBackgroundColor = HSBrandomColor()
        cell.contentView.backgroundColor = myBackgroundColor
        
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Current centered index1: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Current centered index2: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
    }
    // hsb random color
    func HSBrandomColor() -> UIColor{
        let saturation : CGFloat =  0.45
        let brigtness : CGFloat = 0.85
        let randomHue = CGFloat.random(in: 0.0..<1.0)
        //        print(UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1))
        return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
    }
}
