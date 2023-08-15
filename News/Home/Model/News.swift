//
//  News.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import Foundation

// MARK: - News
struct NewsDTO: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author, title, description: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}


extension NewsDTO {
    init(from model: NewsDTO) {
        status = model.status
        totalResults = model.totalResults
        articles = model.articles   
    }
}






struct News {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

