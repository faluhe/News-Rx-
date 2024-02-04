//
//  Constants.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//

import UIKit

//MARK: - Constants
enum Constants {
    static let baseURL = "https://newsapi.org"
    static let endpoint = "/v2/top-headlines?country=us&apiKey="
    static let apiKey = " "
}

enum ScreenNames {
    static let bookmark = "Bookmark"
    static let home = "Home"
}

enum HomeScreen {
    static let news = "News"
    static let save = "Save"
    static let unsave = "Unsave"
    static let share = "Share"
}

enum BookmarkScreen {
    static let deleteBookmark = "Delete Bookmark"
    static let areYouSureToDelete = "Are you sure you want to delete this bookmark?"
    static let cancel = "Cancel"
    static let delete = "Delete"
    static let bookmarks = "Bookmarks"
    static let goToNews = "Go to News"
    static let noDataLabel = "No data available. If you want to add some, please press the button"
}


enum Lottie {
    static let bookmark = "LottieBookmark"
    static let launch = "LottieAnimation"
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
    case check = "Check"


    // MARK: - Properties
    var image: UIImage? {
        UIImage(named: rawValue)
    }

    var systemImage: UIImage? {
        UIImage(systemName: rawValue)
    }
}


