//
//  HomeViewModel.swift
//  News
//
//  Created by Ismailov Farrukh on 11/08/23.
//

import UIKit
import RxSwift
import RxRelay

final class HomeViewModel: HomeModuleType, HomeViewModelType {

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
    }

    func configure(dependencies: Dependencies) {

    }

    func configure(moduleCommands: ModuleCommands) {

    }

    func configure(bindings: Bindings) {
        loadNews()
    }

    func configure(commands: Commands) {

    }

    func configure(moduleBindings: ModuleBindings) {
        moduleBindings.loadNews.bind(to: Binder<Void>(self) { target, _ in
            
        }).disposed(by: bag)
    }


    func loadNews() {
        let news = dependencies.newsService.getNews()
        news.subscribe { news in
            self.bindings.sections.accept(news)
        }.disposed(by: bag)
    }
}
