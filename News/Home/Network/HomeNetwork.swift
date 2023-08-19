//
//  HomeNetwork.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation
import RxSwift

protocol HomeNetworkType {
    func getNews() -> Single<News>
}

final class HomeNetwork: HomeNetworkType {

    private let dispatcher: DatabaseDispatcherType

    init(_ dispatcher: DatabaseDispatcherType) {
        self.dispatcher = dispatcher
    }


    func getNews() -> Single<News> {
        let target: HomeTarget = .getNews
        return dispatcher.request(target, type: NewsDTO.self).map { elements in
            News(status: elements.status, totalResults: elements.totalResults, articles: elements.articles)
        }
    }


}

