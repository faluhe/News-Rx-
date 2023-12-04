//
//  BookmarkCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxSwift
import RxRelay

class BookmarkCoordinator: Coordinator {
    
    typealias Container = UINavigationController
    var container = UINavigationController()

    let bag = DisposeBag()

    struct Input {
        let detailsModel = BehaviorRelay<NewsSectionModel?>(value: nil)
    }

    let input = Input()

    func start() {
        configure()
    }

    func configure() {
        let module = BookmarkModuleConfigurator.configure()

        module.viewModel.moduleCommands
            .startDetails
            .filterNil()
            .do(onNext: { [weak self] value in
                self?.input.detailsModel.accept(value)
            })
            .bind(to: Binder<NewsSectionModel?>(self) { target, _ in
                target.startDetailsScreen()
            }).disposed(by: bag)

        container.setViewControllers([module.view], animated: true)
    }

    func startDetailsScreen() {
        let module = DetailsModuleConfiguraotor.configure()
        input.detailsModel.bind(to: module.viewModel.moduleBindings.detailsModel).disposed(by: bag)
        container.pushViewController(module.view, animated: true)
    }
}
