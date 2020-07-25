//
//  ManagedPlan+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import UIKit
import CoreData

struct Plan {
    internal init(address: String, memo: String? = nil, oneLineMemo: String? = nil, pinColor: UIColor? = nil, title: String, coordinate: Coordinate) {
        self.address = address
        self.memo = memo
        self.oneLineMemo = oneLineMemo
        self.pinColor = pinColor
        self.title = title
        self.coordinate = coordinate
    }

    var address: String
    var memo: String?
    var oneLineMemo: String?
    var pinColor: UIColor?
    var title: String
    var coordinate: Coordinate
}

extension Plan {
    func toManaged(context: NSManagedObjectContext) -> ManagedPlan {
        let managedPlan = ManagedPlan(context: context)
        managedPlan.address = self.address
        managedPlan.memo = self.memo
        managedPlan.oneLineMemo = self.oneLineMemo
        if let color = self.pinColor {
            managedPlan.pinColor = color.encode() as NSObject?
        }
        managedPlan.title = self.title
        managedPlan.coordinate = self.coordinate.toManaged(context: context)
        managedPlan.address = self.address
        return managedPlan
    }
}

extension ManagedPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPlan> {
        return NSFetchRequest<ManagedPlan>(entityName: "Plan")
    }

    @NSManaged public var address: String?
    @NSManaged public var memo: String?
    @NSManaged public var oneLineMemo: String?
    @NSManaged public var pinColor: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var coordinate: ManagedCoordinate?
    @NSManaged public var ofTrip: ManagedTrip?

}

extension ManagedPlan {
    func toPlan() -> Plan {
        let plan = Plan(address: self.address ?? "", memo: self.memo ?? "", oneLineMemo: self.oneLineMemo ?? "", pinColor: self.pinColor as? UIColor, title: self.title ?? "", coordinate: Coordinate(latitude: self.coordinate?.latitude ?? 0, longitude: self.coordinate?.longitude ?? 0))

        return plan
    }
}
