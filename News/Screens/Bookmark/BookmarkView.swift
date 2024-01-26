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
    private var deleteActionSubject = PublishSubject<NewsSectionModel>()
    private var shareActionSubject = PublishSubject<NewsSectionModel>()

    var onDeleteAction: Observable<NewsSectionModel> {
        return deleteActionSubject.asObservable()
    }

    var onShareAction: Observable<NewsSectionModel> {
        return shareActionSubject.asObservable()
    }

    lazy var newsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .clear
        return cv
    }()

    lazy var noProductsView: EmptyBookmarksView = {
        let view = EmptyBookmarksView()
        view.isHidden = true
        return view
    }()

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(newsCollectionView)
        addSubviews(noProductsView)
        newsCollectionView.rx.setDelegate(self).disposed(by: bag)
    }

    override func setupLayout() {
        newsCollectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }

        noProductsView.snp.makeConstraints {
            $0.edges.equalTo(newsCollectionView)
        }
    }

    override func setupView() {
        super.setupView()

        sections
            .do(onNext: { [weak self] newSections in
                self?.noProductsView.isHidden = !newSections.isEmpty
            })
            .bind(to: newsCollectionView.rx.items(cellIdentifier: NewsCell.identifier, cellType: NewsCell.self)) { _, article, cell in
                cell.configure(article: article)
            }
            .disposed(by: bag)
    }

    func animateDeletionFor(section: NewsSectionModel) {

        guard let index = sections.value.firstIndex(of: section) else { return }

        let indexPath = IndexPath(row: index, section: 0)

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.newsCollectionView.performBatchUpdates({
                self.sections.accept(self.sections.value.filter { $0 != section })
                HapticFeedbackHelper.provideHapticFeedback(.success)
                self.newsCollectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        })
    }
}


extension BookmarkView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return NewsCell.cellSize(collectionView: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            let inset: CGFloat = 10.0
            return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        }
}


extension BookmarkView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let selectedModel = self.sections.value[indexPath.row]

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: BookmarkScreen.delete, image: nil, attributes: .destructive) { _ in
                self.deleteActionSubject.onNext(selectedModel)
            }
            let share = UIAction(title: HomeScreen.share, image: Images.share.systemImage) { _ in
                self.shareActionSubject.onNext(selectedModel)
            }

            return UIMenu(title: "", children: [deleteAction, share])
        }
        return configuration
    }
}
