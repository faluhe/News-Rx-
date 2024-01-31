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
    let showPopUpView = PublishRelay<Void>()
    let articleTitle = BehaviorRelay<String?>(value: nil)
    var issome: Bool!

    var onShareAction: Observable<NewsSectionModel> {
            return shareActionSubject.asObservable()
        }

    private let shareActionSubject = PublishSubject<NewsSectionModel>()
    private var saveActionTitle: String = " "


    lazy var newsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .clear
        return cv
    }()

   private var popUpView: PopUpView!

    override func setupHierarchy() {
        addSubview(newsCollectionView)
        newsCollectionView.rx.setDelegate(self).disposed(by: bag)
    }

    override func setupLayout() {
        newsCollectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    override func setupView() {
        super.setupView()
        sections.bind(to: newsCollectionView.rx.items(cellIdentifier: NewsCell.identifier, cellType: NewsCell.self)) { _, article, cell in
            cell.configure(article: article)
            LoadingIndicator.shared.stop()
        }
        .disposed(by: bag)
    
        isBookmarked.bind(to: Binder<Bool>(self) { target, isBookmarked in
            isBookmarked ? (target.saveActionTitle = HomeScreen.unsave) : (target.saveActionTitle = HomeScreen.save)
        }).disposed(by: bag)

        showPopUpView.bind(to: Binder<Void>(self) { target, _ in
            target.showUpPopUpView()
        }).disposed(by: bag)
    }

    //MARK: - Shows popUp view when user clicks to save
    private func showUpPopUpView() {
        popUpView = PopUpView()
        addSubview(popUpView)
        UIView.animate(withDuration: 0.75) {
            self.configurePopUpViewConstraints()
            HapticFeedbackHelper.provideHapticFeedback(.success)
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.popUpView.removeFromSuperview()
                self.popUpView.snp.removeConstraints()
            }
        }
    }

    fileprivate func configurePopUpViewConstraints() {
        self.popUpView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return NewsCell.cellSize(collectionView: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            let inset: CGFloat = 10.0
            return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
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
                self.shareActionSubject.onNext(selectedModel)
            }
            return UIMenu(title: "", children: [saveAction, share])
        }
        return configuration
    }
}
