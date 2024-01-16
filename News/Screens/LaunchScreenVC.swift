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

    private let animationView: LottieAnimationView = .init(name: "LottieAnimation")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupView()
        setupAnimation()
    }

    func setupHierarchy() {
        view.addSubview(animationView)
    }

    func setupView() {
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }

}
