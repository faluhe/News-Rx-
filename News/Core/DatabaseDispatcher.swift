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
    func saveNews(_ news: News)
    func getStoredNews() -> Result<News, Error>
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

    func saveNews(_ news: News) {
        let context = persistentContainer.viewContext

        let newsEntity = NewsEntity(context: context)
        newsEntity.status = news.status
        newsEntity.totalResults = news.totalResults ?? 0

        if let articles = news.articles {
            let articleEntities = articles.map { article in
                let articleEntity = ArticlesEntity(context: context)
                articleEntity.title = article.title
                articleEntity.descript = article.description
                articleEntity.imgUrl = article.urlToImage
                articleEntity.url = article.url

                let sourceEntity = SourcesEntity(context: context)
                sourceEntity.name = article.source?.name
                sourceEntity.id = article.source?.id
                articleEntity.source = sourceEntity

                return articleEntity
            }
            newsEntity.articles = NSOrderedSet(array: articleEntities)
        }

        do {
            try context.save()
        } catch {
            print("Failed to save news to Core Data: \(error)")
        }
    }

    func getStoredNews() -> Result<News, Error> {
        let context = persistentContainer.viewContext

        do {
            let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
            let storedNewsEntities = try context.fetch(fetchRequest)

            if let storedNewsEntity = storedNewsEntities.first {
                print(storedNewsEntity)
                let news = News(
                    status: storedNewsEntity.status ?? "",
                    totalResults: storedNewsEntity.totalResults,
                    articles: storedNewsEntity.articles?.compactMap { ($0 as? ArticlesEntity)?.toModel() }
                )
                return .success(news)
            } else {
                return .failure(CoreDataError.noStoredData)
            }
        } catch {
            return .failure(error)
        }
    }
}
