//
//  BookmarkNetwork.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import Foundation
import RxSwift

protocol BookmarkNetworkType {
    func getBookmarks() -> Single<[NewsSectionModel]>
}

final class BookmarkNetwork: BookmarkNetworkType {

    private let dataBase: CoreDataManagerType

    init(_ dataBase: CoreDataManagerType) {
        self.dataBase = dataBase
    }

    func getBookmarks() -> Single<[NewsSectionModel]> {
        return Single.create { [unowned self] single in

            dataBase.fetchEntities(BookmarkEntity.self, predicate: nil) { result in
                switch result {
                case let .success(bookmarkEntity):
                    let bookmarkArticles = bookmarkEntity.map { entity in
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
            }
            return Disposables.create()
        }
    }
}
