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
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
        return view
    }()

    lazy var title: UILabel = {
        let lbl = UILabel()
        return lbl
    }()

    private lazy var subTitle: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()

    private lazy var img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
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
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        img.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
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
            $0.bottom.equalToSuperview().inset(10).priority(.low)
        }
    }

    static func cellSize(collectionView: UICollectionView) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
    }


    func configure(article: NewsSectionModel){
        title.text = article.title
        subTitle.text = article.description

        if let imageURL = article.imageURL {
            ImageManager.shared.loadImage(from: imageURL) { [weak self] image in
                DispatchQueue.main.async {
                    if let validImage = image, self?.img.image == nil {
                        self?.img.image = validImage
                    }
                }
            }
        }
    }
}
