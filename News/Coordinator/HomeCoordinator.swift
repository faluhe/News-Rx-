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
        let module = HomeModuleConfigurator.configure()
        input.updatedata
            .bind(to: module.viewModel.moduleBindings.loadNews)
            .disposed(by: bag)

        rootViewController.setViewControllers([module.view], animated: true)
    }

}
