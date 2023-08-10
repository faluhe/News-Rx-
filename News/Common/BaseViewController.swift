//
//  BaseViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit

class BaseViewController<View>: UIViewController where View: BaseView {

    // MARK: - UI components

    let contentView = View()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Overrides

    override func loadView() {
        view = contentView
    }

    // MARK: - Settings

    func commonInit() {
        setupHierarchy()
        setupLayout()
        setupView()
    }

    func setupHierarchy() { }

    func setupLayout() { }

    func setupView() { }
}
