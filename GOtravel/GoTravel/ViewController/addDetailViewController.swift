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

class addDetailViewController: UIViewController,protocolTest {
    
    let realm = try! Realm()
    
    
    // push 로 데이터 전달됨
    var countryRealmDB = countryRealm()
    var selectIndex = 0
    // 진동 feedback
    let impact = UIImpactFeedbackGenerator()
    
    // scroll 시작 시, 열려있는 버튼이 있을 때 다시 닫을 때 사용
    var currentIndexPath : IndexPath?
    // 각 셀의 버튼은 테이블 당 한개만 나타날 수 있도록 하는 변수
    var beforeSelectIndexPath = false
    
    // 첫 메인 페이지에서 선택한 cell 컬러가 여러 곳에서 쓰임
    var selectCellColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for sub in scheduleMainTableView.subviews{
            sub.removeFromSuperview()
        }
        countryRealmDB = realm.objects(countryRealm.self).sorted(byKeyPath: "date", ascending: true)[selectIndex]

        print("\(countryRealmDB), here")
        mainView.countryLabel.text = countryRealmDB.country
        mainView.subLabel.text = countryRealmDB.city
        let dateFormatter = DateFormatter()

        let DBDate = Calendar.current.date(byAdding: .day, value: countryRealmDB.period, to: countryRealmDB.date!)
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let startDay = dateFormatter.string(from: countryRealmDB.date!)
        let endDay = dateFormatter.string(from: DBDate!)
        
        
        mainView.dateLabel.text = "\(startDay) ~ \(endDay)"+"    "+"\(countryRealmDB.period - 1)박 \(countryRealmDB.period)일"
        scheduleMainTableView.reloadData()
        //        self.scheduleMainTableView.reloadData()
    }
    func initView(){
        
        // 뷰 겹치는거 방지
        self.navigationController!.navigationBar.isTranslucent = false
        // 아래 그림자 생기는거 지우기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        self.scheduleMainTableView.backgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        let leftButton = UIBarButtonItem(title: "일정", style: .plain, target: self, action: #selector(self.dismissEvent))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(self.dismissEvent))
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        scheduleMainTableView.register(addDetailTableViewCell.self, forCellReuseIdentifier: "cell")
        
        scheduleMainTableView.dataSource = self
        scheduleMainTableView.delegate = self
        
        view.backgroundColor = .white
        
        view.addSubview(mainView)
        view.addSubview(scheduleMainTableView)
        
        // constraint
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scheduleMainTableView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            scheduleMainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleMainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleMainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
    }
    @objc func dismissEvent() {
        dismiss(animated: true, completion: nil)
    }
    
    // title을 갖는 뷰
    lazy var mainView: addDetailView = {
        let view = addDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
    }()
    
    var scheduleMainTableView : UITableView = {
        let tableView = UITableView()
        tableView.tag = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
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
        placeVC.myBackgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        placeVC.countryRealmDB = countryRealmDB
        placeVC.dayRealmDB = countryRealmDB.dayList[indexPath.row]
        self.navigationController?.pushViewController(placeVC, animated: true)
    }
    // 버튼의 animate 정의
    func buttonEvent(indexPath : IndexPath){
        
        // 이전 select가 없다면 실행
        let currentCell = scheduleMainTableView.cellForRow(at: indexPath)! as? addDetailTableViewCell

        //        sender.backgroundColor = .red
        // duration 작을 수록 느리게 애니메이션
        UIView.animate(withDuration: 0.5, animations: {
            if currentCell?.buttonSelect == false {
                let transformScaled = CGAffineTransform
                    .identity
                    .scaledBy(x: 0.8, y: 0.8)
                
                let moveMoney = CGAffineTransform(translationX: -50, y: 0)
                let movedetail = CGAffineTransform(translationX: 50, y: 0)
                currentCell?.paddingViewBottom.addBtn.transform = transformScaled
                currentCell?.paddingViewBottom.moneyBtn.transform = moveMoney
                currentCell?.paddingViewBottom.detailBtn.transform = movedetail
                currentCell?.paddingViewBottom.moneyBtn.alpha = 1
                currentCell?.paddingViewBottom.detailBtn.alpha = 1
                currentCell?.buttonSelect = true
                currentCell?.paddingViewBottom.addBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                // 이전 select가 있다면 원래 상태로 복귀
                // beforeCell 이 currentCell 과 같지 않을 때 복귀
                print(self.beforeSelectIndexPath)
                if self.beforeSelectIndexPath {
                    let beforeCell = self.scheduleMainTableView.cellForRow(at: self.currentIndexPath!)! as? addDetailTableViewCell
                    print("\(self.currentIndexPath!.row), \(indexPath.row)")
                    if beforeCell != currentCell
                    {
                        print("currentIndexPath != nil 복귀 애니메이션 실행 \(indexPath.row)")
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            
                            let transformScaled = CGAffineTransform
                                .identity
                                .scaledBy(x: 1.0, y: 1.0)
                            
                            let moveMoney = CGAffineTransform(translationX: 0, y: 0)
                            let movedetail = CGAffineTransform(translationX: 0, y: 0)
                            beforeCell?.paddingViewBottom.addBtn.transform = transformScaled
                            beforeCell?.paddingViewBottom.moneyBtn.transform = moveMoney
                            beforeCell?.paddingViewBottom.detailBtn.transform = movedetail
                            beforeCell?.paddingViewBottom.moneyBtn.alpha = 0.0
                            beforeCell?.paddingViewBottom.detailBtn.alpha = 0.0
                            beforeCell?.buttonSelect = false
                            beforeCell?.paddingViewBottom.addBtn.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                            // 다시 초기화
                            self.currentIndexPath = nil
                        })
                    }

                }
                self.beforeSelectIndexPath = true
                self.currentIndexPath = indexPath
                print("currentIndexPath = indexPath select 애니메이션 실행 \(indexPath.row) )")
            }else{
                let transformScaled = CGAffineTransform
                    .identity
                    .scaledBy(x: 1.0, y: 1.0)
                
                let moveMoney = CGAffineTransform(translationX: 0, y: 0)
                let movedetail = CGAffineTransform(translationX: 0, y: 0)
                currentCell?.paddingViewBottom.addBtn.transform = transformScaled
                currentCell?.paddingViewBottom.moneyBtn.transform = moveMoney
                currentCell?.paddingViewBottom.detailBtn.transform = movedetail
                currentCell?.paddingViewBottom.moneyBtn.alpha = 0.0
                currentCell?.paddingViewBottom.detailBtn.alpha = 0.0
                currentCell?.buttonSelect = false
                currentCell?.paddingViewBottom.addBtn.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                self.beforeSelectIndexPath = false
                self.currentIndexPath = nil
                print("currentIndexPath = nil deselect 애니메이션 실행 \(indexPath.row)")

            }
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.5, animations: {
                    let transformScaled = CGAffineTransform
                        .identity
                        .scaledBy(x: 1.0, y: 1.0)
                    
                    //                    sender.transform = transformScaled
                })
            }
            
        }
    }
    func callAction(with data : String){
        print("pushing view")
        print(data)
//        let view = googleMapViewController()
//        self.navigationController?.pushViewController(view, animated: true)
    }
    func userIsDone(str:String){
        print("test")
        print(str)
    }
}
protocol protocolTest : class{
    func userIsDone(str : String)
}

extension addDetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        // 지금은 select 이벤트 없음
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowCount = countryRealmDB.dayList[indexPath.row].detailList.count
        if rowCount == 0 {
            return 180
        }
        else{
            return CGFloat(80 * rowCount + (sizeConstant.paddingSize))
        }
    }
}
var publicdayCount = 0
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
        print(countryRealmDB.dayList[indexPath.row].day - 1)
        let DBDate = Calendar.current.date(byAdding: .day, value: countryRealmDB.dayList[indexPath.row].day - 1, to: countryRealmDB.date!)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("e")
        let day = dateFormatter.string(from: DBDate ?? Date())
        cell.dateView.dayOfTheWeek.text = day + "요일"
        cell.dateView.dateLabel.text = String(countryRealmDB.dayList[indexPath.row].day) + "일"
        cell.selectIndex = indexPath.row
        
        cell.count = countryRealmDB.dayList[indexPath.row].detailList.count
        print(countryRealmDB.dayList[indexPath.row].detailList.count)
        //        print(countryRealmDB.dayList[indexPath.row].detailList
        //        )
        publicdayCount = countryRealmDB.dayList.count
        cell.paddingViewBottom.addBtn.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        cell.paddingViewBottom.detailBtn.addTarget(self, action: #selector(self.placeButtonEvent(_:)), for: .touchUpInside)
        //        cell.dayOfTheWeek.text =
        return cell
    }
    
}
extension addDetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 버튼 animate 원상복구
        if currentIndexPath != nil{
            buttonEvent(indexPath: currentIndexPath!)
        }
    }
}
