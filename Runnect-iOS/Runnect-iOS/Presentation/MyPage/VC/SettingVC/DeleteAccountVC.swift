//
//  DeleteAccountVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/04/14.
//

import UIKit

import SnapKit
import Then

final class DeleteAccountVC: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 15
    }
    
    private let logoutQuestionLabel = UILabel().then {
        $0.text = "정말로 탈퇴하시겠어요?"
        $0.font = .b4
        $0.textColor = .g2
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
}

// MARK: - Methods

extension DeleteAccountVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, touch.view == self.view {
            dismiss(animated: false)
        }
    }
    
    private func setAddTarget() {
        self.noButton.addTarget(self, action: #selector(touchUpNoButton), for: .touchUpInside)
    }
}

// MARK: - @objc Function

extension DeleteAccountVC {
    @objc func touchUpNoButton() {
        dismiss(animated: false)
    }
}

// MARK: - Layout Helpers

extension DeleteAccountVC {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        containerView.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(containerView)
        
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(126)
        }
        
        containerView.addSubviews(logoutQuestionLabel, yesButton, noButton)
        
        logoutQuestionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(26)
        }
        
        noButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(containerView.snp.centerX).offset(-4)
            make.height.equalTo(44)
            make.width.equalTo(145)
            make.bottom.equalToSuperview().inset(16)
        }
        
        yesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(containerView.snp.centerX).offset(4)
            make.height.equalTo(44)
            make.width.equalTo(145)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
