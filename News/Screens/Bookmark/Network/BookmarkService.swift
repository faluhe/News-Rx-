//
//  BookmarkService.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import Foundation
import RxSwift

protocol BookmarkServiceType {
    func getBookmarks() -> Observable<[NewsSectionModel]>
}

final class BookmarkService: BookmarkServiceType {

    private let network: BookmarkNetworkType

    init(_ network: BookmarkNetworkType) {
        self.network = network
    }

    func getBookmarks() -> Observable<[NewsSectionModel]> {
        return network.getBookmarks().asObservable()
    }
}

