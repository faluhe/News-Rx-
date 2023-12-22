//
//  HomeView.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxRelay
import SnapKit
import RxSwift

final class HomeView: RxBaseView {

    let sections = BehaviorRelay<[NewsSectionModel]>(value: [])
    let selectedModel = BehaviorRelay<NewsSectionModel?>(value: nil)
    let isBookmarked = BehaviorRelay<Bool>(value: false)
    var saveActionTitle: String = " "
    let articleTitle = BehaviorRelay<String?>(value: nil)
    var onShareAction: ((NewsSectionModel) -> Void)?

    lazy var newsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        return cv
    }()

    override func setupHierarchy() {
        addSubview(newsCollectionView)
        newsCollectionView.rx.setDelegate(self).disposed(by: bag)
    }

    override func setupLayout() {
        newsCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
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

        isBookmarked.bind(to: Binder<Bool>(self) { target, isBookmarked in
            print(isBookmarked)
            isBookmarked ? (target.saveActionTitle = HomeScreen.unsave) : (target.saveActionTitle = HomeScreen.save)
        }).disposed(by: bag)
    }
}


extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return NewsCell.cellSize(collectionView: collectionView)
    }
}

extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let selectedModel = self.sections.value[indexPath.row]
        self.articleTitle.accept(selectedModel.title)

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let saveAction = UIAction(title: self.saveActionTitle, image: Images.bookmarkEmpty.systemImage) { _ in
                self.selectedModel.accept(selectedModel)
            }

            let share = UIAction(title: HomeScreen.share, image: Images.share.systemImage) { _ in
                self.onShareAction?(selectedModel)
            }
            return UIMenu(title: "", children: [saveAction, share])
        }
        return configuration
    }
}
