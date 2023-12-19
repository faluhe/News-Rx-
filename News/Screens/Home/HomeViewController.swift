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

    private lazy var pullToRefresh: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = HomeScreen.news
        navigationController?.navigationBar.prefersLargeTitles = true
        contentView.newsCollectionView.addSubview(pullToRefresh)
        contentView.newsCollectionView.refreshControl = pullToRefresh
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.commands.loadNews.accept(())
    }

    override func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }

    private func configure(_ bindings: HomeViewModel.Bindings) {
        bindings.sections.bind(to: contentView.sections).disposed(by: bag)

        contentView.newsCollectionView.rx.modelSelected(NewsSectionModel.self)
            .bind(to: Binder<NewsSectionModel>(self) { _, model in
                bindings.openDetailsScreen.accept(model)
            }).disposed(by: bag)
    }

    private func configure(_ commands: HomeViewModel.Commands) {
        commands.loadingCompleteSignal
            .observe(on: MainScheduler.instance)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.pullToRefresh.endRefreshing()
            })
            .disposed(by: bag)
    }

    @objc func refreshData() {
        viewModel.commands.loadNews.accept(())
    }
}
