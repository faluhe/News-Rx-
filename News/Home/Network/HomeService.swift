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
}

final class HomeService: HomeServiceType {

    private let network: HomeNetworkType

    init(_ network: HomeNetworkType) {
        self.network = network
    }

    func getNews() -> Observable<News> {
        return network.getNews().asObservable()
    }
}
