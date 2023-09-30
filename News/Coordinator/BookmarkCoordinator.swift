//
//  BookmarkCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

class BookmarkCoordinator: Coordinator {
    
    typealias Container = UINavigationController
    var container = UINavigationController()

    fileprivate lazy var viewController: BookmarkViewController = {
        let vc = BookmarkViewController()
        vc.title = "Bookmark"
        return vc
    }()

    func start() {
       configure()
    }

    func configure() {
        let module = BookmarkModuleConfigurator.configure()
        container.setViewControllers([module.view], animated: true)
    }

}
