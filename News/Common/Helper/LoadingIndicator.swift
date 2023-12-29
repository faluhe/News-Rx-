//
//  LoadingIndicator.swift
//  News
//
//  Created by Ismailov Farrukh on 27/12/23.
//

import UIKit

final class LoadingIndicator {
    static let shared = LoadingIndicator()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private init() {
        setup()
    }

    private func setup() {
        activityIndicator.hidesWhenStopped = true
    }

    func start() {
        DispatchQueue.main.async {


            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let mainWindow = windowScene.windows.first else {
                return
            }

            let screenCenter = mainWindow.center
            self.activityIndicator.center = screenCenter
            mainWindow.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }

    func stop() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
