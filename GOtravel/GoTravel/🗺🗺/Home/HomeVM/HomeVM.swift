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
    var countryTitle : String{get}
    var cityTitle : String{get}
    var ddayTitle : String{get}
}
struct  mainVC_CVC_ViewModel: mainVC_protocol{
    var countryTitle : String
    var cityTitle : String
    var ddayTitle : String
    
    init(_ model : countryRealm) {
        self.countryTitle = model.country
        self.cityTitle = model.city
        self.ddayTitle = ""
        
        // d - day 계산
        let intervalToday = model.date?.timeIntervalSince(Date())
        // optional check
        if let intervalToday = intervalToday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy.M.dd"
            dateFormatter.locale = Locale(identifier: "ko-KR")
            // FIXIT  :  PEROID 계산해서 그 기간안이면 +day 일 , 이미 지난 여행이면 데이트 포맷터로 하기~!_!
            var dday = Int(intervalToday / 86400)
            if dday >= 0 {
                self.ddayTitle = "D-\(dday)"
            }else{
                
                let endDate = Calendar.current.date(byAdding: .day, value: model.period, to: model.date ?? Date())
                if endDate! > Date() {
                    dday = dday * -1
                    self.ddayTitle = "+\(dday)일"
                }else{
                    self.ddayTitle = "\(                dateFormatter.string(from: model.date!)) ~ \(                dateFormatter.string(from: endDate!))"
                }
//                dday = dday * -1
//                self.ddayTitle = "+\(dday)일"
            }
        }
    }
}

