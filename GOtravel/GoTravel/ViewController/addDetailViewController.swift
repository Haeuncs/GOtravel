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


//let paddingSize = 10

class addDetailViewController: UIViewController {
    
    var table_data = Array<TableData>()
    let impact = UIImpactFeedbackGenerator() // 1
    var currentIndexPath : IndexPath?
    var selectCellColor : UIColor?
    let arr = ["1일","2일","3일","4일"]
    let arr1 = ["인천공항","간사이 국제 공항","숙소","햅파이브"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    @objc func someFunc() {
        print("It Works")
        dismiss(animated: true, completion: nil)
    }

    func initView(){

        var new_elements:TableData
        
        new_elements = TableData()
        new_elements.section = "Section 1"
        new_elements.data.append("Element 1")
        new_elements.data.append("Element 2")
        new_elements.data.append("Element 3")
        new_elements.data.append("Element 4")
        new_elements.data.append("Element 5")
        
        table_data.append(new_elements)
        
        
        new_elements = TableData()
        new_elements.section = "Section 2"
        new_elements.data.append("Element 1")
        new_elements.data.append("Element 2")
        
        table_data.append(new_elements)
        
        new_elements = TableData()
        new_elements.section = "Section 3"
        new_elements.data.append("Element 1")
        new_elements.data.append("Element 2")
        new_elements.data.append("Element 3")
        new_elements.data.append("Element 4")
        new_elements.data.append("Element 5")
        new_elements.data.append("Element 6")
        new_elements.data.append("Element 7")
        
        table_data.append(new_elements)
        
        new_elements = TableData()
        new_elements.section = "Section 4"
        new_elements.data.append("Element 1")
        new_elements.data.append("Element 2")
        new_elements.data.append("Element 3")
        new_elements.data.append("Element 4")
        new_elements.data.append("Element 5")
        new_elements.data.append("Element 6")
        new_elements.data.append("Element 7")
        
        table_data.append(new_elements)

        // 뷰 겹치는거 방지
        self.navigationController!.navigationBar.isTranslucent = false
        // 아래 그림자 생기는거 지우기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        self.scheduleMainTableView.backgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        let leftButton = UIBarButtonItem(title: "일정", style: .plain, target: self, action: #selector(self.someFunc))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(self.someFunc))
        self.navigationItem.rightBarButtonItem = rightButton

        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)


        
        scheduleMainTableView.register(addDetailTableViewCell.self, forCellReuseIdentifier: "cell")

        scheduleMainTableView.dataSource = self
        scheduleMainTableView.delegate = self

        view.backgroundColor = .white
        mainView.addSubview(countryLabel)
        mainView.addSubview(subLabel)
        mainView.addSubview(dateLabel)
        
        view.addSubview(mainView)
        
//        scheduleView.addSubview(scheduleMainTableView)
//        dateView.addSubview(dateViewLabel)
        view.addSubview(scheduleMainTableView)
        // constraint
        
//        let scheduleViewHeight = NSLayoutConstraint(item: dateView, attribute: .width, relatedBy: .equal, toItem: scheduleView, attribute: .width, multiplier: 0.25, constant: 0.0)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            //            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,constant:5),
            countryLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            subLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor),
            subLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,constant:5),
            subLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,constant:5),
            dateLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            // data size에 맞추기 위한 앵커
            mainView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant:5),
            
            //            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor)
            scheduleMainTableView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            scheduleMainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleMainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleMainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
//            dateViewLabel.topAnchor.constraint(equalTo: dateView.topAnchor),
//            dateViewLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor),
//            dateViewLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor),
            //            dateViewLabel.bottomAnchor.constraint(equalTo: dateView.bottomAnchor),
            
//            scheduleMainTableView.topAnchor.constraint(equalTo: scheduleView.topAnchor),
//            scheduleMainTableView.leadingAnchor.constraint(equalTo: scheduleView.leadingAnchor),
//            scheduleMainTableView.trailingAnchor.constraint(equalTo: scheduleView.trailingAnchor),
//            scheduleMainTableView.bottomAnchor.constraint(equalTo: scheduleView.bottomAnchor),
//
//            scheduleViewHeight
            //            testView.topAnchor.constraint(equalTo: scheduleStackView.topAnchor),
            //            testView.leadingAnchor.constraint(equalTo: scheduleStackView.leadingAnchor),
            //            testView.trailingAnchor.constraint(equalTo: scheduleStackView.trailingAnchor),
            //            testView.bottomAnchor.constraint(equalTo: scheduleStackView.bottomAnchor),
            
            
            ])

//        scheduleViewHeight.isActive = true
        scheduleMainTableView.rowHeight = UITableView.automaticDimension
        scheduleMainTableView.estimatedRowHeight = scheduleMainTableView.rowHeight

    }
    // titleView label 정의
    var countryLabel : UILabel = {
        let label = UILabel()
        label.text = "일본 여행 🗺"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var subLabel : UILabel = {
        let label = UILabel()
        label.text = "오사카 교토"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var dateLabel : UILabel = {
        let label = UILabel()
        label.text = "2019.02.10~2019.02.16 5박6일"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var dateViewLabel : UILabel = {
        let label = UILabel()
        label.text = "2019.02.10~2019.02.16 5박6일"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var testLabel : UILabel = {
        let label = UILabel()
        label.text = "2019.02.10~2019.02.16 5박6일"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var dateView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var scheduleView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
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

    
    // title을 갖는 뷰
    lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
    }()
    lazy var allStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainStackView , scheduleMainTableView])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countryLabel , subLabel, dateLabel])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        return stackView
    }()
//    lazy var scheduleStackView : UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [dateView,scheduleView])
//        stackView.alignment = .fill
//        stackView.distribution = .fill
//        stackView.axis = .horizontal
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .blue
//        return stackView
//    }()
    @objc func btnAction(_ sender: UIButton) {
        print("add button")
        impact.impactOccurred()
        let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
        let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
        print("row is = \(indexPath.row)")
        currentIndexPath = indexPath
        buttonEvent(indexPath: indexPath)
    }
    @objc func placeButtonEvent(){
        impact.impactOccurred()
        let placeVC = placeSearchViewController()
        placeVC.myBackgroundColor = selectCellColor ?? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        self.navigationController?.pushViewController(placeVC, animated: true)
    }
    func buttonEvent(indexPath : IndexPath){
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
                currentCell?.addBtn.transform = transformScaled
                currentCell?.moneyBtn.transform = moveMoney
                currentCell?.detailBtn.transform = movedetail
                currentCell?.moneyBtn.alpha = 1
                currentCell?.detailBtn.alpha = 1
                currentCell?.buttonSelect = true
                currentCell?.addBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }else{
                let transformScaled = CGAffineTransform
                    .identity
                    .scaledBy(x: 1.0, y: 1.0)
                
                let moveMoney = CGAffineTransform(translationX: 0, y: 0)
                let movedetail = CGAffineTransform(translationX: 0, y: 0)
                currentCell?.addBtn.transform = transformScaled
                currentCell?.moneyBtn.transform = moveMoney
                currentCell?.detailBtn.transform = movedetail
                currentCell?.moneyBtn.alpha = 0.0
                currentCell?.detailBtn.alpha = 0.0
                currentCell?.buttonSelect = false
                currentCell?.addBtn.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

                self.currentIndexPath = nil
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
}
extension addDetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected!")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowCount = table_data[indexPath.row].data.count
        return CGFloat(80 * rowCount + (sizeConstant.paddingSize))
    }
}
extension addDetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCell
            cell.contentView.setCardView(view: cell.contentView)

            cell.dateLabel.text = arr[indexPath.row]
            cell.detailScheduleTableView.tag = indexPath.row
            cell.table_data.data = table_data[indexPath.row].data
            cell.addBtn.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
            cell.detailBtn.addTarget(self, action: #selector(placeButtonEvent), for: .touchUpInside)

//            print()
//            cell.detailScheduleTableView.reloadData()
//            print(cell.contentView.frame.height)
            return cell
        }else{
            print("tag different")
            let cell = UITableViewCell()
            return cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCell
//            cell.dateLabel.text = arr[indexPath.row]
//            cell.detailScheduleTableView.backgroundColor = .blue
//            return cell
        }
//        tableViewCell.textLabel?.text = arr[indexPath.row]
    }
    
    
}
extension addDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        buttonEvent(indexPath: self.currentIndexPath)
        print("scroll")
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("start")
        if currentIndexPath != nil{
            buttonEvent(indexPath: currentIndexPath!)
        }
    }
}
