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

    // Module Configuration: Connects module-level commands to communication with the coordinator.
    func configure(moduleCommands: ModuleCommands) {
        bindings.openDetailsScreen.bind(to: moduleCommands.startDetails).disposed(by: bag)
    }

    // Module Bindings Configuration: for connecting actions to the module for coordination purposes.
    func configure(moduleBindings: ModuleBindings) { }

    // ViewModel and UI Configuration: bindings between ViewModel and UI components.
    func configure(bindings: Bindings) {

        bindings.articleTitle.bind(to: Binder<String?>(self) { target, value in
            guard let title = value else { return }
            target.dependencies.coreDataManager.doesEntityExist(BookmarkEntity.self, withTitle: title) { articleExist in
                bindings.isBookmarked.accept(articleExist)
            }
        }).disposed(by: bag)
    }

    // UI Commands Configuration:  UI interaction commands
    func configure(commands: Commands) {
        commands.loadNews.bind(to: Binder<Void>(self) { target, _ in
            target.loadNewsFromServer()
        }).disposed(by: bag)

        commands.selectedModel
            .withLatestFrom(bindings.isBookmarked) { selectedModel, isBookmarked in
                return (selectedModel, isBookmarked)
            }
            .subscribe(onNext: { [weak self] (selectedModel, isBookmarked) in
                guard let model = selectedModel else { return }
                isBookmarked ? self?.removeFromDatabase(model) : self?.savingToDatabase(model)
            })
            .disposed(by: bag)
    }

    private func loadNewsFromServer() {
        let news = dependencies.newsService.getNews()
        news.subscribe(
            onNext: { [weak self] news in
                let newsViewModels = news.articles?.map { $0.toNewsSectionModel() } ?? []
                self?.bindings.sections.accept(newsViewModels)
                self?.commands.loadingCompleteSignal.accept(())

                self?.dependencies.coreDataManager.saveEntity(news, completion: { result in
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        print("Error saving entity: \(error)")
                    }
                })
            },
            onError: { [weak self] error in
                print("Error loading news: \(error.localizedDescription)")
                self?.loadStoredNews()
            }).disposed(by: bag)
    }

    private func loadStoredNews() {
        let storedNews = dependencies.newsService.getStoredNews()

        storedNews.subscribe(
            onNext: { [weak self] storedNews in
                let newsViewModels = storedNews.articles?.map { $0.toNewsSectionModel() } ?? []
                self?.bindings.sections.accept(newsViewModels)
            }).disposed(by: bag)
    }

    private func removeFromDatabase(_ model: NewsSectionModel) {
        dependencies.coreDataManager.deleteEntity(model, completion: { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Error deleting entity: \(error)")
            }
        })
    }

    private func savingToDatabase(_ model: NewsSectionModel) {
        dependencies.coreDataManager.saveEntity(model, completion: { result in
            switch result {
            case .success:
                self.commands.showPopUpView.accept(())
            case .failure(let error):
                print("Error saving entity: \(error)")
            }
        })
    }
}
