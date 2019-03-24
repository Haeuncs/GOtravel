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


//FIXIT : 클릭하면 이동하는거 index row 기준 아니고 데이터 자체를 이동하기
class mainVC: UIViewController {
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
    
    @IBAction func settingBtn(_ sender: Any) {
        let setting = settingVC()
        self.navigationController?.pushViewController(setting, animated: true)
        
    }
    @IBAction func addBtn(_ sender: Any) {
        let placeVC = placeSearchViewController()
        placeVC.categoryIndex = 1
        self.navigationController?.pushViewController(placeVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        DispatchQueue.main.async {
            print("reload_Check")
            self.collectionView.reloadData()
            self.collectionView!.collectionViewLayout.invalidateLayout()
            self.collectionView!.layoutSubviews()

        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Defaull_style.mainTitleColor]
        self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
        self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
        
        self.navigationItem.title = "여행일정"
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
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            
            stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            stackView.heightAnchor.constraint(equalToConstant: self.view.frame.height/2),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            ])
        print("\(self.view.frame.height)")
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
                if endDate ?? Date() > Date() {
                    processedData.append(i)
                }
            }
        }
        print(processedData.count)
        return processedData
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

extension mainVC: UICollectionViewDataSource {
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
// hsb random color
func HSBrandomColor() -> UIColor{
    let saturation : CGFloat =  0.45
    let brigtness : CGFloat = 0.85
    let randomHue = CGFloat.random(in: 0.0..<1.0)
    //        print(UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1))
    return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
}
