//
//  NewsSectionModel.swift
//  News
//
//  Created by Ismailov Farrukh on 16/08/23.
//

import Foundation

struct NewsSectionModel: Hashable {
    let title: String
    let imageURL: String?
    let description: String?
    let url: String?
}

// Extension to convert Article to NewsModel
extension Article {
    func toViewModel() -> NewsSectionModel {
        return NewsSectionModel(
            title: title ?? "",
            imageURL: urlToImage ?? "",
            description: description ?? "",
            url: url ?? ""
        )
    }
}

extension ArticlesEntity {
    func toModel() -> Article {
        return Article(source: Source(id: source?.id, name: source?.name),
                       author: self.author,
                       title: self.title,
                       description: self.descript,
                       url: self.url,
                       urlToImage: self.imgUrl,
                       content: self.content)
    }
}
