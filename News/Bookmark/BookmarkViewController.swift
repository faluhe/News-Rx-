//
//  BookmarkViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

final class BookmarkViewController: RxBaseViewController<BookmarkView> {

    var viewModel: BookmarkViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }

    private func configure(_ bindings: BookmarkViewModel.Bindings) {

    }

    private func configure(_ commands: BookmarkViewModel.Commands) {

    }
}
