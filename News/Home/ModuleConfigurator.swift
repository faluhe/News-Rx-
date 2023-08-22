//
//  ModuleConfigurator.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import UIKit

final class HomeModuleConfigurator {

    typealias Module = (view: UIViewController, viewModel: HomeModuleType)

    class func configure() -> Module {
        let view = HomeViewController()
        let viewModel = HomeViewModel(dependencies: .init(newsService: AppContainer.shared.inject()))
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
