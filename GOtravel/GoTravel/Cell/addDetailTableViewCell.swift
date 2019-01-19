
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
protocol BinaryCellDelegate {
    func addToSum(num: Int)
}
protocol SwiftyTableViewCellDelegate : class {
    func swiftyTableViewCellDidTapHeart(_ sender: addDetailTableViewCell)
    func tableViewDeleteEvent(_ sender: addDetailTableViewCell)
}

class addDetailTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
    var isEdit : Bool = false

    let realm = try! Realm()
    weak var mydelegate: SwiftyTableViewCellDelegate?

    var delegate:BinaryCellDelegate!
    
    var countryRealmDB : Results<countryRealm>?
    var nav = UINavigationController()
//    var table_data = TableData()
    var buttonSelect = false
//    var currentIndexPath : IndexPath?

    var dayRealmDB : dayRealm?
    var count = 0
    var selectCountryIndex : Int?
    var selectDayIndex : Int?

    lazy var dateView : addDetailViewCellView = {
        let view = addDetailViewCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var detailScheduleTableView : UITableView = {
        let tableView = UITableView()
        tableView.tag = 1
        tableView.backgroundColor = .white
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
    override func prepareForReuse()
    {
        super.prepareForReuse()
        print("재사용")
        initView()

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
        print("test style")
        contentView.backgroundColor = .white
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.delegate = addDetailViewController()
        contentView.addSubview(stackView)
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
        if count != 0{
            detailScheduleTableView.allowsSelection = true
            detailScheduleTableView.isEditing = isEdit
        }else{
            detailScheduleTableView.isEditing = false
            detailScheduleTableView.allowsSelection = false
        }
        countryRealmDB = realm.objects(countryRealm.self).sorted(byKeyPath: "date", ascending: true)
    }
    
    
}
extension addDetailTableViewCell {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select Cell")
        mydelegate?.swiftyTableViewCellDidTapHeart(self)
//        delegate?.addToSum(num: 1)
//        let googleMapVC = googleMapViewController()
//        googleMapVC.dayDetailRealm = dayRealmDB!.detailList
//        googleMapVC.arrayMap = true
//        googleMapVC.currentSelect = dayRealmDB!.detailList[indexPath.row]
        
        
//        beforeView.present(googleMapVC, animated: true, completion: nil)
        
        
        
        
//        nav.pushViewController(new, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//
//    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var currentMove = dayRealmDB?.detailList[sourceIndexPath.row]
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
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        if count != 0{
//            let more = UITableViewRowAction(style: .normal, title: "수정") { action, index in
//                print("more button tapped")
//
//                //            tableView.reloadData()
//            }
//            more.backgroundColor = .myGreen
//
//            let favorite = UITableViewRowAction(style: .normal, title: "이동") { action, index in
//                print("favorite button tapped")
//                self.detailScheduleTableView.isEditing = !self.detailScheduleTableView.isEditing
//            }
//            favorite.backgroundColor = .myBlue
//
//            let share = UITableViewRowAction(style: .normal, title: "삭제") { action, index in
//                try! self.realm.write {
//                    self.dayRealmDB?.detailList.remove(at: indexPath.row)
//                }
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                self.mydelegate?.tableViewDeleteEvent(self)
//
//                print("삭제")
//
//
//            }
//            share.backgroundColor = .myRed
//
//            return [share, favorite, more]
//
//        }
//        return []
//    }
}
extension addDetailTableViewCell{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count == 0{
            return 1
        }else{
            return dayRealmDB?.detailList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCellInsideTableViewCell
//        cell.titleLabel.text = dayRealmDB!.detailList[indexPath.row].title
//        print(dayRealmDB?.detailList.isEmpty)
//        if (!((dayRealmDB?.detailList.isEmpty)!)){
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "ko-KR")
//            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm:ss a")
//            let day = dateFormatter.string(from: dayRealmDB!.detailList[indexPath.row].date ?? Date())
//
//            cell.timeLabel.text = day
//        }else{
//            cell.titleLabel.text = "저장된 일정이 없습니다."
//            cell.titleLabel.textAlignment = .center
//            cell.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
//            cell.titleLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//        }
        if count == 0{
            cell.titleLabel.text = "저장된 일정이 없습니다."
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            cell.titleLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.timeLabel.text = ""
        }else{
            cell.titleLabel.text = dayRealmDB!.detailList[indexPath.row].title
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko-KR")
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm:ss a")
            let day = dateFormatter.string(from: dayRealmDB!.detailList[indexPath.row].date ?? Date())
            cell.titleLabel.textColor = .black
            cell.titleLabel.font = UIFont.systemFont(ofSize: 16)
            cell.titleLabel.textAlignment = .natural
            cell.timeLabel.text = day

        }
        return cell
    }
    
}
