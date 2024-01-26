//
//  HomeNetwork.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation
import CoreData
import RxSwift

protocol HomeNetworkType {
    func getNews() -> Single<News>
    func getStoredNews() -> Single<News>
}

final class HomeNetwork: HomeNetworkType {

    private let dispatcher: NetworkDispatcherType
    private let dataBase: CoreDataManagerType

    init(_ dispatcher: NetworkDispatcherType, _ dataBase: CoreDataManagerType) {
        self.dispatcher = dispatcher
        self.dataBase = dataBase
    }


    /// Later will encapsulate the logic of the API of the client and the database in some kind of repository, this would make it possible not to import cordata everywhere, and use only one
    /// a method that would simply do getNews, and under the hood make an API request and store it all in the database
    func getNews() -> Single<News> {
        let target: HomeTarget = .getNews
        return dispatcher.request(target, type: NewsDTO.self).map { elements in
            let news = News(status: elements.status, totalResults: elements.totalResults, articles: elements.articles)
            return news
        }
    }

    func getStoredNews() -> Single<News> {
        return Single.create { [unowned self] single in

            let result: Result<[NewsEntity], Error> = dataBase.fetchEntities(NewsEntity.self, predicate: nil)
            switch result {
            case let .success(newsEntity):
                guard let newsEntity = newsEntity.first else { return Disposables.create() }
                let news = News(
                    status: newsEntity.status ?? " ",
                    totalResults: newsEntity.totalResults,
                    articles: newsEntity.articles?.compactMap { ($0 as? ArticlesEntity)?.toArticle() }
                )

                single(.success(news))
            case let .failure(error):
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}

