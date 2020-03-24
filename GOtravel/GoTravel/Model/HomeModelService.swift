//
//  HomeModelService.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/16.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import RealmSwift

class HomeModelService {
  func orderByDate(data: Results<countryRealm>) -> [countryRealm]{
    // sorted by date
    var processedData: [countryRealm] = []
    
    let sortedByDate = data.sorted(byKeyPath: "date", ascending: true)
    // 전처리 오늘 보다 이전 날짜는 제외
    for i in sortedByDate {
      let startDay = i.date ?? Date()
      let endDate = Calendar.current.date(byAdding: .day, value: i.period, to: startDay)
      if endDate ?? Date() > Date() {
        processedData.append(i)
      }
    }
    return processedData
  }
}
