//
//  ResponseError.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation

enum ResponseError: Error {
    case noData
    case unknownData
    case parsingError
}

enum NetworkError: Error {
    case invalidURL
    case networkError
}

enum CoreDataError: Error {
    case noStoredData
    case saveFailed(Error)
    case deleteFailed(Error)
    case deleteAllFailed(Error)
    case fetchFailed(Error)
}
