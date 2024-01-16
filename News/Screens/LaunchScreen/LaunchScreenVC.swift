//
//  LaunchScreenVC.swift
//  News
//
//  Created by Ismailov Farrukh on 15/01/24.
//

import UIKit
import Lottie
import SnapKit

class LaunchScreenVC: UIViewController {

    private let animationView: LottieAnimationView = .init(name: Lottie.launch)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupView()
        setupAnimation()
    }

    func setupHierarchy() {
        view.addSubview(animationView)
    }

    func setupLayout() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(animationView.snp.width)
        }
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        animationView.backgroundColor = .clear
    }

    func setupAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
}
