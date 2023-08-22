//
//  Home+infastructure.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeModuleType {
    var moduleBindings: HomeViewModel.ModuleBindings { get }
    var moduleCommands: HomeViewModel.ModuleCommands { get }
}

protocol HomeViewModelType {
    var bindings: HomeViewModel.Bindings { get }
    var commands: HomeViewModel.Commands { get }
}

extension HomeViewModel {

    struct ModuleCommands { }

    struct Bindings {
        let sections = BehaviorRelay<News?>(value: nil)
    }

    struct Commands { }

    struct ModuleBindings {
        let loadNews = PublishRelay<Void>()
    }

    struct Dependencies {
        let newsService: HomeService
    }
}
