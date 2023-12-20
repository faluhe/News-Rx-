//
//  Details+Infrastructure.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import Foundation
import RxRelay

protocol DetailsModuleType {
    var moduleBindings: DetailsViewModel.ModuleBindings { get }
    var moduleCommands: DetailsViewModel.ModuleCommands { get }
}

protocol DetailsViewModelType {
    var bindings: DetailsViewModel.Bindings { get }
    var commands: DetailsViewModel.Commands { get }
}

extension DetailsViewModel {

    struct ModuleBindings {
        let detailsModel = BehaviorRelay<NewsSectionModel?>(value: nil)
    }

    struct ModuleCommands { }

    struct Bindings {
        let detailsModel = BehaviorRelay<NewsSectionModel?>(value: nil)
        let isBookmarked = BehaviorRelay<Bool>(value: false)
        let articleTitle = BehaviorRelay<String>(value: "")
    }

    struct Commands {
        let saveToBookmarks = PublishRelay<Void>()
    }

    struct Dependencies {
        let coreDataManager: CoreDataManager
    }
}
