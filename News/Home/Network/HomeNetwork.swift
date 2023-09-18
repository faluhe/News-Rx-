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

    private let dispatcher: DatabaseDispatcherType
    private let dataBase: CoreDataManagerType

    init(_ dispatcher: DatabaseDispatcherType, _ dataBase: CoreDataManagerType) {
        self.dispatcher = dispatcher
        self.dataBase = dataBase
    }


    func getNews() -> Single<News> {
        let target: HomeTarget = .getNews
        return dispatcher.request(target, type: NewsDTO.self).map { elements in
            let news = News(status: elements.status, totalResults: elements.totalResults, articles: elements.articles)
            self.dataBase.saveNews(news)
            return news
        }
    }

    func getStoredNews() -> Single<News> {
        return Single.create { [unowned self] single in
                let result = self.dataBase.getStoredNews()
                switch result {
                case let .success(news):
                    single(.success(news))
                case let .failure(error):
                    single(.failure(error))
                }
                return Disposables.create()
            }
    }
}

