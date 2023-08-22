//
//  DetailsViewModel.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import UIKit
import RxSwift
import RxRelay

final class DetailsViewModel: DetailsModuleType, DetailsViewModelType {

    private let bag = DisposeBag()

    // MARK: - Dependencies
    let dependencies: Dependencies

    // MARK: - Module infrastructure
    let moduleBindings = ModuleBindings()
    let moduleCommands = ModuleCommands()

    // MARK: - ViewModel infrastructure
    let bindings = Bindings()
    let commands = Commands()


    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        configure(dependencies: dependencies)
        configure(moduleCommands: moduleCommands)
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

    func configure(moduleBindings: ModuleBindings) {

    }

}

