//
//  addDetailView.swift
//  GOtravel
//
//  Created by OOPSLA on 15/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


public enum sizeConstant {
    public static let paddingSize = 50
}
//let paddingSize = 10
protocol changeDetailVCVDelegate : class {
    func inputData()->(title:String,startTime:Date,endTime:Date,color:String,memo:String)
}
protocol addDetailViewTableViewCellDelegate : class {
    func addDetailViewTableViewCellDidTapInTableView(_ sender: addDetailTableViewCell,detailIndex : Int)
    func tableViewDeleteEvent(_ sender: addDetailTableViewCell)
}



class addDetailViewController: UIViewController ,addDetailViewTableViewCellDelegate{
    
    // 테이블이 스크롤이 가능하게 할 것인가? -> 편집 클릭 시에 가능하도록! and 삭제 이동 기능도 사용
    var isEdit : Bool? = false
    let realm = try! Realm()
    // push 로 데이터 전달됨
    var countryRealmDB = countryRealm()
    var selectIndex = 0
    // 진동 feedbvar
    let impact = UIImpactFeedbackGenerator()
    
    // scroll 시작 시, 열려있는 버튼이 있을 때 다시 닫을 때 사용
    var currentIndexPath : IndexPath?
    // 각 셀의 버튼은 테이블 당 한개만 나타날 수 있도록 하는 변수
    var beforeSelectIndexPath = false
    
    // 첫 메인 페이지에서 선택한 cell 컬러가 여러 곳에서 쓰임
    var selectCellColor : UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        initView()
        scheduleMainTableView.reloadData()
        
    }
    
    func initView(){
        beforeSelectIndexPath = false
        isEdit = false
        
        // 뷰 겹치는거 방지
        self.navigationController!.navigationBar.isTranslucent = false
        // 아래 그림자 생기는거 지우기
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.barTintColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//        self.scheduleMainTableView.backgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        let leftButton = UIBarButtonItem(title: "일정", style: .plain, target: self, action: #selector(self.dismissEvent))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "편집", style: .done, target: self, action: #selector(self.editEvent))
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
        self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
        
        scheduleMainTableView.register(addDetailTableViewCell.self, forCellReuseIdentifier: "cell")
        
        scheduleMainTableView.dataSource = self
        scheduleMainTableView.delegate = self
        
        view.backgroundColor = .white
        
        view.addSubview(mainView)
        view.addSubview(scheduleMainTableView)
        
//        deleteAndSaveStack.addArrangedSubview(deleteBtnS)
//        deleteAndSaveStack.addArrangedSubview(addBtnS)

        let customView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        customView.alignment = .center
        customView.distribution = .fill
//        customView.backgroundColor = UIColor.red
        customView.addArrangedSubview(deleteDataLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addDetailViewController.alldDleteLabelEvent))
        deleteDataLabel.isUserInteractionEnabled = true
        deleteDataLabel.addGestureRecognizer(tap)

        scheduleMainTableView.tableFooterView = customView
        
        
//        view.addSubview(deleteAndSaveStack)
        
        initLayout()
        getRealmData()
    }
    
    @objc func alldDleteLabelEvent(sender:UITapGestureRecognizer) {
        let uiAlertControl = UIAlertController(title: "여행 데이터 삭제", message: "한번 삭제한 데이터는 복구 할 수 없습니다. 삭제하시겠습니까? ", preferredStyle: .actionSheet)
        
        
//        uiAlertControl.addAction(UIAlertAction(title: "도서 검색 하기", style: .default, handler: { (_) in
//            let uvc = self.storyboard!.instantiateViewController(withIdentifier: "book_search")
//            
//            self.navigationController?.pushViewController(uvc, animated: true)
//        })
//        )
//        
//        uiAlertControl.addAction(UIAlertAction(title: "직접 입력 하기", style: .default, handler: { (_) in
//            let uvc = self.storyboard!.instantiateViewController(withIdentifier: "ReadingRecord_add_Data")
//            
//            self.navigationController?.pushViewController(uvc, animated: true)
//        })
//        )
        
        uiAlertControl.addAction(UIAlertAction(title: "삭제", style: .default, handler: { (_) in
            try! self.realm.write {
                self.realm.delete(self.countryRealmDB)
            }
            self.dismiss(animated: true, completion: nil)
        })
        )
        // 아이패드에서도 작동하기 위해서 사용 popoverController
        uiAlertControl.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        if let popoverController = uiAlertControl.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        
        self.present(uiAlertControl, animated: true, completion: nil)

    }

    func initLayout(){
        // constraint
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scheduleMainTableView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            scheduleMainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleMainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleMainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            deleteAndSaveStack.widthAnchor.constraint(equalToConstant: view.frame.width)
//            deleteDataLabel.widthAnchor.constraint(equalToConstant: view.frame.width)
            deleteDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

    }
    func getRealmData(){
        countryRealmDB = realm.objects(countryRealm.self).sorted(byKeyPath: "date", ascending: true)[selectIndex]
        
        mainView.countryLabel.text = countryRealmDB.country
        mainView.subLabel.text = countryRealmDB.city
        
        let dateFormatter = DateFormatter()
        let DBDate = Calendar.current.date(byAdding: .day, value: countryRealmDB.period, to: countryRealmDB.date!)
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let startDay = dateFormatter.string(from: countryRealmDB.date!)
        let endDay = dateFormatter.string(from: DBDate!)
        
        
        mainView.dateLabel.text = "\(startDay) ~ \(endDay)"+"    "+"\(countryRealmDB.period - 1)박 \(countryRealmDB.period)일"
//        scheduleMainTableView.reloadData()
    }
    // MARK: 버튼 이벤트
    @objc func editEvent(){
        isEdit = !isEdit!
        scheduleMainTableView.reloadData()
        if self.navigationItem.rightBarButtonItem?.title == "편집"{
            self.navigationItem.rightBarButtonItem?.title = "완료"
        }else{
            self.navigationItem.rightBarButtonItem?.title = "편집"
        }
    }
    @objc func dismissEvent() {
        dismiss(animated: true, completion: nil)
    //        scheduleMainTableView.isEditing = !scheduleMainTableView.isEditing
    }
    @objc func btnAction(_ sender: UIButton) {
        // 피드백 진동
        impact.impactOccurred()
        // 선택한 cell의 indexPath
        let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
        let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
        
        buttonEvent(indexPath: indexPath)
    }
    @objc func placeButtonEvent(_ sender : UIButton){
        impact.impactOccurred()
        let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
        let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
        let placeVC = placeSearchViewController()
//        placeVC.myBackgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        placeVC.countryRealmDB = countryRealmDB
        placeVC.dayRealmDB = countryRealmDB.dayList[indexPath.row]
        placeVC.categoryIndex = 0
        self.navigationController?.pushViewController(placeVC, animated: true)
    }
    @objc func pathButtonEvent(_ sender : UIButton){
        impact.impactOccurred()
//        self.scheduleMainTableView.reloadData()
        let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
        let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
        let googleVC = googleMapViewController()
        if countryRealmDB.dayList[indexPath.row].detailList.first != nil{
            googleVC.navTitle = countryRealmDB.city
            googleVC.arrayMap = true
            googleVC.currentSelect = countryRealmDB.dayList[indexPath.row].detailList.first!
            googleVC.dayDetailRealm = countryRealmDB.dayList[indexPath.row].detailList
            googleVC.dayRealmDB = countryRealmDB.dayList[indexPath.row]
            self.navigationController?.pushViewController(googleVC, animated: true)

        }
        
//
//        let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
//        let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
//        let placeVC = googleMapViewController()
//
//        self.navigationController?.pushViewController(placeVC, animated: true)
    }
    @objc func exchangeButtonEvent(_ sender : UIButton){
        impact.impactOccurred()
        let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
        let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)

        let exchangeVC = exchangeViewController()
        exchangeVC.countryRealmDB = self.countryRealmDB
        // 여행 전 경비가 있음으로 + 1
        exchangeVC.selectDay = indexPath.row + 1
        self.navigationController?.pushViewController(exchangeVC, animated: true)
    }
    

    func callAction(with data : String){
        print("pushing view")
        print(data)
//        let view = googleMapViewController()
//        self.navigationController?.pushViewController(view, animated: true)
    }
    var sum = 0
    // delete label footer view
    let deleteDataLabel : UILabel = {
        let label = UILabel()
        label.text = "이 여행 데이터 전체 삭제"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = #colorLiteral(red: 0.802965343, green: 0.08342111856, blue: 0, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    
    // MARK: VC에서 View 그릴 떄 사용하는 것들
    let deleteBtnS : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.myRed
        button.setTitle("삭제", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints=false
        return button
    }()
    let addBtnS : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.myBlue
        button.setTitle("확인", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints=false
        return button
    }()
    let deleteAndSaveStack : UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.isHidden = false
        stack.translatesAutoresizingMaskIntoConstraints=false
        return stack
    }()
    // title을 갖는 뷰
    // 여행지랑 몇박 몇일인지 등등
    lazy var mainView: addDetailView = {
        let view = addDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
    }()
    // 날짜별 테이블뷰
    var scheduleMainTableView : UITableView = {
        let tableView = UITableView()
        tableView.tag = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = Defaull_style.subTitleColor
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tableView.allowsSelection = false
        return tableView
    }()
    func openViewEvent(currentCell : addDetailTableViewCell){
        // duration 작을 수록 느리게 애니메이션

        UIView.animate(withDuration: 0.5, animations: {
            let transformScaled = CGAffineTransform
                .identity
                .scaledBy(x: 0.8, y: 0.8)
            
            let moveMoney = CGAffineTransform(translationX: -50, y: 0)
            let movedetail = CGAffineTransform(translationX: 50, y: 0)
            let movePath = CGAffineTransform(translationX: 100, y: 0)
            
            currentCell.paddingViewBottom.addBtn.transform = transformScaled
            currentCell.paddingViewBottom.moneyBtn.transform = moveMoney
            currentCell.paddingViewBottom.detailBtn.transform = movedetail
            currentCell.paddingViewBottom.pathBtn.transform = movePath
            currentCell.paddingViewBottom.moneyBtn.alpha = 1
            currentCell.paddingViewBottom.detailBtn.alpha = 1
            currentCell.paddingViewBottom.pathBtn.alpha = 1
            
            
            
        })
    }
    func colseViewEvent(beforeCell : addDetailTableViewCell){
        // duration 작을 수록 느리게 애니메이션

        UIView.animate(withDuration: 0.5, animations: {
            
            let transformScaled = CGAffineTransform
                .identity
                .scaledBy(x: 1.0, y: 1.0)
            
            let moveMoney = CGAffineTransform(translationX: 0, y: 0)
            let movedetail = CGAffineTransform(translationX: 0, y: 0)
            let movePath = CGAffineTransform(translationX: 0, y: 0)
            beforeCell.paddingViewBottom.addBtn.transform = transformScaled
            beforeCell.paddingViewBottom.moneyBtn.transform = moveMoney
            beforeCell.paddingViewBottom.detailBtn.transform = movedetail
            beforeCell.paddingViewBottom.pathBtn.transform = movePath
            beforeCell.paddingViewBottom.moneyBtn.alpha = 0.0
            beforeCell.paddingViewBottom.detailBtn.alpha = 0.0
            beforeCell.paddingViewBottom.pathBtn.alpha = 0.0
        })

    }
    // MARK: 버튼의 animate 정의
    func buttonEvent(indexPath : IndexPath){
        let currentCell = scheduleMainTableView.cellForRow(at: indexPath)! as? addDetailTableViewCell
        // 머니 버튼이 가려져 있다면 보이기
        if currentCell?.paddingViewBottom.moneyBtn.alpha == 0.0 {
            openViewEvent(currentCell: currentCell!)
        }else{
            colseViewEvent(beforeCell: currentCell!)
        }

    }
        // 현재 선택된 cell
        
//        // 이전 select가 없다면 실행
//        let currentCell = scheduleMainTableView.cellForRow(at: indexPath)! as? addDetailTableViewCell
//
//        //        sender.backgroundColor = .red
//        UIView.animate(withDuration: 0.5, animations: {
//            if currentCell?.buttonSelect == false {
//                let transformScaled = CGAffineTransform
//                    .identity
//                    .scaledBy(x: 0.8, y: 0.8)
//
//                let moveMoney = CGAffineTransform(translationX: -50, y: 0)
//                let movedetail = CGAffineTransform(translationX: 50, y: 0)
//                let movePath = CGAffineTransform(translationX: 100, y: 0)
//
//
//                currentCell?.paddingViewBottom.addBtn.transform = transformScaled
//                currentCell?.paddingViewBottom.moneyBtn.transform = moveMoney
//                currentCell?.paddingViewBottom.detailBtn.transform = movedetail
//                currentCell?.paddingViewBottom.pathBtn.transform = movePath
//                currentCell?.paddingViewBottom.moneyBtn.alpha = 1
//                currentCell?.paddingViewBottom.detailBtn.alpha = 1
//                currentCell?.paddingViewBottom.pathBtn.alpha = 1
//                currentCell?.buttonSelect = true
//
//                // 이전 select가 있다면 원래 상태로 복귀
//                // beforeCell 이 currentCell 과 같지 않을 때 복귀
//
//                if self.beforeSelectIndexPath == true {
//                    let beforeCell = self.scheduleMainTableView.cellForRow(at: (self.currentIndexPath ?? indexPath)!)! as? addDetailTableViewCell
////                    print("\(self.currentIndexPath!.row), \(indexPath.row)")
//                    if beforeCell != currentCell
//                    {
////                        print("currentIndexPath != nil 복귀 애니메이션 실행 \(indexPath.row)")
//
//                        UIView.animate(withDuration: 0.5, animations: {
//
//                            let transformScaled = CGAffineTransform
//                                .identity
//                                .scaledBy(x: 1.0, y: 1.0)
//
//                            let moveMoney = CGAffineTransform(translationX: 0, y: 0)
//                            let movedetail = CGAffineTransform(translationX: 0, y: 0)
//                            let movePath = CGAffineTransform(translationX: 0, y: 0)
//                            beforeCell?.paddingViewBottom.addBtn.transform = transformScaled
//                            beforeCell?.paddingViewBottom.moneyBtn.transform = moveMoney
//                            beforeCell?.paddingViewBottom.detailBtn.transform = movedetail
//                            beforeCell?.paddingViewBottom.pathBtn.transform = movePath
//                            beforeCell?.paddingViewBottom.moneyBtn.alpha = 0.0
//                            beforeCell?.paddingViewBottom.detailBtn.alpha = 0.0
//                            beforeCell?.paddingViewBottom.pathBtn.alpha = 0.0
//                            beforeCell?.buttonSelect = false
//                            beforeCell?.paddingViewBottom.addBtn.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//                            // 다시 초기화
//                            self.currentIndexPath = nil
//                            self.beforeSelectIndexPath = false
//                        })
//                    }
//
//                }
//                self.beforeSelectIndexPath = true
//                self.currentIndexPath = indexPath
////                print("currentIndexPath = indexPath select 애니메이션 실행 \(indexPath.row) )")
//            }else{
//                let transformScaled = CGAffineTransform
//                    .identity
//                    .scaledBy(x: 1.0, y: 1.0)
//
//                let moveMoney = CGAffineTransform(translationX: 0, y: 0)
//                let movedetail = CGAffineTransform(translationX: 0, y: 0)
//                let movePath = CGAffineTransform(translationX: 0, y: 0)
//                currentCell?.paddingViewBottom.addBtn.transform = transformScaled
//                currentCell?.paddingViewBottom.moneyBtn.transform = moveMoney
//                currentCell?.paddingViewBottom.detailBtn.transform = movedetail
//                currentCell?.paddingViewBottom.pathBtn.transform = movePath
//                currentCell?.paddingViewBottom.moneyBtn.alpha = 0.0
//                currentCell?.paddingViewBottom.detailBtn.alpha = 0.0
//                currentCell?.paddingViewBottom.pathBtn.alpha = 0.0
//                currentCell?.buttonSelect = false
//                currentCell?.paddingViewBottom.addBtn.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//                self.beforeSelectIndexPath = false
//                self.currentIndexPath = nil
////                print("currentIndexPath = nil deselect 애니메이션 실행 \(indexPath.row)")
//
//            }
//        }) { (finished) in
//            if finished {
//                UIView.animate(withDuration: 0.5, animations: {
//                    _ = CGAffineTransform
//                        .identity
//                        .scaledBy(x: 1.0, y: 1.0)
//
//                    //                    sender.transform = transformScaled
//                })
//            }
//
//        }
//    }
//

}
// MARK: delegate 정의 (cell 에서 사용한다.)
extension addDetailViewController {
    // The cell calls this method when the user taps the heart button
    func addDetailViewTableViewCellDidTapInTableView(_ sender: addDetailTableViewCell, detailIndex : Int) {
        guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
        print("Heart", sender, detailIndex)
//        print(detailIndex)
//        dismiss(animated: true, completion: nil)
        let changeVC = changeDetailOfViewContoller()
        changeVC.detailRealmDB = countryRealmDB.dayList[tappedIndexPath.row].detailList[detailIndex]
        changeVC.countryRealmDB = countryRealmDB
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
    func tableViewDeleteEvent(_ sender: addDetailTableViewCell) {
        guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
        print("tab", sender, tappedIndexPath)
        self.scheduleMainTableView.reloadData()
    }


}

extension addDetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        // 지금은 select 이벤트 없음
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowCount = countryRealmDB.dayList[indexPath.row].detailList.count
        if rowCount == 0 {
            return CGFloat(80 * 1 + (sizeConstant.paddingSize))
        }
        else{
            return CGFloat(80 * rowCount + (sizeConstant.paddingSize))
        }
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        print("\(section) 섹션")
//        guard section == 0 else { return nil }
//
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0))
//        footerView.addSubview(deleteAndSaveStack)
//        NSLayoutConstraint.activate([
//            deleteAndSaveStack.topAnchor.constraint(equalTo: footerView.topAnchor),
//            deleteAndSaveStack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
//            deleteAndSaveStack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
//            deleteAndSaveStack.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
//            ])
//        return footerView
//    }

}
extension addDetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryRealmDB.dayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCell

        cell.dayRealmDB = countryRealmDB.dayList[indexPath.row]
        cell.initView()
        
        //            cell.contentView.setCardView(view: cell.contentView)
        cell.detailScheduleTableView.tag = indexPath.row
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
//        print(countryRealmDB.dayList[indexPath.row].day - 1)
        let DBDate = Calendar.current.date(byAdding: .day, value: countryRealmDB.dayList[indexPath.row].day - 1, to: countryRealmDB.date!)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("e")
        let day = dateFormatter.string(from: DBDate ?? Date())
        cell.dateView.dayOfTheWeek.text = day + "요일"
        cell.dateView.dateLabel.text = String(countryRealmDB.dayList[indexPath.row].day) + "일"
        cell.count = countryRealmDB.dayList[indexPath.row].detailList.count
//        print(countryRealmDB.dayList[indexPath.row].detailList.count)
        //        print(countryRealmDB.dayList[indexPath.row].detailList
        //        )
        cell.paddingViewBottom.addBtn.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        cell.paddingViewBottom.detailBtn.addTarget(self, action: #selector(self.placeButtonEvent(_:)), for: .touchUpInside)
        cell.paddingViewBottom.pathBtn.addTarget(self, action: #selector(self.pathButtonEvent(_:)), for: .touchUpInside)
        cell.paddingViewBottom.moneyBtn.addTarget(self, action: #selector(self.exchangeButtonEvent(_:)), for: .touchUpInside)
        
        let transformScaled = CGAffineTransform
            .identity
            .scaledBy(x: 1.0, y: 1.0)
        
        let moveMoney = CGAffineTransform(translationX: 0, y: 0)
        let movedetail = CGAffineTransform(translationX: 0, y: 0)
        let movePath = CGAffineTransform(translationX: 0, y: 0)
        cell.paddingViewBottom.addBtn.transform = transformScaled
        cell.paddingViewBottom.moneyBtn.transform = moveMoney
        cell.paddingViewBottom.detailBtn.transform = movedetail
        cell.paddingViewBottom.pathBtn.transform = movePath
        cell.paddingViewBottom.moneyBtn.alpha = 0.0
        cell.paddingViewBottom.detailBtn.alpha = 0.0
        cell.paddingViewBottom.pathBtn.alpha = 0.0

        //        cell.dayOfTheWeek.text =
        
        cell.mydelegate = self
        cell.isEdit = isEdit!
        

        return cell
    }
    
}
extension addDetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 버튼 animate 원상복구
//        if currentIndexPath != nil{
//            buttonEvent(indexPath: currentIndexPath!)
//        }
    }
}

