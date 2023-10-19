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
        self.configure(dependencies: dependencies)
        self.configure(moduleCommands: moduleCommands)
        configure(commands: commands)
        configure(bindings: bindings)
        configure(moduleBindings: moduleBindings)
    }

    func configure(dependencies: Dependencies) {

    }

    func configure(moduleCommands: ModuleCommands) {

    }

    func configure(bindings: Bindings) {
        bindings.title.bind(to: Binder<String>(self) { target, value in
            let articleExist = target.dependencies.coreDataManager.doesArticleExist(withTitle: value)
            bindings.isBookmarked.accept(articleExist)
        }).disposed(by: bag)
    }

    func configure(commands: Commands) {
        commands.addToBookmarks.bind(to: Binder<Void>(self) { target, _ in
            guard let detailsModel = self.bindings.detailsModel.value else {
                // Handle the case where detailsModel doesn't conform to ConvertibleToEntity
                print("Error: detailsModel does not conform to ConvertibleToEntity")
                return
            }

            print(detailsModel.title)
            if target.bindings.isBookmarked.value {
                self.dependencies.coreDataManager.deleteEntity(detailsModel)
                print("delete")
            }else {
                self.dependencies.coreDataManager.saveEntity(detailsModel)
                print("save")
            }
        }).disposed(by: bag)

    }

    func configure(moduleBindings: ModuleBindings) {
        moduleBindings.detailsModel.bind(to: bindings.detailsModel).disposed(by: bag)
    }


}

