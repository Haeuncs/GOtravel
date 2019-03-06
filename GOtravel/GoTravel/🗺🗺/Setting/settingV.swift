//
//  settingV.swift
//  GOtravel
//
//  Created by OOPSLA on 04/03/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class settingV : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        initView()
    }
    func initView() {
        self.addSubview(table)
        table.delegate = self
        table.dataSource = self
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            table.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            table.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            table.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            ])
    }
    let table : UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = Defaull_style.topTableView
        table.translatesAutoresizingMaskIntoConstraints  = false
        return table
    }()

}

extension settingV : UITableViewDelegate {
    
}
extension settingV : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell()
        tableCell.textLabel?.text = "\(indexPath.row)"
        return tableCell
    }
    
    
}
