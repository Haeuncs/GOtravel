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

extension UITableView {

  func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = .black
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    //        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
    messageLabel.sizeToFit()

    self.backgroundView = messageLabel;
    self.separatorStyle = .none;
  }

  func restore() {
    self.backgroundView = nil
    //        self.separatorStyle = .singleLine
  }
}
