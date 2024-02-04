//
//  CoreDataManager.swift
//  News
//
//  Created by Ismailov Farrukh on 14/11/23.
//

import UIKit
import CoreData

protocol CoreDataManagerType {
    func saveEntity<Entity: ConvertibleToEntity>(_ entityClass: Entity, completion: @escaping (Result<Void, CoreDataError>) -> Void)
    func deleteEntity<Entity: ConvertibleToEntity>(_ entityClass: Entity, completion: @escaping (Result<Void, CoreDataError>) -> Void)
    func deleteAllBookmarks(completion: @escaping (Result<Void, CoreDataError>) -> Void)
    func fetchEntities<Entity: NSManagedObject>(_ entityClass: Entity.Type, predicate: NSPredicate?, completion: @escaping (Result<[Entity], CoreDataError>) -> Void)
    func doesEntityExist<Entity: NSManagedObject>(_ entityClass: Entity.Type, withTitle title: String, completion: @escaping (Bool) -> Void)
}

final class CoreDataManager: CoreDataManagerType {
    private let persistentContainer: NSPersistentContainer
    private let viewContext: NSManagedObjectContext
    private let privateContext: NSManagedObjectContext

    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    init(containerName: String) {
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        viewContext = persistentContainer.viewContext

        // private queue declaration
        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = viewContext
    }

    //MARK: - Saving
    func saveEntity<Entity: ConvertibleToEntity>(_ entityClass: Entity, completion: @escaping (Result<Void, CoreDataError>) -> Void) {

        operationQueue.addOperation {
            let context = self.privateContext

            context.perform {
                do {
                    let _ = entityClass.toEntity(context: context)
                    try context.save()
                    context.perform {
                        do {
                            try self.viewContext.save()
                            completion(.success(()))
                        } catch {
                            completion(.failure(.saveFailed(error)))
                        }
                    }
                } catch {
                    completion(.failure(.saveFailed(error)))
                }
            }
        }
    }

    //MARK: - Removing
    func deleteEntity<Entity: ConvertibleToEntity>(_ entityClass: Entity, completion: @escaping (Result<Void, CoreDataError>) -> Void) {

        operationQueue.addOperation {
            let context = self.privateContext

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
                            completion(.failure(.deleteFailed(error)))
                        }
                    }
                } catch {
                    completion(.failure(.deleteFailed(error)))
                }
            }
        }
    }

    func deleteAllBookmarks(completion: @escaping (Result<Void, CoreDataError>) -> Void) {

        operationQueue.addOperation {
            let context = self.privateContext

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
                            completion(.failure(.deleteAllFailed(error)))
                        }
                    }
                } catch {
                    completion(.failure(.deleteAllFailed(error)))
                }
            }
        }
    }

    //MARK: - Fetching
    func fetchEntities<Entity: NSManagedObject>(_ entityClass: Entity.Type, predicate: NSPredicate? = nil, completion: @escaping (Result<[Entity], CoreDataError>) -> Void) {

        operationQueue.addOperation {
            let context = self.privateContext

            context.perform {
                let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: entityClass))
                fetchRequest.predicate = predicate

                do {
                    let storedEntities = try context.fetch(fetchRequest)
                    completion(.success(storedEntities))
                } catch {
                    completion(.failure(.fetchFailed(error)))
                }
            }
        }
    }

    //MARK: - Checking existance
    func doesEntityExist<Entity: NSManagedObject>(_ entityClass: Entity.Type, withTitle title: String, completion: @escaping (Bool) -> Void) {

        operationQueue.addOperation {
            let context = self.privateContext
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
    }

    private func fetchEntity<Entity: NSManagedObject>(ofType entityClass: Entity.Type, predicate: NSPredicate?, in context: NSManagedObjectContext) throws -> Entity? {
        let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: entityClass))
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
}

