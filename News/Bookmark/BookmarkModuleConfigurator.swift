//
//  BookmarkModuleConfigurator.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import UIKit

final class BookmarkModuleConfigurator {

    typealias Module = (view: UIViewController, viewModel: BookmarkViewModel)

    class func configure() -> Module {
        let view = BookmarkViewController()
        let viewModel = BookmarkViewModel(dependencies: .init(bookmarkService: AppContainer.shared.inject()))
        view.viewModel = viewModel
        return (view, viewModel)
    }
}

