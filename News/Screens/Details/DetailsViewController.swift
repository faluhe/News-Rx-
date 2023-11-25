//
//  DetailsViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import UIKit
import RxSwift
import CoreData
import RxRelay

final class DetailsViewController: RxBaseViewController<DetailsView> {

    var viewModel: DetailsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupBinding() {
        configure(viewModel.bindings)
        setupNavigationBar(viewModel.bindings)
    }

    private func configure(_ bindings: DetailsViewModel.Bindings) {
        bindings.detailsModel.bind(to: contentView.model).disposed(by: bag)
        contentView.title.bind(to: bindings.title).disposed(by: bag)
    }

    private func setupNavigationBar(_ bindings: DetailsViewModel.Bindings) {
        let bookmarkItem = UIBarButtonItem()

        bindings.isBookmarked
            .map { $0 ? Images.bookmarkFill.systemImage : Images.bookmarkEmpty.systemImage }
            .bind(to: bookmarkItem.rx.image)
            .disposed(by: bag)

        bookmarkItem.rx.tap
            .bind(to: viewModel.commands.addToBookmarks)
            .disposed(by: bag)

        navigationItem.rightBarButtonItem = bookmarkItem
    }
}
