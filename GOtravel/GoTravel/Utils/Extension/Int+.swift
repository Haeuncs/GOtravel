//
//  Int+.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/17.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation

extension Int {
  func toNumber() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
  }
}

