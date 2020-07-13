//
//  String+.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/13.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import UIKit

//get date from string
extension String {
  static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  var date: Date? {
    return String.dateFormatter.date(from: self)
  }

  func toCGFloat() -> CGFloat {
    let number = NumberFormatter().number(from: self)
    return number as? CGFloat ?? 0
  }
}
