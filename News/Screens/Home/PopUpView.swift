//
//  PopUpView.swift
//  News
//
//  Created by Ismailov Farrukh on 28/12/23.
//

import UIKit

final class PopUpView: RxBaseView {

    private lazy var img: UIImageView = {
        let img = UIImageView()
        img.image = Images.check.image
        return img
    }()

    override func setupView() {
        super.setupView()
        layer.cornerRadius = 13
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }

    override func setupHierarchy() {
        addSubview(img)
    }

    override func setupLayout() {
        img.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(self).multipliedBy(0.5)
            $0.height.equalTo(img.snp.width)
        }
    }
}
