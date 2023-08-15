//
//  NetworkTargetType.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation

protocol NetworkTargetType {
    var path: String { get }
    var parameters: Codable? { get }
    var requestMethod: RequestMethod { get }
}

enum RequestMethod {
    case get
}
