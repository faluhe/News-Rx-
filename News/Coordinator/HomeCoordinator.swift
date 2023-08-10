//
//  HomeCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

class HomeCoordinator: Coordinator {

    var rootViewController = UINavigationController()

    fileprivate lazy var viewController: HomeViewController = {
        let vc = HomeViewController()
        vc.title = "Home"
        return vc
    }()

    func start() {
        rootViewController.setViewControllers([viewController], animated: true)
    }

}
