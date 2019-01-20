//
//  changeDetailOfDayViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 20/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

// detailVC 에서 cell 선택 시 이동하는 수정 뷰
class changeDetailOfViewContoller : UIViewController {

    override func viewDidLoad() {

    }
    override func viewWillAppear(_ animated: Bool) {
        initView()
    }

    func initView(){
        self.view.addSubview(mainView)
        view.backgroundColor = .white
        initLayoutConstraint()
    }
    func initLayoutConstraint(){

        let mainViewPadding = CGFloat(10)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: mainViewPadding),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -mainViewPadding),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: mainViewPadding),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -mainViewPadding),
            ])
    }
    let mainView : UIView = {
        let view = changeDetailView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 1
        view.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
