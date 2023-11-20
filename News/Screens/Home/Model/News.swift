//
//  News.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation

// MARK: - News
struct NewsDTO: Codable {
    let status: String?
    let totalResults: Double?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}




struct News {
    var status: String? = nil
    var totalResults: Double? = nil
    var articles: [Article]?

    init(status: String? = nil, totalResults: Double? = nil, articles: [Article]? = nil) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

