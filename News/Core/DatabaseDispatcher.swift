//
//  DatabaseDispatcher.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//
import RxSwift
import Foundation
import CoreData

protocol DatabaseDispatcherType {
    func request<T: Codable>(_ target: NetworkTargetType, type: T.Type) -> Single<T>
}

final class DatabaseDispatcher: DatabaseDispatcherType {
    
    func request<T>(_ target: NetworkTargetType, type: T.Type) -> RxSwift.Single<T> where T : Decodable, T : Encodable {
        return Single.create { [unowned self] single in
            switch target.requestMethod {
            case .get:
                getNews(target, type: type) { result in
                    single(result ?? .failure(ResponseError.unknownData))
                }
            }
            return Disposables.create()
        }
    }


    func getNews<T: Codable>(_ target: NetworkTargetType, type: T.Type, completion: @escaping (Result<T, Error>?) -> Void) {
        guard let url = URL(string: target.path) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(ResponseError.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}



protocol CoreDataManagerType {
    func saveEntity<T: ConvertibleToEntity>(_ entity: T)
    func deleteEntity<T: ConvertibleToEntity>(_ entity: T)
    func fetchEntities<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?) -> Result<[T], Error>
    func doesEntityExist<T: NSManagedObject>(_ entityClass: T.Type, withTitle title: String) -> Bool
}

protocol ConvertibleToEntity {
    associatedtype ManagedObjectType: NSManagedObject
    func toEntity(context: NSManagedObjectContext) -> ManagedObjectType
}

protocol TransferToBookmarkEntity {
    func toBookmark() -> BookmarkEntity
}

extension Article: ConvertibleToEntity {
    typealias EntityType = ArticlesEntity

    func toEntity(context: NSManagedObjectContext) -> ArticlesEntity {
        // Implement conversion logic from Article to ArticlesEntity
        let articlesEntity = ArticlesEntity(context: context)
        articlesEntity.title = self.title
        articlesEntity.descript = self.description
        articlesEntity.imgUrl = self.urlToImage
        articlesEntity.url = self.url

        if let source = self.source {
            let sourceEntity = SourcesEntity(context: context)
            sourceEntity.name = source.name
            sourceEntity.id = source.id
            articlesEntity.source = sourceEntity
        }
        return articlesEntity
    }
}

extension News: ConvertibleToEntity {
    typealias EntityType = NewsEntity

    func toEntity(context: NSManagedObjectContext) -> NewsEntity {
        // Implement conversion logic from News to NewsEntity
        let newsEntity = NewsEntity(context: context)
        newsEntity.status = self.status
        newsEntity.totalResults = self.totalResults ?? 0

        if let articles = self.articles {
            let articleEntities = articles.map { article in
                return article.toEntity(context: context)
            }
            newsEntity.articles = NSOrderedSet(array: articleEntities)
        }

        return newsEntity
    }
}


extension NewsSectionModel: ConvertibleToEntity {
    typealias EntityType = BookmarkEntity

    func toEntity(context: NSManagedObjectContext) -> BookmarkEntity {
        let existingEntity = self.existingEntity(in: context)

        if let existingEntity = existingEntity {
            // If the entity already exists, update its properties
            existingEntity.title = self.title
            existingEntity.desc = self.description
            existingEntity.url = self.url
            existingEntity.urlToImage = self.imageURL
            return existingEntity
        } else {
            // If the entity doesn't exist, create a new one
            let bookmarkEntity = BookmarkEntity(context: context)
            bookmarkEntity.title = self.title
            bookmarkEntity.desc = self.description
            bookmarkEntity.url = self.url
            bookmarkEntity.urlToImage = self.imageURL
            return bookmarkEntity
        }
    }

    private func existingEntity(in context: NSManagedObjectContext) -> BookmarkEntity? {
        let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", self.title)

        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching existing entity: \(error)")
            return nil
        }
    }
}




// Refactored CoreDataManager implementation
class CoreDataManager: CoreDataManagerType {
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
