//
//  BaseViewController.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxSwift

class RxBaseViewController<View>: UIViewController where View: RxBaseView {

    var bag = DisposeBag()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
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

    func setupBinding() { }
}
