//
//  LaunchScreenCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 15/01/24.
//

import UIKit
import RxSwift
import RxRelay

class LaunchScreenCoordinator: Coordinator {

    typealias Container = UIViewController
    internal var container: UIViewController = LaunchScreenVC()

    struct Output {
        let done = PublishRelay<Void>()
    }

    let output = Output()

    internal func start() {
        configure()
    }

    private func configure() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(finishModule), userInfo: nil, repeats: false)
    }

    @objc func finishModule() {
        output.done.accept(())
    }
}


