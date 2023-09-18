//
//  HomeService.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation
import RxSwift


protocol HomeServiceType {
    func getNews() -> Observable<News>
    func getStoredNews() -> Observable<News>
}

final class HomeService: HomeServiceType {

    private let network: HomeNetworkType
    private let dataBase: CoreDataManagerType

    init(_ network: HomeNetworkType, dataBase: CoreDataManagerType) {
        self.network = network
        self.dataBase = dataBase
    }

    func getNews() -> Observable<News> {
        return network.getNews().asObservable()
    }

    func getStoredNews() -> Observable<News> {
        return Observable.create { [unowned self] observer in
            let result = self.dataBase.getStoredNews()
            switch result {
            case let .success(news):
                observer.onNext(news)
                observer.onCompleted()
            case let .failure(error):
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
