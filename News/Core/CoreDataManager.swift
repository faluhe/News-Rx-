//
//  CoreDataManager.swift
//  News
//
//  Created by Ismailov Farrukh on 14/11/23.
//

import UIKit
import CoreData

protocol CoreDataManagerType {
    func saveEntity<T: ConvertibleToEntity>(_ entityClass: T, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteEntity<T: ConvertibleToEntity>(_ entityClass: T, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteAllBookmarks(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchEntities<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], Error>) -> Void)
    func doesEntityExist<T: NSManagedObject>(_ entityClass: T.Type, withTitle title: String, completion: @escaping (Bool) -> Void)
}

final class CoreDataManager: CoreDataManagerType {

    let persistentContainer: NSPersistentContainer
    let viewContext: NSManagedObjectContext
    let privateContext: NSManagedObjectContext

    init(containerName: String) {
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        viewContext = persistentContainer.viewContext

        //private queue declaration
        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = viewContext
    }

    func saveEntity<T: ConvertibleToEntity>(_ entityClass: T, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = privateContext

        context.perform {
            do {
                let _ = entityClass.toEntity(context: context)
                try context.save()
                context.perform {
                    do {
                        try self.viewContext.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(CoreDataError.saveFailed(error)))
                    }
                }
            } catch {
                completion(.failure(CoreDataError.saveFailed(error)))
            }
        }
    }

    //MARK: - Removing
    func deleteEntity<T: ConvertibleToEntity>(_ entityClass: T, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = privateContext

        context.perform {
            do {
                let existingEntity = entityClass.toEntity(context: context)
                context.delete(existingEntity)
                try context.save()

                context.perform {
                    do {
                        try self.viewContext.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(CoreDataError.deleteFailed(error)))
                    }
                }
            } catch {
                completion(.failure(CoreDataError.deleteFailed(error)))
            }
        }
    }

    func deleteAllBookmarks(completion: @escaping (Result<Void, Error>) -> Void) {
        let context = privateContext

        context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookmarkEntity.fetchRequest()

            do {
                let result = try context.fetch(fetchRequest)
                for case let bookmark as NSManagedObject in result {
                    context.delete(bookmark)
                }
                try context.save()

                context.perform {
                    do {
                        try self.viewContext.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(CoreDataError.deleteAllFailed(error)))
                    }
                }
            } catch {
                completion(.failure(CoreDataError.deleteAllFailed(error)))
            }
        }
    }


    //MARK: - Fetching
    func fetchEntities<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        let context = privateContext

        context.perform {
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
            fetchRequest.predicate = predicate

            do {
                let storedEntities = try context.fetch(fetchRequest)
                print(storedEntities)
                completion(.success(storedEntities))
            } catch {
                completion(.failure(CoreDataError.fetchFailed(error)))
            }
        }
    }

    //MARK: - Checking existance
    func doesEntityExist<T: NSManagedObject>(_ entityClass: T.Type, withTitle title: String, completion: @escaping (Bool) -> Void) {
        let context = privateContext
        let predicate = NSPredicate(format: "title == %@", title)

        context.perform {
            do {
                let result = try self.fetchEntity(ofType: entityClass, predicate: predicate, in: context)
                completion(result != nil)
            } catch {
                completion(false)
            }
        }
    }

    private func fetchEntity<T: NSManagedObject>(ofType entityClass: T.Type, predicate: NSPredicate?, in context: NSManagedObjectContext) throws -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
}
