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


//protocol CoreDataManagerType {
//    func saveNews(_ news: News)
//    func getStoredNews() -> Result<News, Error>
//}
//
//class CoreDataManager: CoreDataManagerType {
//    let persistentContainer: NSPersistentContainer
//
//    init(containerName: String) {
//        persistentContainer = NSPersistentContainer(name: containerName)
//        persistentContainer.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("Unable to load persistent stores: \(error)")
//            }
//        }
//    }
//
//    func saveNews(_ news: News) {
//        let context = persistentContainer.viewContext
//
//        let newsEntity = NewsEntity(context: context)
//        newsEntity.status = news.status
//        newsEntity.totalResults = news.totalResults ?? 0
//
//        if let articles = news.articles {
//            let articleEntities = articles.map { article in
//                return createArticleEntity(from: article, context: context)
//            }
//            newsEntity.articles = NSOrderedSet(array: articleEntities)
//        }
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save news to Core Data: \(error)")
//        }
//    }
//
//    func saveArticleToBookmark(_ news: News) {
//        let context = persistentContainer.viewContext
//
//        let bookmarkEntity = BookmarkEntity(context: context)
//
//        if let articles = news.articles {
//            let articleEntities = articles.map { article in
//                return createArticleEntity(from: article, context: context)
//            }
//            bookmarkEntity.articles = NSOrderedSet(array: articleEntities)
//        }
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save news to Core Data: \(error)")
//        }
//    }
//
//    func createArticleEntity(from article: Article, context: NSManagedObjectContext) -> ArticlesEntity {
//        let articleEntity = ArticlesEntity(context: context)
//        articleEntity.title = article.title
//        articleEntity.descript = article.description
//        articleEntity.imgUrl = article.urlToImage
//        articleEntity.url = article.url
//
//        let sourceEntity = SourcesEntity(context: context)
//        sourceEntity.name = article.source?.name
//        sourceEntity.id = article.source?.id
//        articleEntity.source = sourceEntity
//
//        return articleEntity
//    }
//
//    func getStoredNews() -> Result<News, Error> {
//        let context = persistentContainer.viewContext
//
//        do {
//            let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
//            let storedNewsEntities = try context.fetch(fetchRequest)
//
//            if let storedNewsEntity = storedNewsEntities.first {
//                print(storedNewsEntity)
//                let news = News(
//                    status: storedNewsEntity.status ?? "",
//                    totalResults: storedNewsEntity.totalResults,
//                    articles: storedNewsEntity.articles?.compactMap { ($0 as? ArticlesEntity)?.toModel() }
//                )
//                return .success(news)
//            } else {
//                return .failure(CoreDataError.noStoredData)
//            }
//        } catch {
//            return .failure(error)
//        }
//    }
//
//    func getBookmarkNews() -> Result<News, Error> {
//        let context = persistentContainer.viewContext
//
//        do {
//            let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
//            let storedNewsEntities = try context.fetch(fetchRequest)
//
//            if let storedNewsEntity = storedNewsEntities.first {
//                print(storedNewsEntity)
//                let news = News(
//                    articles: storedNewsEntity.articles?.compactMap { ($0 as? ArticlesEntity)?.toModel() }
//                )
//                return .success(news)
//            } else {
//                return .failure(CoreDataError.noStoredData)
//            }
//        } catch {
//            return .failure(error)
//        }
//    }
//}
protocol CoreDataManagerType {
    func saveEntity<T: ConvertibleToEntity>(_ entity: T)
    func getStoredEntities<T: NSManagedObject>(_ entityClass: T.Type) -> Result<[T], Error>
}

protocol ConvertibleToEntity {
    associatedtype ManagedObjectType: NSManagedObject
    func toEntity(context: NSManagedObjectContext) -> ManagedObjectType
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

        let bookmarkEntity = BookmarkEntity(context: context)
        bookmarkEntity.title = self.title
        bookmarkEntity.desc = self.description
        bookmarkEntity.url = self.url
        bookmarkEntity.urlToImage = self.imageURL

        return bookmarkEntity
    }



}


class CoreDataManager: CoreDataManagerType {
    let persistentContainer: NSPersistentContainer

    init(containerName: String) {
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    func saveEntity<T: ConvertibleToEntity>(_ entity: T) {
        let context = persistentContainer.viewContext
        let _ = entity.toEntity(context: context)

        do {
            try context.save()
        } catch {
            print("Failed to save entity to Core Data: \(error)")
        }
    }

    func deleteEntity<T: ConvertibleToEntity>(_ entity: T) {
        let context = persistentContainer.viewContext
        if let managedObject = entity.toEntity(context: context) as? NSManagedObject {
             print(managedObject)
                context.delete(managedObject)
            } else {
                print("Failed to convert entity to NSManagedObject")
            }

            do {
                try context.save()
            } catch {
                print("Failed to delete entity from Core Data: \(error)")
            }
    }
    

    func getStoredEntities<T: NSManagedObject>(_ entityClass: T.Type) -> Result<[T], Error> {
        let context = persistentContainer.viewContext

        do {
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
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


    func doesArticleExist(withTitle title: String) -> Bool {
        let context = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        }
        catch {
            print("Error fetching bookmark: \(error)")
            return false
        }
    }
}
