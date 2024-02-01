//
//  HomeViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxSwift

final class HomeViewController: RxBaseViewController<HomeView>, LoadingIndicator {

    var viewModel: HomeViewModelType!

    private lazy var pullToRefresh: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoadingIndicator()
        viewModel.commands.loadNews.accept(())

        setupNavigationBar()
        setupRefreshControl()
        setupActivityViewController()

        contentView.onStopLoadingIndicatorAction.bind(to: Binder<Void>(self) { target, _ in
            target.stopLoadingIndicator()
        }).disposed(by: bag)
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

        contentView.articleTitle.bind(to: bindings.articleTitle).disposed(by: bag)
        bindings.isBookmarked.bind(to: contentView.isBookmarked).disposed(by: bag)

    }

    private func configure(_ commands: HomeViewModel.Commands) {
        commands.loadingCompleteSignal
            .observe(on: MainScheduler.instance)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.pullToRefresh.endRefreshing()
            })
            .disposed(by: bag)

        commands.showPopUpView.bind(to: contentView.showPopUpView).disposed(by: bag)
        contentView.selectedModel.bind(to: commands.selectedModel).disposed(by: bag)
    }

    private func setupNavigationBar() {
        navigationItem.title = HomeScreen.news
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupRefreshControl() {
        contentView.newsCollectionView.addSubview(pullToRefresh)
        contentView.newsCollectionView.refreshControl = pullToRefresh
    }

    private func setupActivityViewController() {
        contentView.onShareAction.bind(to: Binder<NewsSectionModel>(self) { target, section in
            guard let url = section.url else { return }

            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = target.contentView

            DispatchQueue.main.async {
                target.present(activityViewController, animated: true)
            }

        }).disposed(by: bag)
    }

    @objc func refreshData() {
        viewModel.commands.loadNews.accept(())
    }
}
