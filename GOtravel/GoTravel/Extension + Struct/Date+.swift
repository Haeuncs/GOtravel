//
//  DateExtensions.swift
//  GOtravel
//
//  Created by OOPSLA on 18/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation

//get first day of the month
extension Date {
  var weekday: Int {
    return Calendar.current.component(.weekday, from: self)
  }
  var firstDayOfTheMonth: Date {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
  }
  func getDayOfWeek(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko-KR")
    
    dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
    let day = dateFormatter.string(from: date)
    return day
  }
  static func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.default
    dateFormatter.dateFormat = format
    
    let date = dateFormatter.date(from: string)!
    return date
  }
  
  func isInSameMonth(date: Date) -> Bool {
    return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
  }
  func isInSameYear(date: Date) -> Bool {
    return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
  }
  func isInSameDay(date: Date) -> Bool {
    return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
  }
}


extension Date {
  /// 날짜 차이 계산
  func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
    
    let currentCalendar = Calendar.current
    
    guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
    guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
    
    return end - start
  }
}