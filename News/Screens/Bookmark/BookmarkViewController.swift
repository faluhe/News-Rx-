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
        navigationItem.title = BookmarkScreen.bookmarks

        contentView.onDeleteAction = { [weak self] indexPath in
            self?.showDeleteConfirmation(at: indexPath)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.commands.loadBookmarks.accept(())
    }

    override func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }

    private func configure(_ bindings: BookmarkViewModel.Bindings) {
        bindings.sections.bind(to: contentView.sections).disposed(by: bag)

        contentView.newsCollectionView.rx.modelSelected(NewsSectionModel.self)
            .bind(to: Binder<NewsSectionModel>(self) { _, model in
                bindings.openDetailsScreen.accept(model)
            }).disposed(by: bag)
    }
    
    private func configure(_ commands: BookmarkViewModel.Commands) { }

    func showDeleteConfirmation(at indexPath: NewsSectionModel) {
        let alert = UIAlertController(title: BookmarkScreen.deleteBookmark, message: BookmarkScreen.areYouSureToDelete, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: BookmarkScreen.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: BookmarkScreen.delete, style: .destructive, handler: { [weak self] _ in
            self?.viewModel.commands.deleteBookmark.accept(indexPath)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
