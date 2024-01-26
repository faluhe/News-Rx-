//
//  HomeCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxRelay
import RxSwift

class HomeCoordinator: Coordinator {

    typealias Container = UINavigationController
    internal var container = UINavigationController()

    private var bag = DisposeBag()
    
    struct Input {
        let updatedata = PublishRelay<Void>()
        let detailsModel = BehaviorRelay<NewsSectionModel?>(value: nil)
    }

    let input = Input()

    func start() {
        configure()
    }

    func configure() {
        let module = HomeModuleConfigurator.configure()

        module.viewModel.moduleCommands.startDetails
            .filterNil()
            .do(onNext: { [weak self] value in
            self?.input.detailsModel.accept(value)
        }).bind(to: Binder<NewsSectionModel?>(self) { target, _ in
         target.startDetailsScreen()
        }).disposed(by: bag)

        container.setViewControllers([module.view], animated: true)
    }


    func startDetailsScreen() {
        let module = DetailsModuleConfiguraotor.configure()
        input.detailsModel.bind(to: module.viewModel.moduleBindings.detailsModel).disposed(by: bag)
        container.show(module.view, sender: self)
    }
}
