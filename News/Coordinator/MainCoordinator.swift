//
//  MainCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

class MainCoordinator: Coordinator {

    var coordinators: [Coordinator] = []
    var tabBarController = UITabBarController()

    func start() {
        let homeCoordinator = HomeCoordinator()
        coordinators.append(homeCoordinator)
        homeCoordinator.start()

        let homeViewController = homeCoordinator.rootViewController
        setup(vc: homeViewController, title: "Home", imageName: "newspaper", selectedImageName: "newspaper.fill")

        let bookmarkCoordinator = BookmarkCoordinator()
        coordinators.append(homeCoordinator)
        bookmarkCoordinator.start()

        let bookmarkViewController = bookmarkCoordinator.rootViewController
        setup(vc: bookmarkViewController, title: "Bookmark", imageName: "bookmark", selectedImageName: "bookmark.fill")

        self.tabBarController.viewControllers = [homeViewController, bookmarkViewController]
    }

    func setup(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        let defaultImage = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: selectedImageName)
        let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
        vc.tabBarItem = tabBarItem
    }

    

}


//class NavigationCoordinator: Coordinator<UINavigationController> {
//
//    func set(
//        _ viewControllers: [UIViewController],
//        animated: Bool = true
//    ) {
//        container.setViewControllers(viewControllers, animated: animated)
//    }
//
//    func push(
//        _ viewController: UIViewController,
//        animated: Bool = true
//    ) {
//        container.pushViewController(viewController, animated: animated)
//    }
//
//    func present(
//        _ viewController: UIViewController,
//        style: UIModalPresentationStyle? = nil,
//        animated: Bool = true
//    ) {
//        if let style = style {
//            viewController.modalPresentationStyle = style
//        }
//        container.present(viewController, animated: animated)
//    }
//
//    func dismiss(animated: Bool = true) {
//        container.dismiss(animated: animated)
//    }
//
//    func pop(animated: Bool = true) {
//        container.popViewController(animated: animated)
//    }
//
//    func popToRoot(animated: Bool = true) {
//        container.popToRootViewController(animated: animated)
//    }
//}
