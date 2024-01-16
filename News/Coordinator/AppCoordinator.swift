//
//  Coordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import SwiftUI
import RxSwift

protocol Coordinator {
    associatedtype Container: AnyObject
    var container: Container { get }
    func start ()
}

class AppCoordinator: Coordinator {

    typealias Container = UIWindow
    var container: UIWindow
    
    var coordinators: [any Coordinator] = []
    private let bag = DisposeBag()

    init(window: UIWindow) {
        self.container = window
    }

    func start() {
        let launchCoordinator = LaunchScreenCoordinator()

        launchCoordinator.output.done.bind(to: Binder<Void>(self) { target, _ in
            target.startTabBar()

        }).disposed(by: bag)
        launchCoordinator.start()
        self.container.rootViewController = launchCoordinator.container
        self.container.makeKeyAndVisible()
    }


    func startTabBar() {
        let startTabBarCoordinator = StartTabBarCoordinator()
        coordinators.append(startTabBarCoordinator)
        startTabBarCoordinator.start()
        self.container.rootViewController = startTabBarCoordinator.container
        self.container.makeKeyAndVisible()
    }
}
