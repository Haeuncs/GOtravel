////
////  pastV.swift
////  GOtravel
////
////  Created by OOPSLA on 02/03/2019.
////  Copyright © 2019 haeun. All rights reserved.
////
//
//import Foundation
import UIKit
import CenteredCollectionView
import RealmSwift

class pastV : UIView , UICollectionViewDelegate , UICollectionViewDataSource{
    
    let realm = try? Realm()

    // 햅틱 진동
    let selection = UISelectionFeedbackGenerator()
    let notification = UINotificationFeedbackGenerator()

    // collectionView
    let centeredCollectionViewFlowLayout = CenteredCollectionViewFlowLayout()
    var collectionView: UICollectionView!
    
    let controlCenter = ControlCenterView()
    let cellPercentWidth: CGFloat = 0.8
    var scrollToEdgeEnabled = false

    var processedRealmDB = List<countryRealm>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print(self.frame)
        print(self.bounds)
        processedRealmDB = processingDateData()
        initView()
    }

    func initView(){

        collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self

        // layout subviews
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(collectionView)
        self.addSubview(stackView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: self.frame.width),
            stackView.heightAnchor.constraint(equalToConstant: self.frame.height/2),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            ])
        
        // register collection cells
        collectionView.register(
            ProgrammaticCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: ProgrammaticCollectionViewCell.self)
        )
        
        // configure layout
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: self.bounds.width * cellPercentWidth,
            height:self.bounds.height/2
        )
        centeredCollectionViewFlowLayout.minimumLineSpacing = 20
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false


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
        detailView.selectIndex = indexPath.row
        
//        self.present(nav1, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return processedRealmDB.count
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
        
        cell.configure(withDelegate: mainVC_CVC_ViewModel(processedRealmDB[indexPath.row]))
        cell.contentView.transform = .identity
        // random color 를 cell의 background
        cell.contentView.backgroundColor = HSBrandomColor()
        
        return cell
    }
    

}
