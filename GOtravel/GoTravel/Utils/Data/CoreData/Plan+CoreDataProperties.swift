//
//  Plan+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var title: String?
    @NSManaged public var address: String?
    @NSManaged public var pinColor: NSObject?
    @NSManaged public var memo: String?
    @NSManaged public var oneLineMemo: String?
    @NSManaged public var coordinate: Coordinate?
    @NSManaged public var ofTrip: Trip?

}
