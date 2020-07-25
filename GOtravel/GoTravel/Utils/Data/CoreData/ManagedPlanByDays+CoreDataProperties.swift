//
//  ManagedPlanByDays+CoreDataProperties.swift
//  
//
//  Created by LEE HAEUN on 2020/07/25.
//
//

import Foundation
import CoreData

struct PlanByDays {
    internal init(day: Int, plans: [Plan]) {
        self.day = day
        self.plans = plans
    }
    var day: Int
    var plans: [Plan]
}

extension PlanByDays {
    func toManaged(context: NSManagedObjectContext) -> ManagedPlanByDays {
        let managedPlanByDays = ManagedPlanByDays(context: context)
        managedPlanByDays.day = Int16(self.day)
        managedPlanByDays.plans = NSSet(array: self.plans.map({ (plan) -> ManagedPlan in
            plan.toManaged(context: context)
        }))
        return managedPlanByDays
    }
}

extension ManagedPlanByDays {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPlanByDays> {
        return NSFetchRequest<ManagedPlanByDays>(entityName: "PlanByDays")
    }

    @NSManaged public var day: Int16
    @NSManaged public var plans: NSSet?
    @NSManaged public var ofTrip: ManagedTrip?

}

extension ManagedPlanByDays {
    func toPlanByDays() -> PlanByDays {
        var plans = [Plan]()
        if let currentPlans = self.plans, let currentPlanArr = Array(currentPlans) as? [ManagedPlan] {
            plans = currentPlanArr.map({ (managedPlan) -> Plan in
                managedPlan.toPlan()
            })
        }
        plans.sort {
            $0.displayOrder < $1.displayOrder
        }
        return PlanByDays(day: Int(self.day), plans: plans)
    }
}

// MARK: Generated accessors for plans
extension ManagedPlanByDays {

    @objc(addPlansObject:)
    @NSManaged public func addToPlans(_ value: ManagedPlan)

    @objc(removePlansObject:)
    @NSManaged public func removeFromPlans(_ value: ManagedPlan)

    @objc(addPlans:)
    @NSManaged public func addToPlans(_ values: NSSet)

    @objc(removePlans:)
    @NSManaged public func removeFromPlans(_ values: NSSet)

}
