//
//  LogoutVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/04/11.
//

import UIKit

import SnapKit
import Then

enum AlertType {
    case defaultType
    case custom
}

final class RNAlertVC: UIViewController {
    
    // MARK: - Properties
    var leftButtonTapAction: (() -> Void)?
    var rightButtonTapAction: (() -> Void)?
    var alertType: AlertType = .defaultType
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 15
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .b4
        $0.textColor = .g2
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var yesButton = UIButton(type: .custom).then {
        $0.setTitle("네", for: .normal)
        $0.titleLabel?.font = .h5
        $0.setTitleColor(.w1, for: .normal)
        $0.layer.backgroundColor = UIColor.m1.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private lazy var noButton = UIButton(type: .custom).then {
        $0.setTitle("아니오", for: .normal)
        $0.titleLabel?.font = .h5
        $0.setTitleColor(.m1, for: .normal)
        $0.layer.backgroundColor = UIColor.m3.cgColor
        $0.layer.cornerRadius = 10
    }
    
    init(description: String) {
        super.init(nibName: nil, bundle: nil)
        self.descriptionLabel.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
}

// MARK: - Methods

extension RNAlertVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if alertType == .defaultType {
            if let touch = touches.first, touch.view == self.view {
                dismiss(animated: false)
            }
        }
    }
    
    private func setAddTarget() {
        self.noButton.addTarget(self, action: #selector(touchUpNoButton), for: .touchUpInside)
        self.yesButton.addTarget(self, action: #selector(touchYesButton), for: .touchUpInside)
    }
    
    @discardableResult
    func setButtonTitle(_ leftButtonTitle: String, _ rightButtonTitle: String) -> Self {
        self.yesButton.setTitle(rightButtonTitle, for: .normal)
        self.noButton.setTitle(leftButtonTitle, for: .normal)
        return self
    }
}

// MARK: - @objc Function

extension RNAlertVC {
    @objc private func touchUpNoButton() {
        alertType == .defaultType ? dismiss(animated: false) : self.leftButtonTapAction?()
    }
    
    @objc private func touchYesButton() {
        self.rightButtonTapAction?()
    }
}

// MARK: - Layout Helpers

extension RNAlertVC {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        containerView.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(containerView)
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        containerView.addSubviews(descriptionLabel, yesButton, noButton)
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(26)
        }
        
        noButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(containerView.snp.centerX).offset(-4)
            $0.height.equalTo(44)
            $0.width.equalTo(145)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        yesButton.snp.makeConstraints {
            $0.top.equalTo(noButton.snp.top)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(containerView.snp.centerX).offset(4)
            $0.height.equalTo(44)
            $0.width.equalTo(145)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
