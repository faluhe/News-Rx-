//
//  DetailsView.swift
//  News
//
//  Created by Ismailov Farrukh on 25/08/23.
//

import UIKit
import WebKit
import SnapKit
import RxSwift
import RxRelay

final class DetailsView: RxBaseView {

    var section = BehaviorRelay<NewsSectionModel?>(value: nil)
    var articleTitle = BehaviorRelay<String>(value: "")
    private let stoploadingSubject = PublishSubject<Void>()

    var onStopLoadingIndicatorAction: Observable<Void> {
        return stoploadingSubject.asObservable()
    }

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()

    override func setupHierarchy() {
        self.stoploadingSubject.onNext(())
        self.addSubview(webView)
    }

    override func setupLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupView() {
        section.bind(to: Binder<NewsSectionModel?>(self) { target, model in
            guard let title = model?.title, let urlString = model?.url, let url = URL(string: urlString) else { return }
            target.articleTitle.accept(title)
            target.webView.load(URLRequest(url: url))
        }).disposed(by: bag)
    }
}


extension DetailsView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stoploadingSubject.onNext(())
    }
}
