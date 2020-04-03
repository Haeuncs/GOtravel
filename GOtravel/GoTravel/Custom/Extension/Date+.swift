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
extension Date {

    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }

    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return self.compare(with: date, only: component) == 0
    }
}
extension Date {
  @nonobjc static var localFormatter: DateFormatter = {
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateStyle = .medium
    dateStringFormatter.timeStyle = .medium
    return dateStringFormatter
  }()

  func localDateString() -> String
  {
    return Date.localFormatter.string(from: self)
  }
}
