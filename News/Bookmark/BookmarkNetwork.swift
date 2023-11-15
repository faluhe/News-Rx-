//
//  BookmarkNetwork.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import Foundation
import RxSwift

protocol BookmarkNetworkType {
    func getBookmarks() -> Single<[BookmarkEntity]>
}

final class BookmarkNetwork: BookmarkNetworkType {

    private let dataBase: CoreDataManagerType

    init(_ dataBase: CoreDataManagerType) {
        self.dataBase = dataBase
    }


    func getBookmarks() -> Single<[BookmarkEntity]> {
        return Single.create { [unowned self] single in
            let result: Result<[BookmarkEntity], Error> = dataBase.fetchEntities(BookmarkEntity.self, predicate: nil)

            switch result {
            case let .success(newsEntity):
                single(.success(newsEntity))
            case let .failure(error):
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}
