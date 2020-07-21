//
//  HomeModelService.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/16.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import RealmSwift

struct TravelDataType {
    let countryData: countryRealm
    let contentType: TravelContentType
}

class HomeModelService {
    static func orderByDate(data: Results<countryRealm>) -> [TravelDataType] {
        // sorted by date
        var processedData: [TravelDataType] = []
        let sortedByDate = data.sorted(byKeyPath: "date", ascending: true)
        
        for i in sortedByDate {
            let startDay = i.date ?? Date()
            guard let endDate = Calendar.current.date(
                byAdding: .day,
                value: i.period - 1,
                to: startDay
                ) else {
                    continue
            }
            
            if endDate > Date() || endDate.isInSameDay(date: Date()) {
                let isFutureTravel = Date() < startDay
                
                processedData.append(TravelDataType(countryData: i, contentType: isFutureTravel ? .future : .traveling))
            }
        }
        return processedData
    }
    
    static func pastTravel(data: Results<countryRealm>) -> [TravelDataType] {
        var processedData: [TravelDataType] = []
        let sortedByDate = data.sorted(byKeyPath: "date", ascending: true)
        
        for i in sortedByDate {
            let startDay = i.date ?? Date()
            guard let endDate = Calendar.current.date(
                byAdding: .day,
                value: i.period - 1,
                to: startDay
                ) else {
                    continue
            }
            if endDate < Date() {
                processedData.append(TravelDataType(countryData: i, contentType: .past))
            }
        }
        return processedData
    }
}
