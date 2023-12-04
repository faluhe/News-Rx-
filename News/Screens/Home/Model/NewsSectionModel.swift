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

// Extension to convert Article to NewsSectionModel
extension Article {
    func toNewsSectionModel() -> NewsSectionModel {
        return NewsSectionModel(
            title: title ?? "",
            imageURL: urlToImage ?? "",
            description: description ?? "",
            url: url ?? ""
        )
    }
}
 
