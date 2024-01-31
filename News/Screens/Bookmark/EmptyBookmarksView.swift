//
//  NoDataViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 23/12/23.
//

import UIKit
import RxSwift

final class EmptyBookmarksView: RxBaseView {

    override func setupHierarchy() {
        addSubview(stackView)
    }

    override func setupLayout() {
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(30)
        }

        goToHomeBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(40)
        }

        imageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(imageView.snp.width)
        }
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView,label,goToHomeBtn])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 60
        return stackView
    }()

    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = BookmarkScreen.noDataLabel
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.textAlignment = .center
        lbl.numberOfLines = 3
        return lbl
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.noDataInBookmarks.image?.withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    fileprivate let goToHomeBtn = BaseButton(title: BookmarkScreen.goToNews)
}


extension Reactive where Base: EmptyBookmarksView {

    var nextAction: Observable<Void> {
        base.goToHomeBtn.rx.action
    }
}
