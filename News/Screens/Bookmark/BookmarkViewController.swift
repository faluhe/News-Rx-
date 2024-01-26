//
//  BookmarkViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxSwift

final class BookmarkViewController: RxBaseViewController<BookmarkView> {

    var viewModel: BookmarkViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDeleteActionHandler()
        setupShareActionHandler()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.commands.loadBookmarks.accept(())
        LoadingIndicator.shared.stop()
    }

    override func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }

    private func configure(_ bindings: BookmarkViewModel.Bindings) {

        bindings.sections
            .do(onNext: { [weak self] sections in
                self?.navigationItem.rightBarButtonItem?.isHidden = sections.isEmpty
            })
            .bind(to: contentView.sections)
            .disposed(by: bag)


        contentView.newsCollectionView.rx.modelSelected(NewsSectionModel.self)
            .bind(to: Binder<NewsSectionModel>(self) { _, model in
                bindings.openDetailsScreen.accept(model)
            }).disposed(by: bag)
    }

    private func configure(_ commands: BookmarkViewModel.Commands) {
        contentView.noProductsView.rx.nextAction.bind(to: commands.navigateToNews).disposed(by: bag)
    }

    private func setupNavigationBar() {
        navigationItem.title = BookmarkScreen.bookmarks

        let removeAllItem = UIBarButtonItem()
        removeAllItem.image = .remove
        navigationItem.rightBarButtonItem = removeAllItem

        removeAllItem.rx.tap.bind(onNext: { [weak self] in
            self?.showAlert(title: BookmarkScreen.deleteBookmark, message: BookmarkScreen.areYouSureToDelete, preferedStyle: .alert, completion: { _ in
                HapticFeedbackHelper.provideHapticFeedback(.success)
                self?.viewModel.commands.removeAll.accept(())
            })
        }).disposed(by: bag)
    }
    
    //MARK: - Removing the article from bookmarks
    private func setupDeleteActionHandler() {
        contentView.onDeleteAction.subscribe(onNext: { [weak self] section in

            self?.showAlert(title: BookmarkScreen.deleteBookmark, message: BookmarkScreen.areYouSureToDelete, preferedStyle: .alert, completion: { _ in
                self?.contentView.animateDeletionFor(section: section)
                self?.viewModel.commands.deleteBookmark.accept(section)
            })
        }).disposed(by: bag)
    }

    //MARK: - Sharing and article action
    private func setupShareActionHandler() {
        contentView.onShareAction.subscribe(onNext: { [weak self] section in
            guard let url = section.url else { return }

            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self?.contentView
            DispatchQueue.main.async {
                self?.present(activityViewController, animated: true)
            }
        }).disposed(by: bag)
    }
}
