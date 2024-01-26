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
    internal var container: UIWindow

    private var coordinators: [any Coordinator] = []
    private let bag = DisposeBag()

    init(window: UIWindow) {
        self.container = window
    }

    internal func start() {
        let launchCoordinator = LaunchScreenCoordinator()

        launchCoordinator.output.done.bind(to: Binder<Void>(self) { target, _ in
            target.startTabBar()

        }).disposed(by: bag)
        launchCoordinator.start()
        
        container.rootViewController = launchCoordinator.container
        container.makeKeyAndVisible()
    }


    private func startTabBar() {
        let startTabBarCoordinator = StartTabBarCoordinator()
        coordinators.append(startTabBarCoordinator)
        startTabBarCoordinator.start()
        container.rootViewController = startTabBarCoordinator.container
        container.makeKeyAndVisible()
    }
}
