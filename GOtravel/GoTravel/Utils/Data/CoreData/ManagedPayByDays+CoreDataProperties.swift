//
//  ManagedPayByDays+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData

struct PayByDays {
    internal init(day: Int, pays: [Pay]) {
        self.day = day
        self.pays = pays
    }

    var day: Int
    var pays: [Pay]
}

extension PayByDays {
    func toManaged(context: NSManagedObjectContext) -> ManagedPayByDays {
        let managedPayByDays = ManagedPayByDays(context: context)
        managedPayByDays.day = Int16(self.day)
        managedPayByDays.pays = NSSet(array: self.pays.map({ (pay) -> ManagedPay in
            pay.toManaged(context: context)
        }))
        return managedPayByDays
    }
}

extension ManagedPayByDays {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPayByDays> {
        return NSFetchRequest<ManagedPayByDays>(entityName: "PayByDays")
    }

    @NSManaged public var day: Int16
    @NSManaged public var pays: NSSet?
    @NSManaged public var ofTrip: ManagedTrip?

}

// MARK: Generated accessors for pays
extension ManagedPayByDays {

    @objc(addPaysObject:)
    @NSManaged public func addToPays(_ value: ManagedPay)

    @objc(removePaysObject:)
    @NSManaged public func removeFromPays(_ value: ManagedPay)

    @objc(addPays:)
    @NSManaged public func addToPays(_ values: NSSet)

    @objc(removePays:)
    @NSManaged public func removeFromPays(_ values: NSSet)

}
