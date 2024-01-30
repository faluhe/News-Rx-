//
//  Home+infastructure.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import Foundation
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

    struct ModuleBindings { }
    
    struct ModuleCommands {
        let startDetails = BehaviorRelay<NewsSectionModel?>(value: nil)
        let done = PublishRelay<Void>()
    }

    struct Bindings {
        let sections = BehaviorRelay<[NewsSectionModel]>(value: [])
        let openDetailsScreen = BehaviorRelay<NewsSectionModel?>(value: nil)
        let isBookmarked = BehaviorRelay<Bool>(value: false)
        let articleTitle = BehaviorRelay<String?>(value: nil)
    }

    struct Commands {
        let loadNews = PublishRelay<Void>()
        let loadingCompleteSignal = PublishRelay<Void>()
        let selectedModel = BehaviorRelay<NewsSectionModel?>(value: nil)
        let showPopUpView = PublishRelay<Void>()
    }

    struct Dependencies {
        let newsService: HomeService
        let coreData: CoreDataManager
    }
}
