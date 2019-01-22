//
//  changeDetailOfDayViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 20/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// detailVC 에서 cell 선택 시 이동하는 수정 뷰
class changeDetailOfViewContoller : UIViewController {
    //detailVC에서 받는 데이터
    var detailRealmDB : detailRealm?
    var countryRealmDB : countryRealm?
    
    let realm = try! Realm()

    override func viewDidLoad() {

    }
    override func viewWillAppear(_ animated: Bool) {
        initView()
        if detailRealmDB != nil {
            let setData = mainView as? changeDetailView;
            setData?.titleTextInput.text = detailRealmDB?.title
            setData?.mainTitle.text = (countryRealmDB?.country)! + " " + (countryRealmDB?.city)! + " " + "여행"
        }
    }

    func initView(){
        self.view.addSubview(mainView)
        view.backgroundColor = .white
        
        let leftButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelBtn))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(self.saveBtn))
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.subTitleColor
        self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.subTitleColor

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

    @objc func cancelBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func saveBtn(){
        let setData = mainView as? changeDetailView;
        if setData?.colorPik == "" {
            setData?.colorPik = "default"
        }
        try! realm.write {
            detailRealmDB?.color = setData!.colorPik
            detailRealmDB?.title = setData!.titleTextInput.text!
            detailRealmDB?.startTime = setData!.startTime
            detailRealmDB?.EndTime = setData!.endTime
            detailRealmDB?.memo = setData!.memoTextInput.text!
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
//    // MARK: delegate 정의 (cell 에서 사용한다.)
//    extension addDetailViewController {
//        // The cell calls this method when the user taps the heart button
//        func swiftyTableViewCellDidTapHeart(_ sender: addDetailTableViewCell) {
//            guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
//            print("Heart", sender, tappedIndexPath)
//            //        dismiss(animated: true, completion: nil)
//            let changeVC = changeDetailOfViewContoller()
//            self.navigationController?.pushViewController(changeVC, animated: true)
//        }
//        func tableViewDeleteEvent(_ sender: addDetailTableViewCell) {
//            guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
//            print("Heart", sender, tappedIndexPath)
//            self.scheduleMainTableView.reloadData()
//        }
//
//
//    }
