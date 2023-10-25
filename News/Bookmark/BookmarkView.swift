//
//  BookmarkView.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit

final class BookmarkView: RxBaseView {

    let sections = BehaviorRelay<[NewsSectionModel]>(value: [])

    lazy var newsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        return cv
    }()

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(newsCollectionView)
        newsCollectionView.rx.setDelegate(self).disposed(by: bag)
    }

    override func setupLayout() {
        newsCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }

    override func setupView() {
        super.setupView()
        newsCollectionView.backgroundColor = .clear

        sections.bind(to: newsCollectionView.rx.items(cellIdentifier: NewsCell.identifier, cellType: NewsCell.self)) { _, article, cell in
                cell.configure(article: article)
            }
            .disposed(by: bag)
    }
}

extension BookmarkView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return NewsCell.cellSize(collectionView: collectionView)
    }
}
