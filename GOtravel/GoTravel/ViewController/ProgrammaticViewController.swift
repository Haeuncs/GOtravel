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

class ProgrammaticViewController: UIViewController {
    @IBOutlet weak var subView: UIView!
    
	let centeredCollectionViewFlowLayout = CenteredCollectionViewFlowLayout()
    var collectionView: UICollectionView!

	let controlCenter = ControlCenterView()
	let cellPercentWidth: CGFloat = 0.8
	var scrollToEdgeEnabled = false

    let realm = try? Realm()
    // 기본 저장 데이터
    var countryRealmDB : Results<countryRealm>?
    
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationItem.title = "일정"
        title = self.navigationItem.title
        
        collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
        // Just to make the example pretty ✨
        collectionView.backgroundColor = UIColor.clear
        //        subView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        // delegate & data source
        controlCenter.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // layout subviews
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(collectionView)
        //        stackView.addArrangedSubview(controlCenter)
        subView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            //            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            stackView.widthAnchor.constraint(equalToConstant: self.subView.frame.width),
            stackView.heightAnchor.constraint(equalToConstant: self.subView.frame.height/2),
            stackView.centerXAnchor.constraint(equalTo: self.subView.centerXAnchor),
            //            stackView.topAnchor.constraint(equalTo: self.subView.topAnchor, constant: 10)
            stackView.centerYAnchor.constraint(equalTo: self.subView.centerYAnchor),
            
            ])
        //        stackView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
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
        print(countryRealmDB?.count)
        //        self.collectionView.reloadData()

    }
}

extension ProgrammaticViewController: ControlCenterViewDelegate {
    func stateChanged(scrollDirection: UICollectionView.ScrollDirection) {
		centeredCollectionViewFlowLayout.scrollDirection = scrollDirection
	}

	func stateChanged(scrollToEdgeEnabled: Bool) {
		self.scrollToEdgeEnabled = scrollToEdgeEnabled
        
	}
}

extension ProgrammaticViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Selected Cell #\(indexPath.row)")
//        if scrollToEdgeEnabled,
//            let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage,
//            currentCenteredPage != indexPath.row {
//            centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
//        }
	}
    
}

extension ProgrammaticViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return countryRealmDB?.count ?? 0
	}
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ProgrammaticCollectionViewCell
        UIView.animate(withDuration: 0.3) {
            if (cell != nil) {
                cell!.contentView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
        let nav1 = UINavigationController()
        let detailView = addDetailViewController()
        nav1.viewControllers = [detailView]
        detailView.selectCellColor = cell?.contentView.backgroundColor
        self.present(nav1, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.5) {
//            if let cell = collectionView.cellForItem(at: indexPath) as? ProgrammaticCollectionViewCell {
//                cell.contentView.transform = .identity
//            }
//        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgrammaticCollectionViewCell.self), for: indexPath) as! ProgrammaticCollectionViewCell
//        cell.titleLabel.text = "Cell #\(indexPath.row)"
        cell.countryLabel.text = countryRealmDB?[indexPath.row].country
        cell.cityLabel.text = countryRealmDB?[indexPath.row].city
        let inervalToday = countryRealmDB?[indexPath.row].date!.timeIntervalSince(Date())
        var dday = Int(inervalToday! / 86400)
        if dday >= 0{
            cell.ddayLabel.text = "D-\(dday)"
        }else{
            dday = dday * -1
            cell.ddayLabel.text = "+\(dday)일"
        }
        // random color 를 cell의 background
        cell.contentView.backgroundColor = HSBrandomColor()
		return cell
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
	}

	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
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
