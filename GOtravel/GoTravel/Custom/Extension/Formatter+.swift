//
//  Formatter+.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/15.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
//
extension Formatter {
  static let decimal: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    return formatter
  }()

}
//extension integer{
//  var formattedWithSeparator: String {
//    return Formatter.withSeparator.string(for: self) ?? ""
//  }
//}
