//
//  BookmarkViewModel.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import Foundation
import RxSwift
import RxRelay

final class BookmarkViewModel: BookmarkViewModelType, BookmarkMuduleType {

    private let bag = DisposeBag()

    //MARK: - Dependencies
    let dependencies: Dependencies

    //MARK: - Module Infrastracture
    let moduleBindings = ModuleBindings()
    let moduleCommands = ModuleCommands()

    //MARK: - ViewModel Infrastracture
    let bindings = Bindings()
    let commands = Commands()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.configure(bindings: bindings)
        self.configure(moduleBindings: moduleBindings)
        self.configure(commands: commands)
        self.configure(moduileCommands: moduleCommands)
    }

    func configure(dependencies: Dependencies) { }

    // Module Configuration: Connects module-level commands to communication with the coordinator.
    func configure(moduileCommands: ModuleCommands) {
        bindings.openDetailsScreen.bind(to: moduileCommands.startDetails).disposed(by: bag)
        commands.navigateToNews.bind(to: moduileCommands.navigateToNews).disposed(by: bag)
    }

    // Module Bindings Configuration: for connecting actions to the module for coordination purposes.
    func configure(moduleBindings: ModuleBindings) { }

    // ViewModel and UI Configuration: bindings between ViewModel and UI components.
    func configure(bindings: Bindings) {
        loadBookmarks()
    }

    // UI Commands Configuration:  UI interaction commands
    func configure(commands: Commands) {
        commands.loadBookmarks.bind(to: Binder<Void>(self) { target, _ in
            target.loadBookmarks()
        }).disposed(by: bag)

        commands.deleteBookmark.bind(to: Binder<NewsSectionModel?>(self) { target, model in
            guard let model = model else { return }
            target.dependencies.coreData.deleteEntity(model)
            target.loadBookmarks()
        }).disposed(by: bag)

        commands.removeAll.bind(to: Binder<Void>(self) { target, _ in
            target.dependencies.coreData.deleteAllBookmarks()
            target.loadBookmarks()
        }).disposed(by: bag)
    }

    func loadBookmarks() {
        let bookmarks = dependencies.bookmarkService.getBookmarks()
        bookmarks.subscribe(onNext: { [weak self] result in
            self?.bindings.sections.accept(result)
        })
        .disposed(by: bag)
    }
}
