//
//  ModuleConfigurator.swift
//  News
//
//  Created by Ismailov Farrukh on 01/09/23.
//

import UIKit

final class DetailsModuleConfiguraotor {

    typealias Module = (view: UIViewController, viewModel: DetailsModuleType)

    class func configure() -> Module {
        let view = DetailsViewController()
        let viewModel = DetailsViewModel(dependencies: .init())
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
