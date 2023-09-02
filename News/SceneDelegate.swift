//
//  SceneDelegate.swift
//  News
//
//  Created by Ismailov Farrukh on 10/08/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.appCoordinator = AppCoordinator(window: window)
        self.appCoordinator?.start()
    }
}



