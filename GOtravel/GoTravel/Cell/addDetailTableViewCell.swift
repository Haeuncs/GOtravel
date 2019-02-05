
//
//  addDetailViewTableViewCell.swift
//  GOtravel
//
//  Created by OOPSLA on 16/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class addDetailTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {

    let realm = try! Realm()
    
    weak var mydelegate: addDetailViewTableViewCellDelegate?
    
    // MARK: VC로 부터 전달받는 데이터
    var count = 0
    var isEdit : Bool = false
    var dayRealmDB : dayRealm?
    
    // MARK: VC에서 사용하는 변수
    var buttonSelect = false

    override func prepareForReuse()
    {
        super.prepareForReuse()
        print("재사용")
//        initView()
        
        for sub in detailScheduleTableView.subviews{
            sub.removeFromSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initView()
        
        if detailScheduleTableView.subviews.isEmpty {
            detailScheduleTableView.reloadData()
        }
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        contentView.backgroundColor = .white

        contentView.addSubview(stackView)
        contentView.addSubview(paddingViewBottom)
        
        stackView.addArrangedSubview(dateView)
        stackView.addArrangedSubview(detailScheduleTableView)
        
        // programmatically 방식의 cell
        detailScheduleTableView.register(addDetailTableViewCellInsideTableViewCell.self, forCellReuseIdentifier: "cell")
        
        detailScheduleTableView.delegate = self
        detailScheduleTableView.dataSource = self
//        detailScheduleTableView.separatorStyle = .none
        detailScheduleTableView.rowHeight = UITableView.automaticDimension
        detailScheduleTableView.estimatedRowHeight = 200
//        if isEdit == true{
        detailScheduleTableView.isScrollEnabled = false
//        }
        if count != 0{
            detailScheduleTableView.allowsSelection = true
            detailScheduleTableView.isEditing = isEdit
        }else{
            detailScheduleTableView.isEditing = false
            detailScheduleTableView.allowsSelection = false
//            detailScheduleTableView.isScrollEnabled = true
        }
        initLayout()
    }
    func initLayout(){
        let stackViewMultiplerWidth = NSLayoutConstraint(item: dateView, attribute: .width, relatedBy: .equal, toItem: detailScheduleTableView, attribute: .width, multiplier: 0.25, constant: 0.0)

        NSLayoutConstraint.activate([
            paddingViewBottom.heightAnchor.constraint(equalToConstant: CGFloat(sizeConstant.paddingSize)),
            paddingViewBottom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            paddingViewBottom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paddingViewBottom.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: paddingViewBottom.topAnchor),
            
            
            stackViewMultiplerWidth
            
            ])

    }
    // MARK: Cell 에서 사용하는 것들
    lazy var dateView : addDetailViewCellView = {
        let view = addDetailViewCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var detailScheduleTableView : UITableView = {
        let tableView = UITableView()
        tableView.tag = 1
        tableView.backgroundColor = .white
        tableView.separatorColor = Defaull_style.subTitleColor
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = UIColor.clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    lazy var label : UILabel = {
        let label = UILabel()
        label.text = "일정을 추가하세요."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var paddingViewBottom : addDetailViewCellButtonView = {
        let view = addDetailViewCellButtonView()
        //        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

}
// MARK: tableView 부분
extension addDetailTableViewCell {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select Cell \(indexPath.row)")
        // delegate 로 데이터 전달
        mydelegate?.addDetailViewTableViewCellDidTapInTableView(self,detailIndex: indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currentMove = dayRealmDB?.detailList[sourceIndexPath.row]
        try! self.realm.write {
            self.dayRealmDB?.detailList.remove(at: sourceIndexPath.row)
            self.dayRealmDB?.detailList.insert(currentMove!, at: destinationIndexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            try! self.realm.write {
                self.dayRealmDB?.detailList.remove(at: indexPath.row)
            }
            self.mydelegate?.tableViewDeleteEvent(self)
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count == 0{
            return 1
        }else{
            return dayRealmDB?.detailList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCellInsideTableViewCell
        if count == 0{
            cell.titleLabel.text = "저장된 일정이 없습니다."
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            cell.titleLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.timeLabel.text = ""
            cell.colorView.backgroundColor = UIColor.clear
            cell.timeLabel.isHidden = true

        }else{
            cell.titleLabel.text = dayRealmDB!.detailList[indexPath.row].title
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko-KR")
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm:ss a")
//            let day = dateFormatter.string(from: dayRealmDB!.detailList[indexPath.row].date ?? Date())
            cell.titleLabel.textColor = .black
            cell.titleLabel.font = UIFont.systemFont(ofSize: 16)
            cell.titleLabel.textAlignment = .natural
            if dayRealmDB?.detailList[indexPath.row].startTime != nil {
                cell.timeLabel.isHidden = true
            }
//            cell.timeLabel.text = day
            let colorStr = dayRealmDB?.detailList[indexPath.row].color
            if colorStr != "default" {
                let colorArr = colorStr?.components(separatedBy: " ")
                cell.colorView.backgroundColor = UIColor.init(red: characterToCgfloat(str: colorArr![0]), green: characterToCgfloat(str: colorArr![1]), blue: characterToCgfloat(str: colorArr![2]), alpha: characterToCgfloat(str: colorArr![3]))
            }else{
                cell.colorView.backgroundColor = UIColor.clear
            }
            let oneLineMemo = dayRealmDB?.detailList[indexPath.row].oneLineMemo
            
            if oneLineMemo != "" {
                print(oneLineMemo!)
                cell.oneLineMemo.isHidden = false
                cell.oneLineMemo.text = oneLineMemo!
            }else if oneLineMemo == "" {
                cell.oneLineMemo.isHidden = true
            }
        }
        return cell
    }
    func characterToCgfloat(str : String) -> CGFloat {
        let n = NumberFormatter().number(from: str)
        return n as! CGFloat
    }

}
