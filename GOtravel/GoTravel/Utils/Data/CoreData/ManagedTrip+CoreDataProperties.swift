//
//  ManagedTrip+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData

struct Trip {
    internal init(city: String, country: String, date: Date, identifier: UUID, period: Int, coordinate: Coordinate, payByDays: [PayByDays] = [], planByDays: [PlanByDays] = []) {
        self.city = city
        self.country = country
        self.date = date
        self.identifier = identifier
        self.period = period
        self.coordinate = coordinate
        self.payByDays = payByDays
        self.planByDays = planByDays
    }
    
    var city: String
    var country: String
    var date: Date
    var identifier: UUID
    var period: Int
    var coordinate: Coordinate
    var payByDays: [PayByDays]
    var planByDays: [PlanByDays]
}

extension Trip {
    func toManaged(context: NSManagedObjectContext) -> ManagedTrip {
        let trip = ManagedTrip(context: context)
        trip.country = self.country
        trip.city = self.city
        trip.date = self.date
        trip.period = Int16(self.period)
        trip.identifier = self.identifier
        trip.coordinate = self.coordinate.toManaged(context: context)
        trip.payByDays = NSSet(array: self.payByDays.map({ (payByDay) -> ManagedPayByDays in
            payByDay.toManaged(context: context)
        }))
        trip.planByDays = NSSet(array: self.planByDays.map({ (planByDay) -> ManagedPlanByDays in
            planByDay.toManaged(context: context)
        }))
        return trip
    }
}

extension ManagedTrip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedTrip> {
        return NSFetchRequest<ManagedTrip>(entityName: "Trip")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var date: Date?
    @NSManaged public var identifier: UUID?
    @NSManaged public var period: Int16
    @NSManaged public var coordinate: ManagedCoordinate?
    @NSManaged public var payByDays: NSSet?
    @NSManaged public var planByDays: NSSet?

}

extension ManagedTrip {
    func toTrip() -> Trip {
        var payByDays = [PayByDays]()
        var planByDays = [PlanByDays]()
        if let currentPayByDays = self.payByDays,
            let currentPayByDayArr = Array(currentPayByDays) as? [ManagedPayByDays],
            currentPayByDayArr.isEmpty == false {

            payByDays = currentPayByDayArr.map { (managedPayByDay) -> PayByDays in
                var pays = [Pay]()
                if let pay = managedPayByDay.pays,
                    let payArr = Array(pay) as? [ManagedPay] {
                    pays = payArr.map { (managedPay) -> Pay in
                        managedPay.toPay()
                    }
                }
                pays.sort {
                    $0.displayOrder < $1.displayOrder
                }

                return PayByDays(day: Int(managedPayByDay.day), pays: pays)
            }
        }

        payByDays.sort {
            $0.day < $1.day
        }

        if let currentPlanByDays = self.planByDays,
            let currentPlanByDayArr = Array(currentPlanByDays) as? [ManagedPlanByDays],
            currentPlanByDayArr.isEmpty == false {
            planByDays = currentPlanByDayArr.map({ (managedPlanByDays) -> PlanByDays in
                managedPlanByDays.toPlanByDays()
            })
        }

        planByDays.sort {
            $0.day < $1.day
        }

        return Trip(
            city: self.city ?? "",
            country: self.country ?? "",
            date: self.date ?? Date(),
            identifier: self.identifier ?? UUID(),
            period: Int(self.period),
            coordinate: Coordinate(latitude: self.coordinate?.latitude ?? 0, longitude: self.coordinate?.longitude ?? 0),
            payByDays: payByDays,
            planByDays: planByDays
        )
    }
}

// MARK: Generated accessors for payByDays
extension ManagedTrip {

    @objc(addPayByDaysObject:)
    @NSManaged public func addToPayByDays(_ value: ManagedPlanByDays)

    @objc(removePayByDaysObject:)
    @NSManaged public func removeFromPayByDays(_ value: ManagedPlanByDays)

    @objc(addPayByDays:)
    @NSManaged public func addToPayByDays(_ values: NSSet)

    @objc(removePayByDays:)
    @NSManaged public func removeFromPayByDays(_ values: NSSet)

}

// MARK: Generated accessors for planByDays
extension ManagedTrip {

    @objc(addPlanByDaysObject:)
    @NSManaged public func addToPlanByDays(_ value: ManagedPayByDays)

    @objc(removePlanByDaysObject:)
    @NSManaged public func removeFromPlanByDays(_ value: ManagedPayByDays)

    @objc(addPlanByDays:)
    @NSManaged public func addToPlanByDays(_ values: NSSet)

    @objc(removePlanByDays:)
    @NSManaged public func removeFromPlanByDays(_ values: NSSet)

}
