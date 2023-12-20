//
//  DetailsViewModel.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import UIKit
import RxSwift

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
        self.configure(dependencies: dependencies)
        self.configure(moduleCommands: moduleCommands)
        configure(commands: commands)
        configure(bindings: bindings)
        configure(moduleBindings: moduleBindings)
    }

    func configure(dependencies: Dependencies) { }

    // Module Configuration: Connects module-level commands to communication with the coordinator.
    func configure(moduleCommands: ModuleCommands) { }

    // Module Bindings Configuration: for connecting actions to the module for coordination purposes.
    func configure(moduleBindings: ModuleBindings) {
        moduleBindings.detailsModel.bind(to: bindings.detailsModel).disposed(by: bag)
    }

    // ViewModel and UI Configuration: bindings between ViewModel and UI components.
    func configure(bindings: Bindings) {
        bindings.articleTitle.bind(to: Binder<String>(self) { target, value in
            let articleExist = target.dependencies.coreDataManager.doesEntityExist(BookmarkEntity.self, withTitle: value)
            bindings.isBookmarked.accept(articleExist)
        }).disposed(by: bag)
    }

    // UI Commands Configuration:  UI interaction commands
    func configure(commands: Commands) {
        commands.saveToBookmarks
            .withLatestFrom(bindings.isBookmarked)
            .bind(to: Binder<Bool>(self) { target, isBookmarked in
                guard let detailsModel = target.bindings.detailsModel.value else {
                    print("Error: detailsModel does not conform to ConvertibleToEntity")
                    return
                }

                if isBookmarked {
                    target.dependencies.coreDataManager.deleteEntity(detailsModel)
                    target.bindings.isBookmarked.accept(false)
                } else {
                    target.dependencies.coreDataManager.saveEntity(detailsModel)
                    target.bindings.isBookmarked.accept(true)
                }
            })
            .disposed(by: bag)
    }
}
