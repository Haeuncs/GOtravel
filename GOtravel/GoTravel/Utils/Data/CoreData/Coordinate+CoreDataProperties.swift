//
//  Coordinate+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData


extension Coordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coordinate> {
        return NSFetchRequest<Coordinate>(entityName: "Coordinate")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var ofPlan: Plan?
    @NSManaged public var ofTrip: Trip?

}
