//
//  PopUpView.swift
//  News
//
//  Created by Ismailov Farrukh on 28/12/23.
//

import UIKit
import Lottie

final class PopUpView: RxBaseView {

    private let animationView: LottieAnimationView = .init(name: "LottieBookmark")

    override func setupView() {
        super.setupView()
        layer.cornerRadius = 13
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        setupAnimation()
    }

    override func setupHierarchy() {
        addSubview(animationView)
    }

    override func setupLayout() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func setupAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: animationView.loopMode)

    }
}
