//
//  HomeModelService.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/16.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation

struct TripDataType {
    let trip: Trip
    let contentType: TravelContentType
}

class HomeModelService {
    static func orderByDate(trip: [Trip]) -> [TripDataType] {
        // sorted by date
        var processedData: [TripDataType] = []
        let sortedByDate = trip.sorted {$0.date > $1.date}

        for i in sortedByDate {
            let startDay = i.date
            guard let endDate = Calendar.current.date(
                byAdding: .day,
                value: Int(i.period) - 1,
                to: startDay
                ) else {
                    continue
            }
            
            if endDate > Date() || endDate.isInSameDay(date: Date()) {
                let isFutureTravel = Date() < startDay
                
                processedData.append(TripDataType(trip: i, contentType: isFutureTravel ? .future : .traveling))
            }
        }
        return processedData
    }
    
    static func pastOrderByDate(trip: [Trip]) -> [TripDataType] {
        // sorted by date
        var processedData: [TripDataType] = []
        let sortedByDate = trip.sorted {$0.date > $1.date}

        for i in sortedByDate {
            let startDay = i.date
            guard let endDate = Calendar.current.date(
                byAdding: .day,
                value: Int(i.period) - 1,
                to: startDay
                ) else {
                    continue
            }
            if endDate < Date() {
                processedData.append(TripDataType(trip: i, contentType: .past))
            }
        }
        return processedData
    }
}
