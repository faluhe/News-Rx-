//
//  Coordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import SwiftUI

protocol Coordinator {
    func start ()
}

class AppCoordinator: Coordinator {

    var window: UIWindow
    var coordinators: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let mainCoordinator = MainCoordinator()
        coordinators.append(mainCoordinator)
        mainCoordinator.start()
        window.rootViewController = mainCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
