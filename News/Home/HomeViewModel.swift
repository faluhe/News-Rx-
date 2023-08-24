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
        //        moduleBindings.loadNews.bind(to: Binder<Void>(self) { target, _ in
        //
        //        }).disposed(by: bag)

        bindings.openDetailsScreen.bind(to: moduleBindings.startDetails).disposed(by: bag)
    }


    func loadNews() {
            let news = dependencies.newsService.getNews()

            news
                .subscribe(onNext: { [weak self] news in
                    let newsViewModels = news.articles?.map { $0.toViewModel() } ?? []
                    self?.bindings.sections.accept(newsViewModels)
                })
                .disposed(by: bag)
        }
}



final class DetailsModuleConfiguraotor {

    typealias Module = (view: UIViewController, viewModel: DetailsModuleType)

    class func configure() -> Module {
        let view = DetailsViewController()
        let viewModel = DetailsViewModel()
        view.viewModel = viewModel
        return (view, viewModel)
    }
}
