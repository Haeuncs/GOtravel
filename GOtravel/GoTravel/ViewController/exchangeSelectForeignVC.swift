//
//  exchangeSelectForeignVC.swift
//  GOtravel
//
//  Created by OOPSLA on 06/02/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

struct exchangeData: Codable {
    var cur_unit : String
    var deal_bas_r: String

}

class exchangeSelectForeignVC : UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    var exchangeArr : [exchangeData] = []
    var selectIndex = 0
    
    let keys = Array(exchange_country_dic.keys)
    let values = Array(exchange_country_dic.values)
    
    weak var delegate : exchangeDidTapInViewDelegate?

    override func viewDidLoad() {
        
    }
    override func viewWillAppear(_ animated: Bool) {

        findURL()
        
        selectCountryTV.delegate = self
        selectCountryTV.dataSource = self
        
        self.view.addSubview(selectCountryTV)
        
        NSLayoutConstraint.activate([
            selectCountryTV.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            selectCountryTV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            selectCountryTV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            selectCountryTV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            ])
    }

    // 파싱
    func get_Data(){
//        while self.exchangeArr.count == 0 {
//            let dispatchGroup = DispatchGroup()
//            dispatchGroup.enter()
//
//            findURL()
//            dispatchGroup.leave()
//
//            self.count = self.count - 1
//        }

//
//        while exchangeArr.count == 0 {
////            print("start")
//            findURL()
//            print(exchangeArr.count)
////            count = count - 1
////            print(count)
//        }
    }
    func findURL(){
        var count = 0

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "taskQueue")
        let dispatchSemaphore = DispatchSemaphore(value: 0)

        var basicURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=fmmSohmV4M3z8jeqtUZiYmPXrUnjp1bs&data=AP01&searchdate="
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
            
//            print(self.exchangeArr.count)
            self.selectCountryTV.reloadData()
        }

//        dispatchGroup.notify(queue:.main) {
//            print(self.exchangeArr.count)
////            count = count - 1
//        }
////
    }
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
