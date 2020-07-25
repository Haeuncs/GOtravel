//
//  ManagedCoordinate+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData

struct Coordinate {
    internal init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    var latitude: Double
    var longitude: Double

}

extension Coordinate {
    func toManaged(context: NSManagedObjectContext) -> ManagedCoordinate {
        let coordinate = ManagedCoordinate(context: context)
        coordinate.latitude = self.latitude
        coordinate.longitude = self.longitude
        return coordinate
    }
}

extension ManagedCoordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCoordinate> {
        return NSFetchRequest<ManagedCoordinate>(entityName: "Coordinate")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var ofPlan: ManagedPlan?
    @NSManaged public var ofTrip: ManagedTrip?

}
