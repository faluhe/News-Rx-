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
        configure(moduleBindings: moduleBindings)
    }

    func configure(dependencies: Dependencies) {}

    func configure(moduleCommands: ModuleCommands) {
        bindings.openDetailsScreen.bind(to: moduleCommands.startDetails).disposed(by: bag)
    }

    func configure(bindings: Bindings) { //ViewModel and UI

    }

    func configure(commands: Commands) { //Command from UI interaction
        commands.loadNews.bind(to: Binder<Void>(self) { target, _ in
            target.loadNewsFromServer()
        }).disposed(by: bag)
    }

    func configure(moduleBindings: ModuleBindings) { //connecting action to Module for using in Coordinator
        moduleBindings.updateData.bind(to: Binder<Void>(self) { target, _ in
//            target.loadNewsFromServer()
        }).disposed(by: bag)
    }


    func loadNewsFromServer() {
        let news = dependencies.newsService.getNews()
        news.subscribe(
            onNext: { [weak self] news in
                let newsViewModels = news.articles?.map { $0.toViewModel() } ?? []
                self?.bindings.sections.accept(newsViewModels)
                DispatchQueue.main.async {
                    self?.dependencies.coreData.saveEntity(news)
                }
            },
            onError: { [weak self] error in
                print("Error loading news: \(error.localizedDescription)")
                self?.loadStoredNews()
            }).disposed(by: bag)
    }

    func loadStoredNews() {
        let storedNews = dependencies.newsService.getStoredNews()

        storedNews.subscribe(
            onNext: { [weak self] storedNews in
            let newsViewModels = storedNews.articles?.map { $0.toViewModel() } ?? []
            self?.bindings.sections.accept(newsViewModels)
        }).disposed(by: bag)
    }
}
