////
////  addDetailViewTableViewDelegate.swift
////  GOtravel
////
////  Created by OOPSLA on 17/01/2019.
////  Copyright © 2019 haeun. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class addDetailViewTableViewDelegate : NSObject, UITableViewDelegate, UITableViewDataSource{
//    var data = [Int]()
//
//    // variable that holds a stores a function
//    // which return Void but accept an Int and a UITableViewCell as arguments.
//    var didSelectRow: ((_ dataItem: Int, _ cell: UITableViewCell) -> Void)?
//    
//    init(data: [Int]) {
//        self.data = data
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
//        
//        let text = String(data[indexPath.row])
//        cell.textLabel?.text = text
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath as IndexPath)!
//        let dataItem = data[indexPath.row]
//        
//        if let didSelectRow = didSelectRow {
//            // Calling didSelectRow that was set in ViewController.
//            didSelectRow(dataItem, cell)
//        }
//    }
//}
