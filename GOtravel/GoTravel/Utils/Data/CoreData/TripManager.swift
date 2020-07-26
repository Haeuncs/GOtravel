//
//  TripManager.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/25.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit

class TripManager {
    static let shared = TripManager()

    func updatePay(trip: Trip, day: Int, pay: Pay) -> Bool {
        var currentTrip = trip
        outerLoop: for index in 0 ..< currentTrip.payByDays.count
            where currentTrip.payByDays[index].day == day {
                for jndex in 0 ..< currentTrip.payByDays[index].pays.count
                    where currentTrip.payByDays[index].pays[jndex].identifier == pay.identifier {
                        currentTrip.payByDays[index].pays[jndex] = pay
                        break outerLoop
                }
        }
        return (TripCoreDataManager.shared.updateTrip(updateTrip: currentTrip) != nil)
    }

    func addPay(trip: Trip, day: Int, pay: Pay) -> Bool {
        var currentTrip = trip
        var currentPay = pay
        for index in 0 ..< currentTrip.payByDays.count
            where currentTrip.payByDays[index].day == day {
                let displayOrder = currentTrip.payByDays[index].pays.count
                currentPay.displayOrder = Int16(displayOrder)
                currentTrip.payByDays[index].pays.append(currentPay)
                break
        }
        return (TripCoreDataManager.shared.updateTrip(updateTrip: currentTrip) != nil)
    }

    func deletePay(trip: Trip, day: Int, pay: Pay) -> Bool {
        var currentTrip = trip
        outerLoop: for index in 0 ..< currentTrip.payByDays.count
            where currentTrip.payByDays[index].day == day {
                for jndex in 0 ..< currentTrip.payByDays[index].pays.count
                    where currentTrip.payByDays[index].pays[jndex].identifier == pay.identifier {
                        currentTrip.payByDays[index].pays.remove(at: jndex)
                        break outerLoop
                }
        }
        return (TripCoreDataManager.shared.updateTrip(updateTrip: currentTrip) != nil)
    }

    func fetchPayByDay(trip: Trip, day: Int) -> PayByDays? {
        guard let fetchedTrip = TripCoreDataManager.shared.fetchTrip(identifier: trip.identifier) else {
            return nil
        }

        for index in 0 ..< fetchedTrip.payByDays.count where fetchedTrip.payByDays[index].day == day {
            return fetchedTrip.payByDays[index]
        }

        return nil
    }

    func fetchPayByDays(trip: Trip) -> [PayByDays]? {
        guard let fetchedTrip = TripCoreDataManager.shared.fetchTrip(identifier: trip.identifier) else {
            return nil
        }
        return fetchedTrip.payByDays
    }

//    func updatePlan() -> {
//
//    }
//
//    func addPlan() -> {
//
//    }
//
//    func deletePlan() -> {
//
//    }
//
//    func fetchPlan() -> {
//
//    }

}
