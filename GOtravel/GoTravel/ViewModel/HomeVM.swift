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

        print("비교하는 \(date.localDateString())")
        print("비교하는 \(endDate.localDateString())")
        print("오늘 날짜 \(Date().localDateString())")
        print(dday)
        
        // 여행 시작 날이거나 여행 중인 날
        switch model.contentType {
        case .future:
            self.ddayTitle = "D-\(dday + 1)"
        case .past:
            self.ddayTitle = "\(dateFormatter.string(from: date)) ~ \(dateFormatter.string(from: endDate))"
        case .traveling:
            self.ddayTitle = "\(abs(dday))일차"
        }
    }
}
