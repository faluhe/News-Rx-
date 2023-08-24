//
//  Coordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import SwiftUI

protocol Coordinator {
    associatedtype Container: AnyObject
    var container: Container { get }
    func start ()
}

class AppCoordinator: Coordinator {

    typealias Container = UIWindow
    var container: UIWindow

    var coordinators: [any Coordinator] = []

    init(window: UIWindow) {
        self.container = window
    }

    func start() {
        let startTabBarCoordinator = StartTabBarCoordinator()
        coordinators.append(startTabBarCoordinator)
        startTabBarCoordinator.start()
        self.container.rootViewController = startTabBarCoordinator.container
        self.container.makeKeyAndVisible()
    }
}
