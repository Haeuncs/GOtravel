//
//  ManagedPlan+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/26.
//
//

import UIKit
import CoreData

struct Plan {
    internal init(
        address: String,
        memo: String? = nil,
        oneLineMemo: String? = nil,
        pinColor: UIColor? = nil,
        title: String,
        coordinate: Coordinate,
        displayOrder: Int16,
        identifier: UUID
    ) {
        self.address = address
        self.memo = memo
        self.oneLineMemo = oneLineMemo
        self.pinColor = pinColor
        self.title = title
        self.coordinate = coordinate
        self.displayOrder = displayOrder
        self.identifier = identifier
    }

    var address: String
    var memo: String?
    var oneLineMemo: String?
    var pinColor: UIColor?
    var title: String
    var coordinate: Coordinate
    var displayOrder: Int16
    var identifier: UUID
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
        managedPlan.identifier = self.identifier
        managedPlan.displayOrder = displayOrder
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
    @NSManaged public var title: String
    @NSManaged public var displayOrder: Int16
    @NSManaged public var identifier: UUID
    @NSManaged public var coordinate: ManagedCoordinate?
    @NSManaged public var ofPlanByDays: ManagedPlanByDays?

}

extension ManagedPlan {
    func toPlan() -> Plan {
        var color: UIColor?

        if let colorData = pinColor as? Data {
            color = UIColor.color(data: colorData)
        }
        
        let plan = Plan(
            address: self.address ?? "",
            memo: self.memo ?? "",
            oneLineMemo: self.oneLineMemo ?? "",
            pinColor: color,
            title: self.title ,
            coordinate: Coordinate(latitude: self.coordinate?.latitude ?? 0, longitude: self.coordinate?.longitude ?? 0),
            displayOrder: self.displayOrder,
            identifier: self.identifier
        )

        return plan
    }
}
