
//
//  addDetailViewTableViewCell.swift
//  GOtravel
//
//  Created by OOPSLA on 16/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class addDetailTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {

    var table_data = TableData()
    var buttonSelect = false
    var currentIndexPath : IndexPath?


    var arr = ["인천공항","간사이 국제 공항","숙소","햅파이브","edklrhjfkdshkjfhjkdshfkhdskjhfjkhdsjkfhkdshjfhkjdshkfjhjdkshfkdhskjfhjkdshkfhjkdshfkjhdsjkhfkjdhskjfhkjdshfkjhdskjhfjkhdjkshjkhfkjhjkhk"]
    var calcHeight = Dictionary<Int,CGFloat>()

    let dateLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "test"
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dayOfTheWeek : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "월요일"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let addBtn : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "addBtn")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    var moneyBtn : UIButton = {
        let button = UIButton(type: .custom)
        button.alpha = 0.0
        let image = UIImage(named: "moneyBtn")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let detailBtn : UIButton = {
        let button = UIButton(type: .custom)
        button.alpha = 0.0
        let image = UIImage(named: "detailBtn")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()


    let dateView : UIView = {
        let view = UIView()
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
    var paddingViewTop : UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var paddingViewBottom : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func prepareForReuse()
    {
        super.prepareForReuse()
        // Reset the cell for new row's data
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


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("test style")
        contentView.backgroundColor = .white
        initView()
    }

    func initView(){
        

        contentView.addSubview(stackView)
        contentView.addSubview(paddingViewBottom)
//        contentView.addSubview(paddingViewTop)
        
        dateView.addSubview(dateLabel)
        dateView.addSubview(dayOfTheWeek)
        paddingViewBottom.addSubview(moneyBtn)
        paddingViewBottom.addSubview(detailBtn)
        paddingViewBottom.addSubview(addBtn)

        stackView.addArrangedSubview(dateView)
        stackView.addArrangedSubview(detailScheduleTableView)
        
        detailScheduleTableView.register(addDetailTableViewCellInsideTableViewCell.self, forCellReuseIdentifier: "cell")

        let stackViewMultiplerWidth = NSLayoutConstraint(item: dateLabel, attribute: .width, relatedBy: .equal, toItem: detailScheduleTableView, attribute: .width, multiplier: 0.25, constant: 0.0)
        let consssss = CGFloat(50)
        NSLayoutConstraint.activate([
//            contentView.leadingAnchor.constraint(equalTo: leadingAnchor ),
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
////            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            paddingViewTop.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            paddingViewTop.topAnchor.constraint(equalTo: contentView.topAnchor),
//            paddingViewTop.heightAnchor.constraint(equalToConstant: CGFloat(sizeConstant.paddingSize)),
//            paddingViewTop.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            paddingViewTop.bottomAnchor.constraint(equalTo: stackView.topAnchor),

            paddingViewBottom.heightAnchor.constraint(equalToConstant: CGFloat(sizeConstant.paddingSize)),
            paddingViewBottom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            paddingViewBottom.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            paddingViewBottom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paddingViewBottom.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: paddingViewBottom.topAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor,constant:5),
            dateLabel.topAnchor.constraint(equalTo: dateView.topAnchor,constant:5),
            dateLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor,constant:-5),
            // 정사각형으로 만들기!
            dateLabel.heightAnchor.constraint(equalTo: dateView.widthAnchor, constant: -10),
            
            dayOfTheWeek.leadingAnchor.constraint(equalTo: dateView.leadingAnchor),
            dayOfTheWeek.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant:5),
            dayOfTheWeek.trailingAnchor.constraint(equalTo: dateView.trailingAnchor),

//            addBtn.leadingAnchor.constraint(equalTo: dateView.leadingAnchor),
            addBtn.topAnchor.constraint(equalTo: paddingViewBottom.topAnchor,constant:5),
//            addBtn.trailingAnchor.constraint(equalTo: dateView.trailingAnchor),
            addBtn.heightAnchor.constraint(equalToConstant: 35),
            addBtn.widthAnchor.constraint(equalToConstant: 35),
            addBtn.centerXAnchor.constraint(equalTo: paddingViewBottom.centerXAnchor),
//            addBtn.centerYAnchor.constraint(equalTo: paddingViewBottom.centerYAnchor),
//
            moneyBtn.topAnchor.constraint(equalTo: paddingViewBottom.topAnchor,constant:5),
            moneyBtn.heightAnchor.constraint(equalToConstant: 35),
            moneyBtn.widthAnchor.constraint(equalToConstant: 35),
//            moneyBtn.trailingAnchor.constraint(equalTo: addBtn.leadingAnchor, constant: -10),
            
            detailBtn.topAnchor.constraint(equalTo: paddingViewBottom.topAnchor,constant:5),
//            detailBtn.leadingAnchor.constraint(equalTo: addBtn.trailingAnchor, constant: 10),
            detailBtn.heightAnchor.constraint(equalToConstant: 35),
            detailBtn.widthAnchor.constraint(equalToConstant: 35),
            
            detailBtn.centerXAnchor.constraint(equalTo: paddingViewBottom.centerXAnchor),
            moneyBtn.centerXAnchor.constraint(equalTo: paddingViewBottom.centerXAnchor),

//            addBtn.bottomAnchor.constraint(equalTo: dateView.bottomAnchor,constant:-5),



            stackViewMultiplerWidth
            
            ])
        detailScheduleTableView.delegate = self
        detailScheduleTableView.dataSource = self
        detailScheduleTableView.separatorStyle = .none
        detailScheduleTableView.rowHeight = UITableView.automaticDimension
        detailScheduleTableView.estimatedRowHeight = 200
        detailScheduleTableView.allowsSelection = false
//        detailScheduleTableView.isEditing = true
    }
}

extension addDetailTableViewCell {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell 안의 테이블뷰 selected!")
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
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
////            arr.remove(at: indexPath.row)
//            table_data.data.remove(at: indexPath.row)
//            // Delete the row from the TableView tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            tableView.deleteRows(at: [indexPath], with: .bottom)
//        }
//    }
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
}
extension addDetailTableViewCell{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table_data.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCellInsideTableViewCell
//        cell.titleLabel.text = arr[indexPath.row]
        cell.titleLabel.text = table_data.data[indexPath.row]
        cell.timeLabel.text = "날짜 테스트"
//        print(cell.contentView.frame.height)
//        print(arr[indexPath.row])
//        print(cell.contentView.frame.height)
        
        return cell
    }
    
}
