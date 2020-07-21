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

struct  MainVCCVCViewModel: mainVC_protocol {
    var countryTitle: String
    var cityTitle: String
    var ddayTitle: String

    init(_ model: TravelDataType) {
        let countryData = model.countryData
        self.countryTitle = countryData.country
        self.cityTitle = countryData.city
        self.ddayTitle = ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.M.dd"

        guard let date = countryData.date,
            let endDate = Calendar.current.date(byAdding: .day, value: countryData.period - 1, to: date) else {
            return
        }
        let dday = date.interval(ofComponent: .day, fromDate: Date())

        print("비교하는 \(dateFormatter.string(from: date))")
        print("오늘 날짜 \(dateFormatter.string(from: Date()))")
        print(dday)
        
        // 여행 시작 날이거나 여행 중인 날
        if dday >= 0 {
            if model.contentType == .traveling {
                self.ddayTitle = "\((dday * -1) + 1)일차"
            } else if model.contentType == .future {
                self.ddayTitle = "D-\(dday)"
            }
        }else{
            self.ddayTitle = "\(dateFormatter.string(from: date)) ~ \(dateFormatter.string(from: endDate))"
        }
    }
}
