//
//  DetailsViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import UIKit
import RxSwift

final class DetailsViewController: RxBaseViewController<DetailsView> {

    var viewModel: DetailsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func setupBinding() {
        setupNavigationBar()
        configure(viewModel.bindings)
    }

    private func configure(_ bindings: DetailsViewModel.Bindings) {
        bindings.detailsModel.bind(to: contentView.model).disposed(by: bag)
    }

    private func setupNavigationBar() {
        let bookmarkItem = UIBarButtonItem()
        bookmarkItem.image = Images.bookmarkEmpty.systemImage?.withConfiguration(
            UIImage.SymbolConfiguration(weight: .semibold)
        )

        bookmarkItem.rx.tap.bind(to: viewModel.commands.addToBookmarks).disposed(by: bag)
        navigationItem.rightBarButtonItem = bookmarkItem
    }

}
