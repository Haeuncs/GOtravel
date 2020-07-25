////
////  ExchangeTableView.swift
////  GOtravel
////
////  Created by LEE HAEUN on 2020/07/16.
////  Copyright © 2020 haeun. All rights reserved.
////
//
//import UIKit
//
//
//class ExchangeTV: UIView,UITableViewDelegate,UITableViewDataSource {
//
//  let realm = try! Realm()
//  var countryRealmDB = countryRealm()
//  var selectDay = 0 {
//    didSet {
//      moneyTV.reloadData()
//    }
//  }
//  var delegate: ExchangeView?
//  //  var exchangeCell:exchangeCVCell?
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//  }
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  override func layoutSubviews() {
//    print(countryRealmDB)
//    moneyTV.register(ExchangeCell.self, forCellReuseIdentifier: "cell")
//    moneyTV.delegate = self
//    moneyTV.dataSource = self
//
//    addSubview(moneyTV)
//    NSLayoutConstraint.activate([
//      moneyTV.topAnchor.constraint(equalTo: self.topAnchor),
//      moneyTV.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//      moneyTV.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//      moneyTV.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//    ])
//  }
//  let moneyTV: UITableView = {
//    let table = UITableView()
//    table.separatorStyle = .none
//    table.backgroundColor = DefaullStyle.topTableView
//    table.translatesAutoresizingMaskIntoConstraints = false
//    return table
//  }()
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return self.frame.height / 5
//  }
//  //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//  //        return 20
//  //    }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: "cell",
//            for: indexPath) as? ExchangeCell else {
//      return UITableViewCell()
//    }
//
//    let data = countryRealmDB.moneyList[selectDay].detailList[indexPath.row]
//
//    cell.label1.text = data.subTitle
//    cell.label2.text = data.title
//
//    cell.backgroundColor = UIColor.clear
//    cell.contentView.layer.cornerRadius = CGFloat(DefaullStyle.insideTableViewCorner)
//    cell.contentView.backgroundColor = DefaullStyle.insideTableView
//    cell.contentView.layer.shadowColor = UIColor.black.cgColor
//    cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
//    cell.contentView.layer.shadowOpacity = 0.2
//    cell.contentView.layer.shadowRadius = 4.0
//
//    cell.contentView.clipsToBounds = true
//
//    // money numberFormat
//    let strDouble = String(data.money)
//    if let range = strDouble.range(of: ".0") {
//      let dotBefore = strDouble[..<range.lowerBound]
//      //            let dotAfter = strDouble[range.lowerBound...]
//
//      let subtractionDot = dotBefore.replacingOccurrences(of: ",", with: "")
//      let numberFormatter = NumberFormatter()
//      numberFormatter.numberStyle = NumberFormatter.Style.decimal
//      let formattedNumber = numberFormatter.string(from: NSNumber(value: Double(subtractionDot)!))
//
//      //            formattedNumber?.append(String(dotAfter))
//      cell.label3.text = "￦ \(formattedNumber!)"
//
//    }
//    //        cell.label3.text = "￦ \(data.money)"
//    return cell
//  }
//  //    // 각 셀마다 space
//  //    func numberOfSections(in tableView: UITableView) -> Int {
//  //        return countryRealmDB.moneyList[selectDay].detailList.count
//  //    }
//  //
//  // There is just one row in every section
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    if countryRealmDB.moneyList[selectDay].detailList.count == 0 {
//      moneyTV.setEmptyMessage("X_X\n 이 날짜에 데이터가 없습니다. \n 데이터를 추가해주세요")
//    } else {
//      moneyTV.restore()
//    }
//
//    return countryRealmDB.moneyList[selectDay].detailList.count
//  }
//
//  // Set the spacing between sections
//  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 10
//  }
//
//  // Make the background color show through
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let headerView = UIView()
//    headerView.backgroundColor = UIColor.clear
//    return headerView
//  }
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .delete{
//      try! self.realm.write {
//        self.countryRealmDB.moneyList[selectDay].detailList.remove(at: indexPath.row)
//      }
//      self.moneyTV.reloadData()
//      delegate?.reloadMoneyLabels(index: selectDay)
//    }
//  }
//
//}
