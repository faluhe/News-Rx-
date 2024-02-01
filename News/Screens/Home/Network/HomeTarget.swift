//
//  HomeTarget.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation

enum HomeTarget: NetworkTargetType {

    case getNews

    var path: String {
        switch self {
        case .getNews:
            return Constants.baseURL + Constants.endpoint + Constants.apiKey
        }
    }

    var parameters: Codable? {
        switch self {
        case .getNews:
            return nil
        }
    }

    var requestMethod: RequestMethod {
        switch self {
        case .getNews:
            return .get
        }
    }

    var allHeaders: [String : String]? {
        switch self {
        case .getNews:
            return nil
        }
    }
}


