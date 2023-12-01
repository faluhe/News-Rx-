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

    //MARK: - Saving and updating
    func saveEntity<T: ConvertibleToEntity>(_ entity: T) {
        let context = viewContext

        do {
            if let existingEntity = try fetchEntity(ofType: T.ManagedObjectType.self, predicate: nil, in: context) {
                print("Entity already exists. Deleting.")
            }

            let newEntity = entity.toEntity(context: context)
            try context.save()
        } catch {
            print("Error managing entity: \(error)")
        }
    }

    //MARK: - Removing
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

    //MARK: - Fetching
    func fetchEntities<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate? = nil) -> Result<[T], Error> {
        let context = viewContext

        do {
            let fetchRequest = makeFetchRequest(for: entityClass, with: predicate)
            let storedEntities = try context.fetch(fetchRequest)
            print("Fetched entities: \(storedEntities.first?.objectID)")
            return .success(storedEntities)
        } catch {
            return .failure(error)
        }
    }

    //MARK: - Checking existance
    func doesEntityExist<T: NSManagedObject>(_ entityClass: T.Type, withTitle title: String) -> Bool {
        let context = viewContext

        let predicate = NSPredicate(format: "title == %@", title)
        return (try? fetchEntity(ofType: entityClass, predicate: predicate, in: context)) != nil
    }

    private func fetchEntity<T: NSManagedObject>(ofType type: T.Type, predicate: NSPredicate?, in context: NSManagedObjectContext) throws -> T? {
        let fetchRequest: NSFetchRequest<T> = makeFetchRequest(for: type)
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }

    private func makeFetchRequest<T: NSManagedObject>(for entityClass: T.Type, with predicate: NSPredicate? = nil) -> NSFetchRequest<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}
