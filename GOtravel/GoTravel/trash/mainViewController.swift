////
////  mainViewController.swift
////  GOtravel
////
////  Created by OOPSLA on 10/01/2019.
////  Copyright © 2019 haeun. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class mainViewController : UIViewController{
//
//    override func viewDidLoad() {
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        var test = mymain(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height:view.frame.height/3))
//        test.layer.cornerRadius=25
//        view.addSubview(test.contentView)
//
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.tabBarController?.tabBar.isHidden = false
//        //        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        
//        self.navigationItem.title = "일정"
//        
//        if let navVCsCount = navigationController?.viewControllers.count, navVCsCount > 2 {
//            navigationController?.viewControllers.removeSubrange(Range(2..<navVCsCount - 1))
//        }
//
//    }
//
//    @IBAction func plusNavBtn(_ sender: Any) {
//        let uiAlertControl = UIAlertController(title: "일정 추가하기", message: "도시를 검색하거나 직접 입력하여 기록합니다.", preferredStyle: .actionSheet)
//        uiAlertControl.addAction(UIAlertAction(title: "도시 검색하기", style: .default, handler: { (_) in
//            let uvc = self.storyboard!.instantiateViewController(withIdentifier: "searchTravelLocationViewController")
////            self.present(uvc, animated: true, completion: nil)
////
//            self.navigationController?.pushViewController(uvc, animated: true)
//        })
//        )
//        
//        uiAlertControl.addAction(UIAlertAction(title: "직접 입력하기", style: .default, handler: { (_) in
//        })
//        )
//        
//        // 아이패드에서도 작동하기 위해서 사용 popoverController
//        uiAlertControl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        if let popoverController = uiAlertControl.popoverPresentationController {
//            popoverController.barButtonItem = sender as? UIBarButtonItem
//        }
//        
//        self.present(uiAlertControl, animated: true, completion: nil)
//
//    }
//}
//
//extension mainViewController : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//    }
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: collectionView.bounds.size.width - 16, height: 120)
//    }
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
//    }
//
//}
