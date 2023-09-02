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
        configure(viewModel.bindings)
    }

    private func configure(_ bindings: DetailsViewModel.Bindings) {

        bindings.detailsModel
                .bind(to: contentView.model)
                .disposed(by: bag)
    }

}
