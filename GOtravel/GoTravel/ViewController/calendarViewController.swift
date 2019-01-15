//
//  calendarViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 14/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import RealmSwift

import UIKit
import MapKit

enum MyTheme {
    case light
    case dark
}
var ddayDB = 0
var nightDB = 0
var dayDate = Date()

class calendarViewController: UIViewController {
    
    let realm = try! Realm()

    var mapItem: MKMapItem?
    var saveCountryRealmData = countryRealm()
    var region: MKCoordinateRegion?
    
    var theme = MyTheme.dark
    var cityName = ""
//    let eventC = event()
//    @IBAction func plusBtn(_ sender: Any) {
//        eventC.sideMenu(selfV: self)
//    }
//    @IBAction func sideBtn(_ sender: Any) {
//        panel?.openLeft(animated: true)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "여행 기간 설정 🗓"
        initializeView()
    }
    func saveRealmData(){
        // realm location print
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        saveCountryRealmData.country = (mapItem?.placemark.country!)!
        saveCountryRealmData.city = mapItem?.placemark.locality ?? mapItem?.placemark.administrativeArea ?? ""
        saveCountryRealmData.date = dayDate
        saveCountryRealmData.period = nightDB
        saveCountryRealmData.longitude = (region?.center.longitude)!
        saveCountryRealmData.latitude = (region?.center.latitude)!        
        try! realm.write {
            realm.add(saveCountryRealmData)
        }

    }
    func initializeView(){
        
        self.navigationController?.navigationBar.isTranslucent=false
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.view.backgroundColor=Style.bgColor
        let availableWidth = view.frame.width - 7 - 10
        let widthPerItem = availableWidth / 7

        view.addSubview(calenderView)
        //        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive=true
        //        calenderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 12).isActive=true
        calenderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        calenderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 70 + (widthPerItem * 6)).isActive=true
        
        view.addSubview(addBtn)
        addBtn.topAnchor.constraint(equalTo: calenderView.bottomAnchor,constant: 20).isActive=true
        //        ddayLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-5).isActive = true
        addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
        addBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive=true
        addBtn.heightAnchor.constraint(equalToConstant: 50).isActive=true
        

    }
    @objc func buttonClicked(){
        print("select")
        saveRealmData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    let addBtn : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints=false
        b.layer.cornerRadius = 5
                b.puls()
        b.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        b.isHidden = false
        b.setTitle("일정 추가하기", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.tag = 0
        b.isSelected = true
        b.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return b
    }()

    let ddayLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    let calenderView: CalenderView = {
        let v=CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
}
