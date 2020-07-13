//
//  HomeVM.swift
//  GOtravel
//
//  Created by OOPSLA on 08/02/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

protocol mainVC_protocol {
    var countryTitle: String{ get }
    var cityTitle: String{ get }
    var ddayTitle: String{ get }
}
struct  MainVCCVCViewModel: mainVC_protocol{
    var countryTitle: String
    var cityTitle: String
    var ddayTitle: String
    
    init(_ model: countryRealm) {
        self.countryTitle = model.country
        self.cityTitle = model.city
        self.ddayTitle = ""
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yy.M.dd"
      var dday = model.date?.totalDistance(from: Date(), resultIn: .day)
      print("비교하는 \(dateFormatter.string(from: model.date!))")
      print("오늘 날짜 \(dateFormatter.string(from: Date()))")
      print(dday)
      // 여행 시작 날이거나 여행 중인 날
      if dday! >= 0 {
        let endDate = Calendar.current.date(byAdding: .day, value: model.period - 1, to: model.date ?? Date())
        if endDate! > Date() {
          self.ddayTitle = "\(dday! + 1)일차"
        }else{
          self.ddayTitle = "\(dateFormatter.string(from: model.date!)) ~ \(dateFormatter.string(from: endDate!))"
        }
      }else{
        self.ddayTitle = "D-\((dday!*(-1)) + 1)"
      }
    }
}
