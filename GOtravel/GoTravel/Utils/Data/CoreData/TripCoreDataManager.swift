//
//  TripCoreDataManager.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/25.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TripCoreDataManager: NSObject {
    static let shared = TripCoreDataManager()

    private(set) var viewContext: NSManagedObjectContext?
    private(set) var backgroundContext: NSManagedObjectContext?

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Trip")
        container.loadPersistentStores(completionHandler: { (_, error) in

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectDidChange(_:)),
            name: .NSManagedObjectContextObjectsDidChange,
            object: persistentContainer.viewContext
        )

        viewContext = persistentContainer.viewContext
        backgroundContext = persistentContainer.newBackgroundContext()
    }

    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        guard let backgroundContext = backgroundContext else { return }
        backgroundContext.perform {
            block(backgroundContext)
        }
    }

    func performBackgroundTaskAndWait(_ block: @escaping (NSManagedObjectContext) -> Void) {
        guard let backgroundContext = backgroundContext else { return }
        backgroundContext.performAndWait {
            block(backgroundContext)
        }
    }

    private func add(newData: Trip, context: NSManagedObjectContext) {
        _ = newData.toManaged(context: context)
    }

    func add(newData: Trip) {
        performBackgroundTaskAndWait { (context) in
            self.add(newData: newData, context: context)
            self.saveContext(context: context)
        }
    }

    private func fetch(identifier: UUID?, context: NSManagedObjectContext) -> [ManagedTrip]? {
        let fetchRequest = NSFetchRequest<ManagedTrip>(entityName: "Trip")
        if let identifier = identifier {
            let predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1
        }
        do {
            let trips = try context.fetch(fetchRequest)
            return trips
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }

    }

    func fetchAllTrip() -> [ManagedTrip]? {
        guard let context = backgroundContext else { return nil }
        return fetch(identifier: nil, context: context)
    }

    func fetchTrip(identifier: UUID) -> ManagedTrip? {
        guard let context = backgroundContext else { return nil }
        return fetch(identifier: identifier, context: context)?.first
    }

    func deleteTrip(identifier: UUID) -> Bool {
        guard let context = backgroundContext else { return false }
        guard let trips = fetch(identifier: identifier, context: context),
            trips.isEmpty == false,
            let trip = trips.first else {
                return false
        }
        context.delete(trip)
        saveContext(context: context)
        return true
    }

    func updateTrip(updateTrip: Trip) -> ManagedTrip? {
        guard let context = backgroundContext else { return nil }

        let identifier = updateTrip.identifier
        guard let fetcedManagedTrip = fetchTrip(identifier: identifier) else {
            return nil
        }
        
        fetcedManagedTrip.country = updateTrip.country
        fetcedManagedTrip.city = updateTrip.city
        fetcedManagedTrip.date = updateTrip.date
        fetcedManagedTrip.period = updateTrip.period
        fetcedManagedTrip.identifier = updateTrip.identifier
        fetcedManagedTrip.coordinate = updateTrip.coordinate.toManaged(context: context)
        var payByDays = [ManagedPay]()
        for payData in updateTrip.payByDays {
            payByDays.append(payData.toManaged(context: context))
        }
        fetcedManagedTrip.payByDays = NSSet(array: payByDays)

        var planByDays = [ManagedPlan]()
        for planData in updateTrip.planByDays {
            planByDays.append(planData.toManaged(context: context))
        }
        fetcedManagedTrip.planByDays = NSSet(array: planByDays)

        saveContext(context: context)

        return fetcedManagedTrip
    }

    func updateTrip(updateTrip: ManagedTrip) -> ManagedTrip? {
        guard let context = backgroundContext else { return nil }

        saveContext(context: context)

        return updateTrip
    }

    @objc private func contextObjectDidChange(_ notification: NSNotification) {
        NotificationCenter.default.post(name: .tripDataChange, object: self)
    }

    func reset() {
        let container = persistentContainer
        let coordinator = container.persistentStoreCoordinator
        if let store = coordinator.destroyPersistentStore(type: NSSQLiteStoreType) {
            do {
                try coordinator.addPersistentStore(
                    ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: store.url,
                    options: nil
                )
            } catch {
                print(error)
            }
        }
    }
}

extension NSPersistentStoreCoordinator {
    func destroyPersistentStore(type: String) -> NSPersistentStore? {
        guard
            let store = persistentStores.first(where: { $0.type == type }),
            let storeURL = store.url
            else {
                return nil
        }

        try? destroyPersistentStore(at: storeURL, ofType: store.type, options: nil)

        return store
    }
}
