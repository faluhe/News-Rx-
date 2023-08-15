//
//  HomeService.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation
import RxSwift


protocol HomeNetworkServiceType {
    func getNews() -> Observable<News>
}


final class HomeNetworkService: HomeNetworkServiceType {

    private let network: HomeNetworkType

    init(network: HomeNetworkType) {
        self.network = network
    }

    func getNews() -> Observable<News> {
        return network.getNews().asObservable()
    }


}
