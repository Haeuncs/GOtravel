//
//  exchangeSelectForeignVC.swift
//  GOtravel
//
//  Created by OOPSLA on 06/02/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SnapKit
import RealmSwift
import SwiftSimpleToast

struct exchangeData: Codable {
  var cur_unit : String
  var deal_bas_r: String
}

class exchangeSelectForeignVC : UIViewController,NVActivityIndicatorViewable {
  
  var exchangeArr : [exchangeData] = []
  var selectIndex = 0
  /// realm
  let realm = try? Realm()
  var exchangeRealmData: Results<ExchangeRealm>?

//  let keys = Array(exchange_country_dic.keys)
//  let values = Array(exchange_country_dic.values)
  
  weak var delegate : exchangeDidTapInViewDelegate?
  
  let size = CGSize(width: 30, height: 30)
  
  var DateData = ""
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    initView()
  }
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = false
    findURL()
    checkRealmData()
    selectCountryTV.reloadData()
    arrCountLabel.text = ""
  }
  func initView(){
    selectCountryTV.delegate = self
    selectCountryTV.dataSource = self
    view.addSubview(labelView)
    labelView.addSubview(arrCountLabel)
    labelView.addSubview(timeLabel)
    self.view.addSubview(selectCountryTV)
    view.bringSubviewToFront(labelView)
    labelView.snp.makeConstraints{ (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(60)
    }
    arrCountLabel.snp.makeConstraints{ (make) in
      make.centerY.equalTo(labelView.snp.centerY)
      make.left.equalTo(labelView.snp.left).offset(16)
      make.right.lessThanOrEqualTo(timeLabel.snp.left)
    }
    timeLabel.snp.makeConstraints{ (make) in
      make.centerY.equalTo(labelView.snp.centerY)
//      make.left.greaterThanOrEqualTo(arrCountLabel.snp.right)
      make.right.equalTo(labelView.snp.right).offset(-16)
    }
    NSLayoutConstraint.activate([
      selectCountryTV.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 0),
      selectCountryTV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      selectCountryTV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      selectCountryTV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
    ])
  }
  lazy var labelView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.zeplinStyleShadows(color: .black, alpha: 0.07, x: 0, y: 10, blur: 10, spread: 0)
    view.clipsToBounds = false
    return view
  }()
  lazy var arrCountLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb14
    label.backgroundColor = .red
    label.textColor = Defaull_style.mainTitleColor
    return label
  }()
  let timeLabel : UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    label.textColor = Defaull_style.subTitleColor
    return label
  }()
  let selectCountryTV : UITableView = {
    let table = UITableView()
    table.separatorStyle = .none
    table.allowsMultipleSelectionDuringEditing = false
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(ExchangeRateCell.self, forCellReuseIdentifier: "cell")
    return table
  }()
}

extension exchangeSelectForeignVC {
  @objc func tableViewEdit(){
    selectCountryTV.isEditing = !selectCountryTV.isEditing
    selectCountryTV.reloadData()
    if self.navigationItem.rightBarButtonItem?.title == "편집"{
      self.navigationItem.rightBarButtonItem?.title = "완료"
    }else{
      self.navigationItem.rightBarButtonItem?.title = "편집"
    }
  }
}
extension exchangeSelectForeignVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      print(indexPath.row)
      if let date = exchangeRealmData?[indexPath.row] {
        try! realm?.write {
          realm?.delete(date)
        }
      }
      selectCountryTV.reloadData()
    }
  }
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section == 1 {
      if exchangeRealmData?.count ?? 0 > 0 {
        return true
      }else{
        return false
      }
    }else{
      return false
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      let vc = DirectExchangeViewController()
      self.present(vc, animated: true, completion: nil)
    }else if indexPath.section == 1 {
      if exchangeRealmData?.count ?? 0 > 0 {
        let value = ExchangeCountryDictionary[exchangeArr[indexPath.row].cur_unit]
        let StringToDouble = exchangeArr[indexPath.row].deal_bas_r.replacingOccurrences(of: ",", with: "").toDouble()
        delegate?.exchangeSelectForeignDidTapCell(selectIndex: selectIndex, label: value?.country ?? "", belowLabel: "\(exchangeArr[indexPath.row].cur_unit) (\(value?.korName ?? ""))", doubleMoney: StringToDouble!)
        self.navigationController?.popViewController(animated: true)
      }else{
        if let data = exchangeRealmData?[indexPath.row] {
          delegate?.exchangeSelectForeignDidTapCell(selectIndex: selectIndex, label: data.name, belowLabel: data.exchangeName, doubleMoney: data.krWon)
          self.navigationController?.popViewController(animated: true)
        }else{
          Toast.show(message: "오류가 발생했어요!", isTabbar: false)
        }
      }
    }else{
      if let data = exchangeRealmData?[indexPath.row] {
        delegate?.exchangeSelectForeignDidTapCell(selectIndex: selectIndex, label: data.name, belowLabel: data.exchangeName, doubleMoney: data.krWon)
        self.navigationController?.popViewController(animated: true)
      }else{
        Toast.show(message: "오류가 발생했어요!", isTabbar: false)
      }
    }
  }
}
extension exchangeSelectForeignVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    if exchangeRealmData?.count ?? 0 > 0 {
      return 3
  }else {
    return 2
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }else if section == 1{
      return exchangeRealmData?.count ?? exchangeArr.count
    }else{
      return exchangeArr.count
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExchangeRateCell
    if indexPath.section == 0 {
      cell.titleLabel.text = "환율 직접 설정하기"
      cell.descriptionLabel.text = "직접 환율을 설정하시려면 눌러주세요 🧐"
      cell.moneyLabel.text = ""
      return cell
    }else if indexPath.section == 1 {
      if exchangeRealmData?.count ?? 0 > 0 {
        cell.titleLabel.text = exchangeRealmData?[indexPath.row].name
        cell.descriptionLabel.text = "1 \(exchangeRealmData?[indexPath.row].exchangeName ?? "")"
        cell.moneyLabel.text = "\(exchangeRealmData?[indexPath.row].krWon ?? 0) 원"
        return cell
      }else{
        let value = ExchangeCountryDictionary[exchangeArr[indexPath.row].cur_unit]
        cell.titleLabel.text = value?.country
        cell.descriptionLabel.text = "1 \(exchangeArr[indexPath.row].cur_unit) (\(value?.korName ?? ""))"
        cell.moneyLabel.text = "\(String(exchangeArr[indexPath.row].deal_bas_r)) 원"
        return cell
      }
    }else{
      let value = ExchangeCountryDictionary[exchangeArr[indexPath.row].cur_unit]
      cell.titleLabel.text = value?.country
      cell.descriptionLabel.text = "1 \(exchangeArr[indexPath.row].cur_unit) (\(value?.korName ?? ""))"
      cell.moneyLabel.text = "\(String(exchangeArr[indexPath.row].deal_bas_r)) 원"
      return cell
    }
  }
}

// MARK: network
extension exchangeSelectForeignVC {
  func findURL(){
    var count = 0
    
    let dispatchGroup = DispatchGroup()
    let dispatchQueue = DispatchQueue(label: "taskQueue")
    let dispatchSemaphore = DispatchSemaphore(value: 0)
    
    let basicURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=fmmSohmV4M3z8jeqtUZiYmPXrUnjp1bs&data=AP01&searchdate="
    dispatchQueue.async {
      while self.exchangeArr.count == 0{
        // 오늘날짜부터 시작해서 데이터가 있는 날짜까지 뺌
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let subDate = Calendar.current.date(byAdding: .day, value: count, to: Date())
        
        let day = dateFormatter.string(from: subDate!)
        let currnetURL = basicURL + day
        let url = URL(string: currnetURL)
        print(url)
        URLSession.shared.dataTask(with: url!) { (data, response
          , error) in
          dispatchGroup.enter()
          
          guard let data = data else {
            DispatchQueue.main.async {
              self.timeLabel.text = "네트워크를 확인해 주세요."
              Toast.show(message: "데이터를 받아오지 못했어요 :(", isTabbar: false)
            }
            dispatchGroup.leave()
            return
            
          }
          do {
            //                    print(data)
            let decoder = JSONDecoder()
            do {
              let todo = try decoder.decode([exchangeData].self, from: data)
              self.exchangeArr = todo
              count = count - 1
              self.DateData = day
            } catch {
              print("error trying to convert data to JSON")
              print(error)
            }
          }
          dispatchSemaphore.signal()
          dispatchGroup.leave()
          
        }.resume()
        dispatchSemaphore.wait()
      }
    }
    dispatchGroup.notify(queue: dispatchQueue) {
      
      DispatchQueue.main.async {
        self.selectCountryTV.reloadData()
        self.timeLabel.text = "환율 기준 : " + self.DateData
      }
    }
    
  }

}
extension exchangeSelectForeignVC {
  func checkRealmData(){
    if let data = realm?.objects(ExchangeRealm.self) {
      exchangeRealmData = data
      arrCountLabel.text = "직접 압력: \(data.count)개"
      let rightButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(tableViewEdit))
      self.navigationItem.rightBarButtonItem = rightButton
    }else{
      arrCountLabel.text = ""
    }
  }
}
