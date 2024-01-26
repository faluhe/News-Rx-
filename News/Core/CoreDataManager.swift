//
//  CoreDataManager.swift
//  News
//
//  Created by Ismailov Farrukh on 14/11/23.
//

import UIKit
import CoreData

protocol CoreDataManagerType {
    func saveEntity<T: ConvertibleToEntity>(_ entity: T) throws
    func deleteEntity<T: ConvertibleToEntity>(_ entity: T) throws
    func fetchEntities<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?) -> Result<[T], Error>
    func doesEntityExist<T: NSManagedObject>(_ entityClass: T.Type, withTitle title: String) -> Bool
    func deleteAllBookmarks() throws
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
    /// Даний метод краще зробити throwable, щоб розуміти коли в тебе відбулась помилка і потім якось відігратись для юзера, бо в такому випадку
    /// ти робиш save, і не знаєш чи дійсно в тебе засейвилось щось у базу, як приклад можна помилку прокинути в аналітику і бачити
    /// що щось в цьому моменті йде не так, це стосується й інших методів
    /// і ще в тут треба створити окрему чергу яка буде писати, і окрему для читання, бо якщо користувач цієї штуки намутить із багатопоточністю
    /// то в тебе будуть проблеми
    func saveEntity<T: ConvertibleToEntity>(_ entityClass: T) throws {
        let context = viewContext
        let newEntity = entityClass.toEntity(context: context)

        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed(error)
        }
    }

    //MARK: - Removing
    func deleteEntity<T: ConvertibleToEntity>(_ entityClass: T) throws {
        let context = viewContext
        let existingEntity = entityClass.toEntity(context: context)
        context.delete(existingEntity)

        do {
            try context.save()
        } catch {
            throw CoreDataError.deleteFailed(error)
        }
    }

    func deleteAllBookmarks() throws {
        let context = viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookmarkEntity.fetchRequest()

        do {
            let result = try context.fetch(fetchRequest)
            for case let bookmark as NSManagedObject in result {
                context.delete(bookmark)
            }
            try context.save()
        } catch {
            throw CoreDataError.deleteAllFailed(error)
        }
    }



    //MARK: - Fetching
    func fetchEntities<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate? = nil) -> Result<[T], Error>  {
        let context = viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))

        do {
            let storedEntities = try context.fetch(fetchRequest)
            return .success(storedEntities)
        } catch {
            return .failure(CoreDataError.fetchFailed(error))
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
