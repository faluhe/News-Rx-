//
//  LaunchScreenVC.swift
//  News
//
//  Created by Ismailov Farrukh on 15/01/24.
//

import UIKit
import Lottie
import SnapKit

class LaunchScreenVC: RxBaseViewController<RxBaseView> {

    private let animationView: LottieAnimationView = .init(name: Lottie.launch)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }

    override func setupHierarchy() {
        view.addSubview(animationView)
    }

    override func setupLayout() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(animationView.snp.width)
        }
    }

    override func setupView() {
        view.backgroundColor = .systemBackground
        animationView.backgroundColor = .clear
    }

    private func setupAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
}
