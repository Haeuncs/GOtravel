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

class exchangeSelectForeignVC : UIViewController, UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable {
  
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
  }
  func initView(){
    selectCountryTV.delegate = self
    selectCountryTV.dataSource = self
    view.addSubview(labelView)
    labelView.addSubview(timeLabel)
    self.view.addSubview(selectCountryTV)
    view.bringSubviewToFront(labelView)
    labelView.snp.makeConstraints{ (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(60)
    }
    timeLabel.snp.makeConstraints{ (make) in
      make.centerY.equalTo(labelView.snp.centerY)
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
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(ExchangeRateCell.self, forCellReuseIdentifier: "cell")
    return table
  }()
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return exchangeArr.count + (exchangeRealmData?.count ?? 0) + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExchangeRateCell
    if indexPath.row == 0 {
      cell.titleLabel.text = "환율 직접 설정하기"
      cell.descriptionLabel.text = "직접 환율을 설정하시려면 눌러주세요 🧐"
      cell.moneyLabel.text = ""
      return cell
    }else if (1 + (exchangeRealmData?.count ?? 0)) <= indexPath.row{
      let index = indexPath.row - (exchangeRealmData?.count ?? 0) - 1
      let value = ExchangeCountryDictionary[exchangeArr[index].cur_unit]
      cell.titleLabel.text = value?.country
      cell.descriptionLabel.text = "1 \(exchangeArr[index].cur_unit) (\(value?.korName ?? ""))"
      cell.moneyLabel.text = "\(String(exchangeArr[index].deal_bas_r)) 원"
      return cell
    }else{
      cell.titleLabel.text = exchangeRealmData?[indexPath.row - 1].name
      cell.descriptionLabel.text = "1 \(exchangeRealmData?[indexPath.row - 1].exchangeName ?? "")"
      cell.moneyLabel.text = "\(exchangeRealmData?[indexPath.row - 1].krWon ?? 0) 원"
      return cell
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let vc = DirectExchangeViewController()
      self.present(vc, animated: true, completion: nil)
    }else if (1 + (exchangeRealmData?.count ?? 0)) <= indexPath.row {
      let index = indexPath.row - (exchangeRealmData?.count ?? 0) - 1
      let value = ExchangeCountryDictionary[exchangeArr[index].cur_unit]
      let StringToDouble = exchangeArr[index].deal_bas_r.replacingOccurrences(of: ",", with: "").toDouble()
      delegate?.exchangeSelectForeignDidTapCell(selectIndex: selectIndex, label: value?.country ?? "", belowLabel: "\(exchangeArr[indexPath.row].cur_unit) (\(value?.korName ?? ""))", doubleMoney: StringToDouble!)
      self.navigationController?.popViewController(animated: true)
    }else{
      if let data = exchangeRealmData?[indexPath.row - 1] {
        delegate?.exchangeSelectForeignDidTapCell(selectIndex: selectIndex, label: data.name, belowLabel: data.exchangeName, doubleMoney: data.krWon)
        self.navigationController?.popViewController(animated: true)
      }else{
        Toast.show(message: "오류가 발생했어요!", isTabbar: false)
      }
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
            //                    dispatchGroup.leave()
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
    }
  }
}
