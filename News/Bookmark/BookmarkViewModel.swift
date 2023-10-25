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

    func configure(commands: Commands) {
       // from UI interaction
        commands.loadBookmarks.bind(to: Binder<Void>(self) { target, _ in
                target.loadBookmarks()
            }).disposed(by: bag)
    }

    func configure(moduileCommands: ModuleCommands) {
        bindings.openDetailsScreen.bind(to: moduileCommands.startDetails).disposed(by: bag)
    }

    func configure(bindings: Bindings) {
        loadBookmarks()
    }

    func configure(moduleBindings: ModuleBindings) {

    }

    func loadBookmarks() {
        let bookmarks = dependencies.bookmarkService.getBookmarks()
        bookmarks.subscribe({ [weak self] result in
            switch result {
            case .success(let storedBookmarks):
                print(storedBookmarks)
                self?.bindings.sections.accept(storedBookmarks)
            case .failure(let error):
                print("Error: \(error)")
            }
        })
        .disposed(by: bag)
    }
}
