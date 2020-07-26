//
//  ManagedPay+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/26.
//
//

import Foundation
import CoreData

struct Pay {
    internal init(
        exchangeName: String? = nil,
        krWon: Float,
        name: String? = nil,
        displayOrder: Int16,
        identifier: UUID,
        category: String
    ) {
        self.exchangeName = exchangeName
        self.krWon = krWon
        self.name = name
        self.displayOrder = displayOrder
        self.identifier = identifier
        self.category = category
    }

    var exchangeName: String?
    var krWon: Float
    var name: String?
    var displayOrder: Int16
    var identifier: UUID
    var category: String
}

extension Pay {
    func toManaged(context: NSManagedObjectContext) -> ManagedPay {
        let managedPay = ManagedPay(context: context)
        managedPay.exchangeName = self.exchangeName
        managedPay.krWon = self.krWon
        managedPay.name = self.name ?? ""
        managedPay.identifier = self.identifier
        managedPay.category = category
        managedPay.displayOrder = displayOrder
        return managedPay
    }
}

extension ManagedPay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPay> {
        return NSFetchRequest<ManagedPay>(entityName: "Pay")
    }

    @NSManaged public var exchangeName: String?
    @NSManaged public var krWon: Float
    @NSManaged public var name: String
    @NSManaged public var category: String
    @NSManaged public var displayOrder: Int16
    @NSManaged public var identifier: UUID
    @NSManaged public var ofPayByDays: ManagedPayByDays?

}


extension ManagedPay {
    func toPay() -> Pay {
        Pay(
            exchangeName: self.exchangeName,
            krWon: self.krWon,
            name: self.name,
            displayOrder: self.displayOrder,
            identifier: self.identifier,
            category: category
        )
    }
}
