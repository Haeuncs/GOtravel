//
//  calendarViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 14/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation

import UIKit

enum MyTheme {
    case light
    case dark
}

class calendarViewController: UIViewController {
    
    var theme = MyTheme.dark
    
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
        automaticallyAdjustsScrollViewInsets = false
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
    }
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
