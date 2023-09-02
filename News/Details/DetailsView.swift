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

    var model = BehaviorRelay<NewsSectionModel?>(value: nil)

    lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()


    override func setupHierarchy() {
        self.addSubview(webView)
    }

    override func setupLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupView() {
        model.subscribe(onNext: { [weak self] model in
            guard let urlString = model?.url, let url = URL(string: urlString) else { return }
            self?.webView.load(URLRequest(url: url))
            })
            .disposed(by: bag)
    }
}
