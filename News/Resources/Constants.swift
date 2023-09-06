//
//  Constants.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import UIKit

struct K {
    static let baseURL = "https://newsapi.org"
    static let endpoint = "/v2/top-headlines?country=us&apiKey="
    static let apiKey = "4e8632ddb68d4ad2a6aa8047d87256d8"

    static let bookmark = "Bookmark"
    static let home = "Home"

}


enum Images: String {
    case home = "newspaper.fill"
    case bookmarkFill = "bookmark.fill"
    case bookmarkEmpty = "bookmark"
    case newspaper = "newspaper"


    // MARK: - Property
    var image: UIImage? {
        UIImage(named: rawValue)
    }

    var systemImage: UIImage? {
        UIImage(systemName: rawValue)
    }
}
