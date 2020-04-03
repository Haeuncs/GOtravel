//
//  UITableView+.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/18.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit

extension UITableView {
  func setNoDataPlaceholder(_ message: String) {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    label.text = message
    // styling
    label.sizeToFit()
    
    self.isScrollEnabled = false
    self.backgroundView = label
    self.separatorStyle = .none
  }
}
extension UITableView {
  func removeNoDataPlaceholder() {
    self.isScrollEnabled = true
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }
}
