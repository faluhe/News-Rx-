//
//  MainCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

class StartTabBarCoordinator: Coordinator {

    typealias Container = UITabBarController
    var container = UITabBarController()

    var coordinators: [any Coordinator] = []

    func start() {
        startHomeCoordinator()
        startBookmarkCoordinator()
        container.viewControllers = coordinators.compactMap { $0.container as? UINavigationController }
    }

    func startHomeCoordinator() {
        let homeCoordinator = HomeCoordinator()
        coordinators.append(homeCoordinator)
        homeCoordinator.start()
        setup(vc: homeCoordinator.container, title: "Home", imageName: "newspaper", selectedImageName: "newspaper.fill")
    }

    func startBookmarkCoordinator() {
        let bookmarkCoordinator = BookmarkCoordinator()
        coordinators.append(bookmarkCoordinator)
        bookmarkCoordinator.start()
        setup(vc: bookmarkCoordinator.container, title: "Bookmark", imageName: "bookmark", selectedImageName: "bookmark.fill")
    }

    func setup(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        let defaultImage = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: selectedImageName)
        let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
        vc.tabBarItem = tabBarItem
    }
}
