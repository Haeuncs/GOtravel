//
//  exchangeSelectForeignVC.swift
//  GOtravel
//
//  Created by OOPSLA on 06/02/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class exchangeSelectForeignVC : UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var selectIndex = 0
    
    let keys = Array(exchange_country_dic.keys)
    let values = Array(exchange_country_dic.values)
    
    weak var delegate : exchangeDidTapInViewDelegate?

    override func viewDidLoad() {
        
    }
    override func viewWillAppear(_ animated: Bool) {

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
    let selectCountryTV : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = keys[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = keys[indexPath.row].replacingOccurrences(of: "_", with: "-")
        let value = values[indexPath.row]
        delegate?.exchangeSelectForeignDidTapCell(selectIndex: selectIndex, label: key, belowLabel: value)
        self.navigationController?.popViewController(animated: true)
        
    }

}
