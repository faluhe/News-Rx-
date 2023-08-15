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
}


enum NetworkError: Error {
    case invalidURL
}
