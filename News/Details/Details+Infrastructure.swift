//
//  Details+Infrastructure.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import Foundation

protocol DetailsModuleType {
    var moduleBindings: DetailsViewModel.ModuleBindings { get }
    var moduleCommands: DetailsViewModel.ModuleCommands { get }
}

protocol DetailsViewModelType {
    var bindings: DetailsViewModel.Bindings { get }
    var commands: DetailsViewModel.Commands { get }
}

extension DetailsViewModel {
    struct Bindings {

    }

    struct ModuleBindings {

    }

    struct Commands {

    }

    struct ModuleCommands {

    }

    struct Dependencies {

    }
}
