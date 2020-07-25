//
//  Trip+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var country: String?
    @NSManaged public var city: String?
    @NSManaged public var date: Date?
    @NSManaged public var period: Int64
    @NSManaged public var coordinate: Coordinate?
    @NSManaged public var payByDays: NSSet?
    @NSManaged public var planByDays: NSSet?

}

// MARK: Generated accessors for payByDays
extension Trip {

    @objc(addPayByDaysObject:)
    @NSManaged public func addToPayByDays(_ value: Pay)

    @objc(removePayByDaysObject:)
    @NSManaged public func removeFromPayByDays(_ value: Pay)

    @objc(addPayByDays:)
    @NSManaged public func addToPayByDays(_ values: NSSet)

    @objc(removePayByDays:)
    @NSManaged public func removeFromPayByDays(_ values: NSSet)

}

// MARK: Generated accessors for planByDays
extension Trip {

    @objc(addPlanByDaysObject:)
    @NSManaged public func addToPlanByDays(_ value: Plan)

    @objc(removePlanByDaysObject:)
    @NSManaged public func removeFromPlanByDays(_ value: Plan)

    @objc(addPlanByDays:)
    @NSManaged public func addToPlanByDays(_ values: NSSet)

    @objc(removePlanByDays:)
    @NSManaged public func removeFromPlanByDays(_ values: NSSet)

}
