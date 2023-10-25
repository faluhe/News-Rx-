//
//  BookmarkService.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import Foundation
import RxSwift

protocol BookmarkServiceType {
    func getBookmarks() -> Single<[NewsSectionModel]>
}

final class BookmarkService: BookmarkServiceType {

//    private let network: BookmarkNetworkType
    private let dataBase: CoreDataManagerType

    init(_ dataBase: CoreDataManagerType) {
//        self.network = network
        self.dataBase = dataBase
    }

    func getBookmarks() -> Single<[NewsSectionModel]> {
        return Single.create { [unowned self] single in

            let result: Result<[BookmarkEntity], Error> = dataBase.getStoredEntities(BookmarkEntity.self)

            switch result {
            case let .success(newsEntity):

                let bookmarkArticles = newsEntity.map { entity in
                    return NewsSectionModel(
                        title: entity.title ?? "",
                        imageURL: entity.urlToImage,
                        description: entity.desc,
                        url: entity.url
                    )
                }

                single(.success(bookmarkArticles))
            case let .failure(error):
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


}
