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

extension String {
  func toDouble() -> Double? {
    return NumberFormatter().number(from: self)?.doubleValue
  }
  func characterToCgfloat() -> CGFloat {
    let n = NumberFormatter().number(from: self)
    return n as! CGFloat
  }
  func addDotInNumber() -> String{
    if self.count != 0 {
      let subtractionDot = self.replacingOccurrences(of: ",", with: "")

      if (subtractionDot.contains(".")){
        if let range = subtractionDot.range(of: ".") {
          let dotBefore = subtractionDot[..<range.lowerBound]
          let dotAfter = subtractionDot[range.lowerBound...] // or str[str.startIndex..<range.lowerBound]
          print(dotBefore)  // Prints ab

          let subtractionDot = dotBefore.replacingOccurrences(of: ",", with: "")
          let numberFormatter = NumberFormatter()
          numberFormatter.numberStyle = NumberFormatter.Style.decimal
          var formattedNumber = numberFormatter.string(from: NSNumber(value: (subtractionDot.toDouble())!))

          formattedNumber?.append(String(dotAfter))
          return formattedNumber ?? ""

        }
      }else{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: (subtractionDot.toDouble())!))

        return formattedNumber ?? ""
      }
    }
    return ""
  }

}
