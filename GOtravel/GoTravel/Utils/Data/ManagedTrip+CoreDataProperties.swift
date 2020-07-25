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
    internal init(city: String, country: String, date: Date, period: Int64, coordinate: Coordinate, payByDays: [Pay], planByDays: [Plan]) {
        self.city = city
        self.country = country
        self.date = date
        self.identifier = UUID()
        self.period = period
        self.coordinate = coordinate
        self.payByDays = payByDays
        self.planByDays = planByDays
    }

    var city: String
    var country: String
    var date: Date
    var identifier: UUID
    var period: Int64
    var coordinate: Coordinate
    var payByDays: [Pay]
    var planByDays: [Plan]
}

extension Trip {
    func toManaged(context: NSManagedObjectContext) -> ManagedTrip {
        let trip = ManagedTrip(context: context)
        trip.country = self.country
        trip.city = self.city
        trip.date = self.date
        trip.period = self.period
        trip.identifier = self.identifier
        trip.coordinate = self.coordinate.toManaged(context: context)
        var payByDays = [ManagedPay]()
        for payData in self.payByDays {
            payByDays.append(payData.toManaged(context: context))
        }
        trip.payByDays = NSSet(array: payByDays)

        var planByDays = [ManagedPlan]()
        for planData in self.planByDays {
            planByDays.append(planData.toManaged(context: context))
        }
        trip.planByDays = NSSet(array: planByDays)
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
    @NSManaged public var period: Int64
    @NSManaged public var coordinate: ManagedCoordinate?
    @NSManaged public var payByDays: NSSet?
    @NSManaged public var planByDays: NSSet?

}

// MARK: Generated accessors for payByDays
extension ManagedTrip {

    @objc(addPayByDaysObject:)
    @NSManaged public func addToPayByDays(_ value: ManagedPay)

    @objc(removePayByDaysObject:)
    @NSManaged public func removeFromPayByDays(_ value: ManagedPay)

    @objc(addPayByDays:)
    @NSManaged public func addToPayByDays(_ values: NSSet)

    @objc(removePayByDays:)
    @NSManaged public func removeFromPayByDays(_ values: NSSet)

}

// MARK: Generated accessors for planByDays
extension ManagedTrip {

    @objc(addPlanByDaysObject:)
    @NSManaged public func addToPlanByDays(_ value: ManagedPlan)

    @objc(removePlanByDaysObject:)
    @NSManaged public func removeFromPlanByDays(_ value: ManagedPlan)

    @objc(addPlanByDays:)
    @NSManaged public func addToPlanByDays(_ values: NSSet)

    @objc(removePlanByDays:)
    @NSManaged public func removeFromPlanByDays(_ values: NSSet)

}
