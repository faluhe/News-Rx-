//
//  BaseButton.swift
//  News
//
//  Created by Ismailov Farrukh on 22/12/23.
//

import UIKit
import RxSwift

final class BaseButton: UIButton {

    enum ButtonState {
        case normal
        case disabled
    }

    // MARK: - Override
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? normalBackgroundColor : disabledBackgroundColor
        }
    }

    private(set) var title: String
    private var normalBackgroundColor: UIColor?
    private var disabledBackgroundColor: UIColor?

    // MARK: - Lifecycle
    init(title: String) {
        self.title = title
        super.init(frame: .zero)

        setupButton()
        setupLayout()
    }

    init() {
        title = String()
        super.init(frame: .zero)

        setupButton()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func updateState(_ state: ButtonState) {
        isEnabled = state == .normal
    }

    // MARK: - Settings
    private func setupButton() {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        layer.cornerRadius = 13

        normalBackgroundColor = .systemBlue
        disabledBackgroundColor = .blue.withAlphaComponent(0.6)

        backgroundColor = normalBackgroundColor
    }

    private func setupLayout() {
        snp.makeConstraints { maker in
            maker.height.equalTo(50).priority(999)
        }
    }
}

extension BaseButton {

    func addShadowBehind() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
    }
}

extension BaseButton {

    func underline() {
        guard let title = self.titleLabel else { return }
        guard let tittleText = title.text else { return }
        let attributedString = NSMutableAttributedString(string: (tittleText))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: (tittleText.count)))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension Reactive where Base: BaseButton {

    var action: Observable<Void> {
        base.rx.tap.mapToVoid()
    }
}
