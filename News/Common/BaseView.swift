//
//  BaseView.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxSwift

class RxBaseView: UIView {

    var bag = DisposeBag()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Settings
    func commonInit() {
        setupHierarchy()
        setupView()
        setupLayout()
    }

    func setupHierarchy() { }

    func setupLayout() { }

    func setupView() {
        backgroundColor = Color.backgroundColor
    }
}

fileprivate extension RxBaseView {
    enum Color {
        static let backgroundColor = UIColor.systemBackground
    }
}
