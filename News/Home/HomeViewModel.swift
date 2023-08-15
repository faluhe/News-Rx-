//
//  HomeViewModel.swift
//  News
//
//  Created by Ismailov Farrukh on 11/08/23.
//

import RxSwift
import UIKit

protocol HomeModuleType {
    var moduleBindings: HomeViewModel.ModuleBindings { get }
    var moduleCommands: HomeViewModel.ModuleCommands { get }
}

protocol HomeViewModelType {
    var bindings: HomeViewModel.Bindings { get }
    var commands: HomeViewModel.Commands { get }
}


final class HomeViewModel: HomeModuleType, HomeViewModelType {

    private let bag = DisposeBag()

    // MARK: - Dependencies
    let dependencies: Dependencies

    struct ModuleCommands { }

    struct Bindings { }

    struct Commands { }

    struct ModuleBindings { }

    struct Dependencies {
        let newsService: HomeNetworkService
    }


    // MARK: - Module infrastructure
    let moduleBindings = ModuleBindings()
    let moduleCommands = ModuleCommands()

    // MARK: - ViewModel infrastructure
    let bindings = Bindings()
    let commands = Commands()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.configure(dependencies: dependencies)
        self.configure(moduleCommands: moduleCommands)
        configure(commands: commands)
        configure(bindings: bindings)
    }

    func configure(dependencies: Dependencies) {

    }

    func configure(moduleCommands: ModuleCommands) {

    }

    func configure(bindings: Bindings) {

    }

    func configure(commands: Commands) {

    }
    
}



final class HomeModuleConfigurator {

    typealias Module = (view: UIViewController, viewModel: HomeModuleType)

    class func configure() -> Module {
        let view = HomeViewController()
        let newsService = HomeNetworkService(network: <#HomeNetworkType#>)
        let viewModel = HomeViewModel(dependencies: .init(newsService: newsService))
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
