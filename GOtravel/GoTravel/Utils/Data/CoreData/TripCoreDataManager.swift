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
        backgroundContext = persistentContainer.viewContext
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
        if let currentIdentifier = identifier {
            let predicate = NSPredicate(format: "identifier == %@", currentIdentifier as CVarArg)
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

    func fetchAllTrip() -> [Trip]? {
        guard let context = backgroundContext else { return nil }
        guard let fetchedTrips = fetch(identifier: nil, context: context) else {
            return nil
        }
        return fetchedTrips.map { (managedTrip) -> Trip in
            managedTrip.toTrip()
        }
    }

    func fetchTrip(identifier: UUID) -> Trip? {
        guard let context = backgroundContext else { return nil }
        guard let managedTrip = fetch(identifier: identifier, context: context)?.first else {
            return nil
        }
        return managedTrip.toTrip()
    }

    func fetchManagedTrip(identifier: UUID) -> ManagedTrip? {
        guard let context = backgroundContext else { return nil }
        guard let managedTrip = fetch(identifier: identifier, context: context)?.first else {
            return nil
        }
        return managedTrip
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

    func updateTrip(updateTrip: Trip) -> Trip? {
        guard let context = backgroundContext else { return nil }

        let identifier = updateTrip.identifier
        guard let fetchedManagedTrip = fetchManagedTrip(identifier: identifier) else {
            return nil
        }
        
        fetchedManagedTrip.country = updateTrip.country
        fetchedManagedTrip.city = updateTrip.city
        fetchedManagedTrip.date = updateTrip.date
        fetchedManagedTrip.period = Int16(updateTrip.period)
        fetchedManagedTrip.identifier = updateTrip.identifier
        fetchedManagedTrip.coordinate = updateTrip.coordinate.toManaged(context: context)
        fetchedManagedTrip.payByDays = NSSet(array:  updateTrip.payByDays.map({ (payByDays) -> ManagedPayByDays in
            payByDays.toManaged(context: context)
        }))
        fetchedManagedTrip.planByDays = NSSet(array: updateTrip.planByDays.map({ (planByDays) -> ManagedPlanByDays in
            planByDays.toManaged(context: context)
        }))

        saveContext(context: context)

        return fetchTrip(identifier: updateTrip.identifier)
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
