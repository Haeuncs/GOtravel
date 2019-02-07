//
//  exchagneView.swift
//  GOtravel
//
//  Created by OOPSLA on 28/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class exchangeView : UIView,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    // addDetailVC -> exchangeVC 에서 전달 받는 데이터
    var countryRealmDB = countryRealm()
    var selectDay = 0

    // cell click delegate
    weak var delegate : exchangeCVCDelegate?
    
    var mainCV     : UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("layout")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        mainCV = UICollectionView(frame: CGRect(x: 0, y: 5 , width: self.bounds.width , height: self.bounds.height / 12), collectionViewLayout: flowLayout)
        mainCV.register(exchangeCVCell.self, forCellWithReuseIdentifier: "exchangeCVCell")
        mainCV.backgroundColor = UIColor.clear
        mainCV.delegate = self
        mainCV.dataSource = self
        mainCV.showsHorizontalScrollIndicator = false
        self.addSubview(mainCV)
        self.addSubview(moneyLabel)
        self.addSubview(belowView)

        NSLayoutConstraint.activate([
            
            moneyLabel.topAnchor.constraint(equalTo: mainCV.bottomAnchor, constant: 5),
//            moneyLabel.bottomAnchor.constraint(equalTo: belowView.topAnchor),
            moneyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moneyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            moneyLabel.heightAnchor.constraint(equalToConstant: 60),

//            belowView.topAnchor.constraint(equalTo: mainCV.bottomAnchor, constant: 5),
            belowView.topAnchor.constraint(equalTo: moneyLabel.bottomAnchor),
            belowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            belowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            belowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            ])
        // 이전 뷰에서 선택된 셀 표시
        let indexPathForFirstRow = NSIndexPath(item: selectDay, section: 0)
        mainCV.selectItem(at: indexPathForFirstRow as IndexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        belowView.countryRealmDB = self.countryRealmDB
        belowView.selectDay = self.selectDay

    }
    let moneyLabel : exchangeSubView = {
        let label = exchangeSubView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

//    let moneyLabel : UILabel = {
//        let label = UILabel()
//        label.text = "￦ 100.000"
//        label.textAlignment = .center
//        label.textColor = Defaull_style.subTitleColor
//        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

    // 테이블뷰
    let belowView : exchangeTV = {
       let view = exchangeTV()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryRealmDB.moneyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exchangeCVCell", for: indexPath) as! exchangeCVCell
        cell.dayLabel.text = "\(indexPath.row) 일"
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.cornerRadius = 5
        cell.backgroundColor = .white
        if cell.isSelected {
            cell.layer.borderWidth = 2
            belowView.backgroundColor = HSBrandomColor()
            
            
        }
        // 여행 전 가계부
        if indexPath.row == 0 {
            cell.dayLabel.text = "여행 전"
        }

//        cell.backgroundColor = .red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath)
        // 선택된 셀 보더 바꾸기
        let cell = collectionView.cellForItem(at: indexPath) as! exchangeCVCell
        cell.layer.borderWidth = 2
//        print(indexPath.row)
        delegate?.exchangeCVCDelegateDidTap(cell, index: indexPath.row)

//        belowView.backgroundColor = HSBrandomColor()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! exchangeCVCell
        cell.layer.borderWidth = 0

    }
    func HSBrandomColor() -> UIColor{
        let saturation : CGFloat =  0.45
        let brigtness : CGFloat = 0.85
        let randomHue = CGFloat.random(in: 0.0..<1.0)
        //        print(UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1))
        return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
    }

}
class exchangeMoneyView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        
    }
}

class exchangeSubView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        addSubview(moneyDay)
        addSubview(moneyTotal)

        addSubview(moneyDayLabel)
        addSubview(moneyTotalLabel)
        
        NSLayoutConstraint.activate([
            moneyDay.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            moneyDay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            moneyDay.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            moneyDay.heightAnchor.constraint(equalToConstant: self.frame.height/2),
            
            moneyTotal.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            moneyTotal.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            moneyTotal.leadingAnchor.constraint(equalTo: moneyDay.trailingAnchor, constant: 0),
            moneyTotal.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            moneyTotal.heightAnchor.constraint(equalToConstant: self.frame.height/2),

            moneyDayLabel.topAnchor.constraint(equalTo: moneyDay.bottomAnchor, constant: 0),
            moneyDayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            moneyDayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            moneyDayLabel.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            moneyDayLabel.heightAnchor.constraint(equalToConstant: self.frame.height/2),

            moneyTotalLabel.topAnchor.constraint(equalTo: moneyTotal.bottomAnchor, constant: 0),
            moneyTotalLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            moneyTotalLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            moneyTotalLabel.leadingAnchor.constraint(equalTo: moneyDayLabel.trailingAnchor, constant: 0),
            moneyTotalLabel.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            moneyTotalLabel.heightAnchor.constraint(equalToConstant: self.frame.height/2),

            ])
    }
    let moneyDay : UILabel = {
        let label = UILabel()
        label.text = "하루"
        label.textAlignment = .center
        label.textColor = Defaull_style.subTitleColor
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let moneyTotal : UILabel = {
        let label = UILabel()
        label.text = "총합"
        label.textAlignment = .center
        label.textColor = Defaull_style.subTitleColor
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let moneyDayLabel : UILabel = {
        let label = UILabel()
        label.text = "￦ 100.000"
        label.textAlignment = .center
        label.textColor = Defaull_style.subTitleColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let moneyTotalLabel : UILabel = {
        let label = UILabel()
        label.text = "￦ 200.000"
        label.textAlignment = .center
        label.textColor = Defaull_style.subTitleColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}

class exchangeTV : UIView,UITableViewDelegate,UITableViewDataSource {
    
    let realm = try! Realm()
    var countryRealmDB = countryRealm()
    var selectDay = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        print(countryRealmDB)
        moneyTV.register(exchangeTVC.self, forCellReuseIdentifier: "cell")
        moneyTV.delegate = self
        moneyTV.dataSource = self
        
        addSubview(moneyTV)
        NSLayoutConstraint.activate([
            moneyTV.topAnchor.constraint(equalTo: self.topAnchor),
            moneyTV.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            moneyTV.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moneyTV.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
    }
    let moneyTV : UITableView = {
       let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = Defaull_style.topTableView
        table.translatesAutoresizingMaskIntoConstraints  = false
        return table
    }()
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height/5
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! exchangeTVC
//        cell.contentView.layer.borderColor = UIColor.black.cgColor
//        cell.contentView.layer.borderWidth = 1
        cell.backgroundColor = UIColor.clear
        cell.contentView.layer.cornerRadius = CGFloat(Defaull_style.insideTableViewCorner)
        cell.contentView.backgroundColor = Defaull_style.insideTableView
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.contentView.layer.shadowOpacity = 0.2
        cell.contentView.layer.shadowRadius = 4.0

        cell.contentView.clipsToBounds = true
        let data = countryRealmDB.moneyList[selectDay].detailList[indexPath.row]
        print(indexPath.row)
        print(data)
        cell.label1.text = data.subTitle
        cell.label2.text = data.title
        // money numberFormat
        let strDouble = String(data.money)
        if let range = strDouble.range(of: ".0") {
            let dotBefore = strDouble[..<range.lowerBound]
//            let dotAfter = strDouble[range.lowerBound...]
            
            let subtractionDot = dotBefore.replacingOccurrences(of: ",", with: "")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value:Double(subtractionDot)!))
            
//            formattedNumber?.append(String(dotAfter))
            cell.label3.text = "￦ \(formattedNumber!)"
            
        }
//        cell.label3.text = "￦ \(data.money)"
        return cell
    }
//    // 각 셀마다 space
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return countryRealmDB.moneyList[selectDay].detailList.count
//    }
//
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if countryRealmDB.moneyList[selectDay].detailList.count == 0 {
            moneyTV.setEmptyMessage("X_X\n 이 날짜에 데이터가 없습니다. \n 데이터를 추가해주세요")
        } else {
            moneyTV.restore()
        }

        return countryRealmDB.moneyList[selectDay].detailList.count
    }
    

    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            try! self.realm.write {
                self.countryRealmDB.moneyList[selectDay].detailList.remove(at: indexPath.row)
            }
            self.moneyTV.reloadData()
            
        }
    }

    
}
class exchangeTVC : UITableViewCell {
    override func prepareForReuse() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))


        insideView.addSubview(label1)
        insideView.addSubview(label2)
        insideView.addSubview(label3)
        contentView.addSubview(insideView)
//        addSubview(label3)
        
//        print(label1.frame.height)
//        let viewHeight = Int(label1.frame.height + label2.frame.height)
        
        NSLayoutConstraint.activate([
            insideView.heightAnchor.constraint(equalToConstant: 40),
//            insideView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
//            insideView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            insideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            insideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            insideView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            label1.topAnchor.constraint(equalTo: insideView.topAnchor),
//            label1.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            label1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label3.trailingAnchor.constraint(equalTo: insideView.trailingAnchor, constant: 0),

            
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor),
            label2.leadingAnchor.constraint(equalTo: insideView.leadingAnchor, constant: 0),
            label2.trailingAnchor.constraint(equalTo: label3.leadingAnchor, constant: -5),
//            insideView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            label2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
//            label3.leadingAnchor.constraint(equalTo: insideView.trailingAnchor),
////            label3.leadingAnchor.constraint(greaterThanOrEqualTo: insideView.trailingAnchor),
//
            label3.centerYAnchor.constraint(equalTo: insideView.centerYAnchor),
            ])
//        insideView.backgroundColor = .red

    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let insideView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let label1 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "호텔"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    let label2 : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "도쿄 호텔 비용"
        return label
    }()
    let label3 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "￦ 100.000"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()


}
