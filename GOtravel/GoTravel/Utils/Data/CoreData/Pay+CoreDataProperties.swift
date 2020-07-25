//
//  Pay+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData


extension Pay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pay> {
        return NSFetchRequest<Pay>(entityName: "Pay")
    }

    @NSManaged public var name: String?
    @NSManaged public var exchangeName: String?
    @NSManaged public var krWon: Float
    @NSManaged public var ofTrip: Trip?

}
