//
//  MainCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

class StartTabBarCoordinator: Coordinator {


    /// Я б в координаторі описав ще роутер, який би переходив по певному екрані
    /// типу router.open(.home), router.open(.bookmarks), мені не подобається що це все різні методи, хотя по суті вони роблять
    /// одне й те саме, беруть чайлд координатор, юзають якийсь аутпут, пушать/презентять екран 

    typealias Container = UITabBarController
    internal var container = UITabBarController()

    private var coordinators: [any Coordinator] = []

    func start() {
        startHomeCoordinator()
        startBookmarkCoordinator()
        container.viewControllers = coordinators.compactMap { $0.container as? UINavigationController }
    }

    func startHomeCoordinator() {
        let homeCoordinator = HomeCoordinator()
        coordinators.append(homeCoordinator)
        homeCoordinator.start()
        setup(vc: homeCoordinator.container, title: ScreenNames.home, imageName: Images.newspaper.systemImage, selectedImageName: Images.home.systemImage)
    }

    func startBookmarkCoordinator() {
        let bookmarkCoordinator = BookmarkCoordinator()
        coordinators.append(bookmarkCoordinator)
        bookmarkCoordinator.start()
        setup(vc: bookmarkCoordinator.container, title: ScreenNames.bookmark, imageName: Images.bookmarkEmpty.systemImage, selectedImageName: Images.bookmarkFill.systemImage)
    }

    func setup(vc: UIViewController, title: String, imageName: UIImage?, selectedImageName: UIImage?) {
        let tabBarItem = UITabBarItem(title: title, image: imageName, selectedImage: selectedImageName)
        vc.tabBarItem = tabBarItem
    }
}
