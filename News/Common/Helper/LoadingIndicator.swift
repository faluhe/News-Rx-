//
//  LoadingIndicator.swift
//  News
//
//  Created by Ismailov Farrukh on 27/12/23.
//

import UIKit

protocol LoadingIndicator: AnyObject {
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

extension LoadingIndicator where Self: UIViewController {
    func startLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let loadingIndicator = UIActivityIndicatorView(style: .medium)
            loadingIndicator.center = self.view.center
            loadingIndicator.startAnimating()
            self.view.addSubview(loadingIndicator)
        }
    }

    func stopLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach {
                $0.stopAnimating()
                $0.removeFromSuperview()
            }
        }
    }
}
