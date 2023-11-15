//
//  CoreDataManager.swift
//  News
//
//  Created by Ismailov Farrukh on 14/11/23.
//

import UIKit
import CoreData

protocol CoreDataManagerType {
    func saveEntity<T: ConvertibleToEntity>(_ entity: T)
    func deleteEntity<T: ConvertibleToEntity>(_ entity: T)
    func fetchEntities<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?) -> Result<[T], Error>
    func doesEntityExist<T: NSManagedObject>(_ entityClass: T.Type, withTitle title: String) -> Bool
}

final class CoreDataManager: CoreDataManagerType {
    let persistentContainer: NSPersistentContainer
    let viewContext: NSManagedObjectContext

    init(containerName: String) {
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        viewContext = persistentContainer.viewContext
    }

    func saveEntity<T: ConvertibleToEntity>(_ entity: T) {
        let context = viewContext
        let i = entity.toEntity(context: context)

        do {
            try context.save()
        } catch {
            print("Failed to save entity to Core Data: \(error)")
        }
    }

    func deleteEntity<T: ConvertibleToEntity>(_ entity: T) {
        let context = viewContext

        let existingEntity = entity.toEntity(context: context)
        context.delete(existingEntity)
        do {
            try context.save()
        } catch {
            print("Failed to delete entity from Core Data: \(error)")
        }
    }

    func fetchEntities<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate? = nil) -> Result<[T], Error> {
        let context = viewContext

        do {
            let fetchRequest = makeFetchRequest(for: entityClass, with: predicate)
            let storedEntities = try context.fetch(fetchRequest)

            if !storedEntities.isEmpty {
                return .success(storedEntities)
            } else {
                return .failure(CoreDataError.noStoredData)
            }
        } catch {
            return .failure(error)
        }
    }

    func doesEntityExist<T: NSManagedObject>(_ entityClass: T.Type, withTitle title: String) -> Bool {
        let context = viewContext

        let fetchRequest: NSFetchRequest<T> = makeFetchRequest(for: entityClass, with: NSPredicate(format: "title == %@", title))

        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error fetching entity: \(error)")
            return false
        }
    }

    private func makeFetchRequest<T: NSManagedObject>(for entityClass: T.Type, with predicate: NSPredicate? = nil) -> NSFetchRequest<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}
//
