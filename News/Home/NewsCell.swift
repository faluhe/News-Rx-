//
//  NewsCell.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import SnapKit

class NewsCell: UICollectionViewCell {

    static let identifier = "NewsCell"

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()

    lazy var title: UILabel = {
        let lbl = UILabel()
        return lbl
    }()

    private lazy var subTitle: UILabel = {
        let lbl = UILabel()
        return lbl
    }()

    private lazy var img: UIImageView = {
        let img = UIImageView()
        return img
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
         
    }

    func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubviews(title, subTitle, img)
    }

    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        img.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().offset(10)
            $0.width.equalTo(80)
        }

        title.snp.makeConstraints {
            $0.leading.equalTo(img.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(10)
        }

        subTitle.snp.makeConstraints {
            $0.leading.equalTo(img.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    static func cellSize(collectionView: UICollectionView) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 55)
    }
}
