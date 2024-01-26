//
//  HomeTarget.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation

enum HomeTarget: NetworkTargetType {

    case getNews
    case test

    var path: String {
        switch self {
        case .getNews:
            return K.baseURL + K.endpoint + K.apiKey
        case .test:
            return "https://rickandmortyapi.com/api/character"
        }
    }

    var parameters: Codable? {
        switch self {
        case .getNews:
            return nil
        case .test:
            return nil
        }
    }

    var requestMethod: RequestMethod {
        switch self {
        case .getNews:
            return .get
        case .test:
            return .get
        }
    }

    var allHeaders: [String : String]? {
        switch self {
        case .getNews:
            return nil
        case .test:
            return nil
        }
    }
}


