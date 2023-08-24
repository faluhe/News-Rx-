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

    let bag = DisposeBag()

    struct Input {
        let updatedata = PublishRelay<Void>()
    }

    let input = Input()

    var rootViewController = UINavigationController()

    func start() {
        configure()
    }

    func configure() {
        let module = HomeModuleConfigurator.configure()
        input.updatedata
            .bind(to: module.viewModel.moduleBindings.updateData)
            .disposed(by: bag)

        module.viewModel.moduleBindings.startDetails
            .bind(to: Binder<NewsSectionModel?>(self) { target, _ in
                target.startDetailsScreen()
            }).disposed(by: bag)

        rootViewController.setViewControllers([module.view], animated: true)
    }


    func startDetailsScreen() {
        let module = DetailsModuleConfiguraotor.configure()
        rootViewController.pushViewController(module.view, animated: true)
    }
}
