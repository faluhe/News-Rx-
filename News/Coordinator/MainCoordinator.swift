//
//  MainCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

class MainCoordinator: Coordinator {

    var tabBarController = UITabBarController()

    func start() {
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.start()

        let homeViewController = homeCoordinator.rootViewController
        setup(vc: homeViewController, title: "Home", imageName: "newspaper", selectedImageName: "newspaper.fill")

        let bookmarkCoordinator = BookmarkCoordinator()
        bookmarkCoordinator.start()

        let bookmarkViewController = bookmarkCoordinator.rootViewController
        setup(vc: bookmarkViewController, title: "Bookmark", imageName: "bookmark", selectedImageName: "bookmark.fill")

        self.tabBarController.viewControllers = [homeCoordinator.rootViewController, bookmarkCoordinator.rootViewController]
    }

    func setup(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        let defaultImage = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: selectedImageName)
        let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
        vc.tabBarItem = tabBarItem
    }

}
