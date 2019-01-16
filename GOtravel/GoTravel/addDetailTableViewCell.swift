
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
    let arr = ["인천공항","간사이 국제 공항","숙소","햅파이브","edklrhjfkdshkjfhjkdshfkhdskjhfjkhdsjkfhkdshjfhkjdshkfjhjdkshfkdhskjfhjkdshkfhjkdshfkjhdsjkhfkjdhskjfhkjdshfkjhdskjhfjkhdjkshjkhfkjhjkhk"]
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

    let dateView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let detailScheduleTableView : UITableView = {
        let tableView = UITableView()
        tableView.tag = 1
        tableView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = .green
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        print("testNib")
        // Initialization code
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("test coder")
        initView()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("test style")
        contentView.backgroundColor = .white
        initView()
    }

    func initView(){
        contentView.addSubview(stackView)
        
        dateView.addSubview(dateLabel)
        dateView.addSubview(dayOfTheWeek)
        
        stackView.addArrangedSubview(dateView)
        stackView.addArrangedSubview(detailScheduleTableView)
        
        detailScheduleTableView.register(addDetailTableViewCellInsideTableViewCell.self, forCellReuseIdentifier: "cell")

        let stackViewMultiplerWidth = NSLayoutConstraint(item: dateLabel, attribute: .width, relatedBy: .equal, toItem: detailScheduleTableView, attribute: .width, multiplier: 0.25, constant: 0.0)

        NSLayoutConstraint.activate([
//            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
////            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            contentView.bottomAnchor.constraint(equalTo: detailScheduleTableView.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor,constant:5),
            dateLabel.topAnchor.constraint(equalTo: dateView.topAnchor,constant:5),
            dateLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor,constant:-5),
            // 정사각형으로 만들기!
            dateLabel.heightAnchor.constraint(equalTo: dateView.widthAnchor, constant: -10),
            
            dayOfTheWeek.leadingAnchor.constraint(equalTo: dateView.leadingAnchor),
            dayOfTheWeek.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant:5),
            dayOfTheWeek.trailingAnchor.constraint(equalTo: dateView.trailingAnchor),



            stackViewMultiplerWidth
            
            ])
        DispatchQueue.main.async {
            
            self.detailScheduleTableView.reloadData()
        }
        detailScheduleTableView.delegate = self
        detailScheduleTableView.dataSource = self
//        detailScheduleTableView.separatorStyle = .none
        detailScheduleTableView.rowHeight = UITableView.automaticDimension
        detailScheduleTableView.estimatedRowHeight = 200
        detailScheduleTableView.allowsSelection = false
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
}
extension addDetailTableViewCell{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCellInsideTableViewCell
        cell.titleLabel.text = arr[indexPath.row]
        cell.timeLabel.text = "날짜 테스트"
        print(cell.contentView.frame.height)
//        print(arr[indexPath.row])
//        print(cell.contentView.frame.height)
        
        return cell
    }
}
