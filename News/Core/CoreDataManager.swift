//
//  CoreDataManager.swift
//  News
//
//  Created by Ismailov Farrukh on 14/11/23.
//

import UIKit
import CoreData

protocol CoreDataManagerType {
    func saveEntity<T: ConvertibleToEntity>(_ entityClass: T)
    func deleteEntity<T: ConvertibleToEntity>(_ entityClass: T)
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
    func saveEntity<T: ConvertibleToEntity>(_ entityClass: T) {
        let context = viewContext

        do {
            let newEntity = entityClass.toEntity(context: context)
            try context.save()
        } catch {
            print("Error managing entity: \(error)")
        }
    }

    //MARK: - Removing
    func deleteEntity<T: ConvertibleToEntity>(_ entityClass: T) {
        let context = viewContext
        let existingEntity = entityClass.toEntity(context: context)
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
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
            let storedEntities = try context.fetch(fetchRequest)
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

    private func fetchEntity<T: NSManagedObject>(ofType entityClass: T.Type, predicate: NSPredicate?, in context: NSManagedObjectContext) throws -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
}
