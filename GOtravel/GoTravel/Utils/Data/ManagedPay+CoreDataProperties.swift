//
//  ManagedPay+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData

struct Pay {
    internal init(exchangeName: String? = nil, krWon: Float, name: String) {
        self.exchangeName = exchangeName
        self.krWon = krWon
        self.name = name
    }

    var exchangeName: String?
    var krWon: Float
    var name: String?
}

extension Pay {
    func toManaged(context: NSManagedObjectContext) -> ManagedPay {
        let managedPay = ManagedPay(context: context)
        managedPay.exchangeName = self.exchangeName
        managedPay.krWon = self.krWon
        managedPay.name = self.name
        return managedPay
    }
}

extension ManagedPay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPay> {
        return NSFetchRequest<ManagedPay>(entityName: "Pay")
    }

    @NSManaged public var exchangeName: String?
    @NSManaged public var krWon: Float
    @NSManaged public var name: String?
    @NSManaged public var ofTrip: ManagedTrip?

}
