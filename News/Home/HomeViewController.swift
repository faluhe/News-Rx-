//
//  HomeViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxSwift

final class HomeViewController: RxBaseViewController<HomeView> {

    var viewModel: HomeViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }

    private func configure(_ bindings: HomeViewModel.Bindings) {
        bindings.sections.bind(to: contentView.sections).disposed(by: bag)

        contentView.newsCollectionView.rx.modelSelected(Article.self).bind(to: Binder<Article>(self) { _, model in
            print(model)
        }).disposed(by: bag)

    }

    private func configure(_ commands: HomeViewModel.Commands) {
    }
    


}
