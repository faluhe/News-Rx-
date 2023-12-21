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
    var onDeleteAction: ((NewsSectionModel) -> Void)?
    
    lazy var newsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        return cv
    }()

//    lazy var longPressGesture: UILongPressGestureRecognizer = {
//        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//        return gesture
//    }()
    
    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(newsCollectionView)
        newsCollectionView.rx.setDelegate(self).disposed(by: bag)
//        newsCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func setupLayout() {
        newsCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }

//    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
//        guard gesture.state == .began else {
//            return
//        }
//
//        let point = gesture.location(in:  newsCollectionView)
//        guard let indexPath = newsCollectionView.indexPathForItem(at: point) else {
//            return
//        }
//        onDeleteAction?(sections.value[indexPath.row])
//    }

    
    override func setupView() {
        super.setupView()
        newsCollectionView.backgroundColor = .clear
        
        sections.bind(to: newsCollectionView.rx.items(cellIdentifier: NewsCell.identifier, cellType: NewsCell.self)) { _, article, cell in
            cell.configure(article: article)
        }
        .disposed(by: bag)
    }

    func animateDeletionFor(section: NewsSectionModel) {
        guard let index = sections.value.firstIndex(of: section) else {
            return
        }

        let indexPath = IndexPath(row: index, section: 0)

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.newsCollectionView.performBatchUpdates({
                self.sections.accept(self.sections.value.filter { $0 != section })
                self.newsCollectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        })
    }
}

extension BookmarkView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return NewsCell.cellSize(collectionView: collectionView)
    }
}


extension BookmarkView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let selectedModel = self.sections.value[indexPath.row]

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: BookmarkScreen.delete, image: nil, attributes: .destructive) { _ in
                self.onDeleteAction?(self.sections.value[indexPath.row])
            }

            let share = UIAction(title: HomeScreen.share, image: Images.share.systemImage) { _ in
                print("Selected model for details: \(selectedModel)")
            }

            return UIMenu(title: "", children: [deleteAction, share])
        }

        return configuration
    }
}
