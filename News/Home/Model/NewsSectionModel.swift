//
//  NewsSectionModel.swift
//  News
//
//  Created by Ismailov Farrukh on 16/08/23.
//

import Foundation

struct NewsSectionModel {
    let title: String
    let imageURL: URL?
    let description: String?
    let publishedAt: String?
    let url: String?
}

// Extension to convert Article to NewsModel
extension Article {
    func toViewModel() -> NewsSectionModel {
        return NewsSectionModel(
            title: title ?? "",
            imageURL: URL(string: urlToImage ?? ""),
            description: description ?? "",
            publishedAt: publishedAt ?? "",
            url: url ?? ""
        )
    }
}


