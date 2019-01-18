
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
    var countryRealmDB : Results<countryRealm>?

//    var table_data = TableData()
    var buttonSelect = false
//    var currentIndexPath : IndexPath?

    var dayRealmDB : dayRealm?
    
    let dateView : addDetailViewCellView = {
        let view = addDetailViewCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let detailScheduleTableView : UITableView = {
        let tableView = UITableView()
        tableView.tag = 1
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = UIColor.clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    var label : UILabel = {
        let label = UILabel()
        label.text = "일정을 추가하세요."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var paddingViewBottom : addDetailViewCellButtonView = {
        let view = addDetailViewCellButtonView()
//        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func prepareForReuse()
    {
        super.prepareForReuse()
//        print("재사용")
        for sub in detailScheduleTableView.subviews{
            sub.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if detailScheduleTableView.subviews.isEmpty {
            detailScheduleTableView.reloadData()

        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("test style")
        contentView.backgroundColor = .white
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){

        contentView.addSubview(stackView)
        print(dayRealmDB as Any) 
        // 1/4 로 dateLabel 과 detailScheduleTableView 를 나눈다.
        if publicdayCount == 0 {
            print("runnn")
            let stackViewMultiplerWidth = NSLayoutConstraint(item: dateView, attribute: .width, relatedBy: .equal, toItem: label, attribute: .width, multiplier: 0.25, constant: 0.0)

//            stackView.alignment = .center
            
            contentView.addSubview(paddingViewBottom)

            stackView.addArrangedSubview(dateView)
            stackView.addArrangedSubview(label)


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
        }else{
            print("run")
            let stackViewMultiplerWidth = NSLayoutConstraint(item: dateView, attribute: .width, relatedBy: .equal, toItem: detailScheduleTableView, attribute: .width, multiplier: 0.25, constant: 0.0)
            contentView.addSubview(paddingViewBottom)

            stackView.addArrangedSubview(dateView)
            stackView.addArrangedSubview(detailScheduleTableView)

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
            // programmatically 방식의 cell
            detailScheduleTableView.register(addDetailTableViewCellInsideTableViewCell.self, forCellReuseIdentifier: "cell")

            detailScheduleTableView.delegate = self
            detailScheduleTableView.dataSource = self
            detailScheduleTableView.separatorStyle = .none
            detailScheduleTableView.rowHeight = UITableView.automaticDimension
            detailScheduleTableView.estimatedRowHeight = 200
            detailScheduleTableView.allowsSelection = false

        }
        
    }
}

extension addDetailTableViewCell {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "수정") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = .myGreen
        
        let favorite = UITableViewRowAction(style: .normal, title: "이동") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = .myBlue
        
        let share = UITableViewRowAction(style: .normal, title: "삭제") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = .myRed
        
        return [share, favorite, more]

    }
}
extension addDetailTableViewCell{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayRealmDB?.detailList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCellInsideTableViewCell
        cell.titleLabel.text = dayRealmDB!.detailList[indexPath.row].title
        if ((dayRealmDB?.detailList.count) != nil){
            cell.timeLabel.text = "날짜 테스트"
        }
        
        return cell
    }
    
}
