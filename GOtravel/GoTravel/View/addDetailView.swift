//
//  addDetailView.swift
//  GOtravel
//
//  Created by OOPSLA on 18/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

public enum sizeConstant {
    public static let paddingSize = 50
}

class addDetailView : UIView {
    
}
extension addDetailView : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected!")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowCount = table_data[indexPath.row].data.count
        return CGFloat(80 * rowCount + (sizeConstant.paddingSize))
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCell
        cell.contentView.setCardView(view: cell.contentView)
        
        cell.dateLabel.text = arr[indexPath.row]
        cell.detailScheduleTableView.tag = indexPath.row
        cell.table_data.data = table_data[indexPath.row].data
        cell.addBtn.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        cell.detailBtn.addTarget(self, action: #selector(placeButtonEvent), for: .touchUpInside)
        return cell
        
    }

}
extension addDetailView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        buttonEvent(indexPath: self.currentIndexPath)
        print("scroll")
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("start")
        if currentIndexPath != nil{
            buttonEvent(indexPath: currentIndexPath!)
        }
    }
}
