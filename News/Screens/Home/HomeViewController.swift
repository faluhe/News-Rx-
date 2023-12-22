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
        setupNavigationBar()
        setupCollectionView()
        setupActivityViewController()
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

        contentView.selectedModel.bind(to: commands.selectedModel).disposed(by: bag)
    }

    private func setupNavigationBar() {
        navigationItem.title = HomeScreen.news
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupCollectionView() {
        contentView.newsCollectionView.addSubview(pullToRefresh)
        contentView.newsCollectionView.refreshControl = pullToRefresh
    }

    private func setupActivityViewController() {
        contentView.onShareAction = { [weak self] section in
            guard let url = section.url else { return }

            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self?.contentView
            DispatchQueue.main.async {
                self?.present(activityViewController, animated: true)
            }
        }
    }

    @objc func refreshData() {
        viewModel.commands.loadNews.accept(())
    }
}
