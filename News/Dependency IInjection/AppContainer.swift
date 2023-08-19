//
//  AppContainer.swift
//  News
//
//  Created by Ismailov Farrukh on 16/08/23.
//

import Foundation
import Swinject

protocol DependencyProvider {
    func configure()
    func reset()
    func inject<T>() -> T
}


class AppContainer: DependencyProvider {
    
    static let shared: DependencyProvider = AppContainer()
    let container = Container()
    
    init() {
        reset()
    }
    
    func configure() {
        register()
    }
    
    func reset() {
        container.removeAll()
        configure()
    }
    
    func inject<T>() -> T {
        if let service = container.resolve(T.self) {
            return service
        } else {
            fatalError("Dependency \(T.self) not injected")
        }
    }
}



extension AppContainer {
    func register() {
        container.register(DatabaseDispatcher.self) { _ in
            DatabaseDispatcher()
        }.inObjectScope(.container)

        container.register(HomeNetwork.self) { resolver in
            let dispatcher = resolver.resolve(DatabaseDispatcher.self)!
            return HomeNetwork(dispatcher)
        }.inObjectScope(.container)

        container.register(HomeService.self) { resolver in
            let network = resolver.resolve(HomeNetwork.self)!
            return HomeService(network)
        }.inObjectScope(.container)
    }
}



