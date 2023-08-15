//
//  HomeViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

final class HomeViewController: RxBaseViewController<HomeView> {

    var viewModel: HomeViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func setupBinding() {
//        configure(viewModel.bindings)
//        configure(viewModel.commands)
    }

    private func configure(_ bindings: HomeViewModel.Bindings) {

    }

    private func configure(_ commands: HomeViewModel.Commands) {
    }
    


}
