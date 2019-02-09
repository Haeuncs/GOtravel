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

struct exchangeData: Codable {
    var cur_unit : String
    var deal_bas_r: String

}

class exchangeSelectForeignVC : UIViewController, UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable {
    
    
    var exchangeArr : [exchangeData] = []
    var selectIndex = 0
    
    let keys = Array(exchange_country_dic.keys)
    let values = Array(exchange_country_dic.values)
    
    weak var delegate : exchangeDidTapInViewDelegate?
    
    let size = CGSize(width: 30, height: 30)
    
    var DateData = ""
    
    override func viewDidLoad() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        findURL()
        
        selectCountryTV.delegate = self
        selectCountryTV.dataSource = self
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(selectCountryTV)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            timeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        
            
            selectCountryTV.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 0),
            selectCountryTV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            selectCountryTV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            selectCountryTV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            ])
    }
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
    let timeLabel : UILabel = {
       let label = UILabel()
        label.text = "dd"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Defaull_style.subTitleColor
        return label
    }()
    let selectCountryTV : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        cell.textLabel?.text = keys[indexPath.row]
        let key = exchange_country_dic.someKey(forValue: exchangeArr[indexPath.row].cur_unit) ?? ""
        cell.textLabel?.text = "\(key) \(String(exchangeArr[indexPath.row].deal_bas_r))"

//        cell.detailTextLabel?.text =
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var key = exchange_country_dic.someKey(forValue: exchangeArr[indexPath.row].cur_unit) ?? ""
        key = key.replacingOccurrences(of: "_", with: "-")
        let value = exchangeArr[indexPath.row].cur_unit
//        delegate?.exchangeSelectForeignDidTapCell(selectIndex: selectIndex, label: key, belowLabel: value)
//        print(exchangeArr[indexPath.row].deal_bas_r)
//        print(exchangeArr[indexPath.row].deal_bas_r.toDouble())
        let StringToDouble = exchangeArr[indexPath.row].deal_bas_r.replacingOccurrences(of: ",", with: "").toDouble()
        delegate?.exchangeSelectForeignDidTapCell(selectIndex: selectIndex, label: key, belowLabel: value, doubleMoney: StringToDouble!)

        self.navigationController?.popViewController(animated: true)
        
    }

}
