//
//  CustomNavigationBar.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//

import UIKit

import SnapKit
import Then

protocol CustomNavigationBarDelegate: AnyObject {
    func searchButtonDidTap(text: String)
}

@frozen
enum NaviType {
    case title // 좌측 타이틀
    case titleWithLeftButton // 뒤로가기 버튼 + 중앙 타이틀
    case search // 검색창
}

final class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var naviType: NaviType!
    weak var delegate: CustomNavigationBarDelegate?
    private var vc: UIViewController?
    private var leftButtonClosure: (() -> Void)?
    private var rightButtonClosure: (() -> Void)?
    
    // MARK: - UI Components
    
    private let leftTitleLabel = UILabel()
    private let centerTitleLabel = UILabel()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let textField = UITextField()
    
    // MARK: - initialization
    
    init(_ vc: UIViewController, type: NaviType) {
        super.init(frame: .zero)
        self.vc = vc
        self.setUI(type)
        self.setLayout(type)
        self.setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CustomNavigationBar {
    func hideNaviBar(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseInOut) {
            [self.leftTitleLabel, self.centerTitleLabel, self.leftButton, self.rightButton].forEach { $0.alpha = isHidden ? 0 : 1 }
        }
    }
    
    private func setAddTarget() {
        self.leftButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(searchLocation), for: .touchUpInside)
    }
    
    @discardableResult
    func setTitle(_ title: String) -> Self {
        self.leftTitleLabel.text = title
        self.centerTitleLabel.text = title
        return self
    }
    
    @discardableResult
    func resetLeftButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.leftButtonClosure = closure
        self.leftButton.removeTarget(self, action: nil, for: .touchUpInside)
        if closure != nil {
            self.leftButton.addTarget(self, action: #selector(leftButtonDidTap), for: .touchUpInside)
        } else {
            self.setAddTarget()
        }
        return self
    }
    
    @discardableResult
    func resetRightButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.rightButtonClosure = closure
        self.rightButton.removeTarget(self, action: nil, for: .touchUpInside)
        if closure != nil {
            self.rightButton.addTarget(self, action: #selector(rightButtonDidTap), for: .touchUpInside)
        } else {
            self.setAddTarget()
        }
        return self
    }
    
    @discardableResult
    func setTextFieldPlaceholder(placeholder: String) -> Self {
        self.textField.placeholder = placeholder
        return self
    }
    
    @discardableResult
    func setTextFieldText(text: String) -> Self {
        self.textField.text = text
        self.textField.isUserInteractionEnabled = false
        return self
    }
    
    @discardableResult
    func showKeyboard() -> Self {
        self.textField.becomeFirstResponder()
        return self
    }
    
    @discardableResult
    func hideRightButton() -> Self {
        self.rightButton.isHidden = true
        return self
    }
}

// MARK: - @objc Function

extension CustomNavigationBar {
    @objc private func popToPreviousVC() {
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchLocation() {
        guard let text = textField.text else { return }
        delegate?.searchButtonDidTap(text: text)
    }
    
    @objc private func rightButtonDidTap() {
        self.rightButtonClosure?()
    }
    
    @objc private func leftButtonDidTap() {
        self.leftButtonClosure?()
    }
}

// MARK: - UI & Layout

extension CustomNavigationBar {
    private func setUI(_ type: NaviType) {
        self.naviType = type
        self.backgroundColor = .m4
        
        switch type {
        case .title:
            leftTitleLabel.font = .h3
            leftTitleLabel.textColor = .g1
            leftTitleLabel.isHidden = false
        case .titleWithLeftButton:
            centerTitleLabel.text = ""
            centerTitleLabel.font = .h4
            centerTitleLabel.textColor = .g1
            centerTitleLabel.isHidden = false
            leftButton.isHidden = false
            leftButton.setImage(ImageLiterals.icArrowBack, for: .normal)
        case .search:
            leftButton.setImage(ImageLiterals.icArrowBack, for: .normal)
            textField.attributedPlaceholder = NSAttributedString(string: "출발지 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.g3, NSAttributedString.Key.font: UIFont.b1])
            textField.font = .b1
            textField.textColor = .g1
            textField.addLeftPadding(width: 2)
            rightButton.setImage(ImageLiterals.icSearch, for: .normal)
        }
    }
    
    private func setLayout(_ type: NaviType) {
        switch type {
        case .title:
            setTitleLayout()
        case .titleWithLeftButton:
            setTitleWithLeftButtonLayout()
        case .search:
            setSearchLayout()
        }
    }
    
    private func setTitleLayout() {
        self.addSubviews(leftTitleLabel)
        
        leftTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    private func setTitleWithLeftButtonLayout() {
        self.addSubviews(leftButton, centerTitleLabel)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        centerTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setSearchLayout() {
        self.addSubviews(leftButton, textField, rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(leftButton.snp.trailing)
            make.trailing.equalTo(rightButton.snp.leading)
        }
    }
}
