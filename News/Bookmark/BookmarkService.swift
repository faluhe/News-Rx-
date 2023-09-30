//
//  BookmarkService.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import Foundation
import RxSwift

protocol BookmarkServiceType {
    func getBookmarks() -> Single<NewsSectionModel>
}

final class BookmarkService: BookmarkServiceType {

//    private let network: BookmarkNetworkType
    private let dataBase: CoreDataManagerType

    init(_ dataBase: CoreDataManagerType) {
//        self.network = network
        self.dataBase = dataBase
    }

    func getBookmarks() -> Single<NewsSectionModel> {
        return Single.create { [unowned self] single in
            let result: Result<BookmarkEntity, Error> = dataBase.getStoredEntity(BookmarkEntity())

            switch result {
            case let .success(newsEntity):
                let model = NewsSectionModel(title: newsEntity.title ?? "", imageURL: newsEntity.urlToImage, description: newsEntity.desc, url: newsEntity.url)
                single(.success(model))
            case let .failure(error):
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


}
