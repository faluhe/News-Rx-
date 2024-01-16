//
//  PopUpView.swift
//  News
//
//  Created by Ismailov Farrukh on 28/12/23.
//

import UIKit
import Lottie

final class PopUpView: RxBaseView {

    private let animationView: LottieAnimationView = .init(name: Lottie.bookmark)

    override func setupView() {
        super.setupView()
        backgroundColor = .black.withAlphaComponent(0.8)
        setupAnimation()
    }

    override func setupHierarchy() {
        addSubview(animationView)
    }

    override func setupLayout() {
        animationView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(animationView.snp.width)
            $0.center.equalToSuperview()
        }
    }

    func setupAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: animationView.loopMode)
    }
}
