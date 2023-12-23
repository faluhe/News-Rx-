//
//  Constants.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import UIKit

//MARK: - Constants
struct K {
    static let baseURL = "https://newsapi.org"
    static let endpoint = "/v2/top-headlines?country=us&apiKey="
    static let apiKey = "4e8632ddb68d4ad2a6aa8047d87256d8"
}

struct ScreenNames {
    static let bookmark = "Bookmark"
    static let home = "Home"
}

struct HomeScreen {
    static let news = "News"
    static let save = "Save"
    static let unsave = "Unsave"
    static let share = "Share"
}

struct BookmarkScreen {
    static let deleteBookmark = "Delete Bookmark"
    static let areYouSureToDelete = "Are you sure you want to delete this bookmark?"
    static let cancel = "Cancel"
    static let delete = "Delete"
    static let bookmarks = "Bookmarks"
}


//MARK: - Images
enum Images: String {
    case home = "newspaper.fill"
    case bookmarkFill = "bookmark.fill"
    case bookmarkEmpty = "bookmark"
    case newspaper = "newspaper"
    case share = "square.and.arrow.up"
    case noImage = "xmark.app.fill"
    case noDataInBookmarks = "NoDataInBookmarks"


    // MARK: - Properties
    var image: UIImage? {
        UIImage(named: rawValue)
    }

    var systemImage: UIImage? {
        UIImage(systemName: rawValue)
    }
}
