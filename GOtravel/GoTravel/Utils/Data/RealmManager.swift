////
////  RealmManager.swift
////  GOtravel
////
////  Created by LEE HAEUN on 2020/03/27.
////  Copyright © 2020 haeun. All rights reserved.
////
//
//import Foundation
//
//
//protocol RealmManagerType {
//  func getPresentTripData() -> [TravelDataType]
//  func saveTripData(data: countryRealm)
//  func deleteTripData(data: countryRealm)
//  func saveTripSpecificDetail(data: dayRealm, detail: detailRealm)
//  func deleteTripSpecificDetail(data: dayRealm, index: Int)
//  func addTripSpecificReceipt(data: moneyRealm, detail: moneyDetailRealm)
//  func updateTripSpecificReceipt(beforeData: moneyDetailRealm,
//                                 updateData: moneyDetailRealm)
//  func deleteTripSpecificReceipt(data: moneyRealm, detail: moneyDetailRealm)
//}
//
//class RealmManager: RealmManagerType {
//  
//  static let shared = RealmManager()
//  let realm = try? Realm()
//  
//  func getPresentTripData() -> [TravelDataType] {
//    guard let data = realm?.objects(countryRealm.self) else {
//      return []
//    }
//    return HomeModelService.orderByDate(data: data)
//  }
//  
//  func saveTripData(data: countryRealm) {
//    try! realm?.write {
//      realm?.add(data)
//    }
//  }
//  
//  func deleteTripData(data: countryRealm) {
//    try! realm?.write {
//      realm?.delete(data)
//    }
//  }
//  
//  func deleteTripSpecificDetail(data: dayRealm, index: Int) {
//    try! realm?.write {
//      data.detailList.remove(at: index)
//    }
//  }
//  
//  func saveTripSpecificDetail(data: dayRealm, detail: detailRealm) {
//    try! realm?.write {
//      data.detailList.append(detail)
//    }
//  }
//  
//  func updateTripSpecificReceipt(beforeData: moneyDetailRealm,
//                                 updateData: moneyDetailRealm) {
//    try! realm?.write {
//      beforeData.title = updateData.title
//      beforeData.subTitle = updateData.subTitle
//      beforeData.money = updateData.money
//      beforeData.exchange = updateData.exchange
//    }
//  }
//  
//  func addTripSpecificReceipt(data: moneyRealm, detail: moneyDetailRealm) {
//    try! realm?.write {
//      data.detailList.append(detail)
//    }
//  }
//  
//  func deleteTripSpecificReceipt(data: moneyRealm, index: Int, complete: @escaping (() -> Void)) {
//    DispatchQueue.main.async {
//      try! self.realm?.write {
//        data.detailList.remove(at: index)
//      }
//      complete()
//    }
//  }
//  
//  func deleteTripSpecificReceipt(data: moneyRealm, detail: moneyDetailRealm) {
//    if let index = data.detailList.index(of: detail) {
//      try! realm?.write {
//        data.detailList.remove(at: index)
//      }
//    }
//  }
//
//  func orderByDate(data: Results<countryRealm>) -> [countryRealm]{
//    // sorted by date
//    var processedData: [countryRealm] = []
//    
//    let sortedByDate = data.sorted(byKeyPath: "date", ascending: true)
//    // 전처리 오늘 보다 이전 날짜는 제외
//    for i in sortedByDate {
//      let startDay = i.date ?? Date()
//      let endDate = Calendar.current.date(byAdding: .day, value: i.period, to: startDay)
//      if endDate ?? Date() > Date() {
//        processedData.append(i)
//      }
//    }
//    return processedData
//  }
//  
//}
