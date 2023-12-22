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
        setupDeleteActionHandler()
        setupShareActionHandler()
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

    private func setupDeleteActionHandler() {
        contentView.onDeleteAction = { [weak self] section in
            let alert = UIAlertController(title: BookmarkScreen.deleteBookmark, message: BookmarkScreen.areYouSureToDelete, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: BookmarkScreen.cancel, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: BookmarkScreen.delete, style: .destructive, handler: { [weak self] _ in
                // Perform the deletion animation
                self?.contentView.animateDeletionFor(section: section)
                self?.viewModel.commands.deleteBookmark.accept(section)
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }

    private func setupShareActionHandler() {
        contentView.onShareAction = { [weak self] section in
            guard let url = section.url else { return }

            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self?.contentView
            DispatchQueue.main.async {
                self?.present(activityViewController, animated: true)
            }
        }
    }
}
