//
//  HomeView.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit

class HomeView: RxBaseView {
    let sections = BehaviorRelay<News?>(value: nil)
    lazy var newsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        return cv
    }()

    override func setupHierarchy() {
        newsCollectionView.rx.setDelegate(self).disposed(by: bag)
        addSubview(newsCollectionView)
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

        sections
            .compactMap { $0?.articles }
            .bind(to: newsCollectionView.rx.items(cellIdentifier: NewsCell.identifier, cellType: NewsCell.self)) { _, article, cell in
                cell.configure(article: article)
            }
            .disposed(by: bag)

    }




}


extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return NewsCell.cellSize(collectionView: collectionView)
    }
}
