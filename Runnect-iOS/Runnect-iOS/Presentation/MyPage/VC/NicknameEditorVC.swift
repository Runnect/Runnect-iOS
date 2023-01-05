//
//  NicknameEditorVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/05.
//

import UIKit
import SnapKit
import Then

final class NicknameEditorVC: UIViewController {
    
    // MARK: - UI Components
    
    private let editorContentView = UIView().then {
        $0.layer.cornerRadius = 10
    }
    
    private let nickNameEditLabel = UILabel().then {
        $0.text = "닉네임 수정"
        $0.textColor = .g1
        $0.font = .h5
    }
    
    private let nickNameTextField = UITextField().then {
        $0.resignFirstResponder()
        $0.text = nil
        $0.textColor = .g1
        $0.font = .b6
        $0.attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.g2, NSAttributedString.Key.font: UIFont.b6]
        )
        $0.keyboardType = .webSearch
    }
    
    private let horizontalDivideLine = UIView()
    
    // MARK: - View Life Cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        nickNameTextField.delegate = self
        isTextExist(textField: nickNameTextField)
        view.backgroundColor = .black.withAlphaComponent(0.8)
        setUI()
        setLayout()
        showKeyboard()
    }
}

// MARK: - Method

extension NicknameEditorVC {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, touch.view == self.view {
            dismiss(animated: false)
        }
    }
    
    func showKeyboard() {
        self.nickNameTextField.becomeFirstResponder()
    }
    
    func isTextExist(textField: UITextField) {
        if textField.text == nil {
            textField.enablesReturnKeyAutomatically = false
        } else {
            textField.enablesReturnKeyAutomatically = true
        }
    }
}

// MARK: - @objc Function

extension NicknameEditorVC {
    @objc private func popToPreviousVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NicknameEditorVC {
    
    // MARK: - Layout Helpers
    
    private func setUI() {
        editorContentView.backgroundColor = .w1
        horizontalDivideLine.backgroundColor = .g3
    }
    
    private func setLayout() {
        view.addSubview(editorContentView)
        
        editorContentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(111)
        }
        
        editorContentView.addSubviews(nickNameEditLabel, nickNameTextField, horizontalDivideLine)
        
        nickNameEditLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(24)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameEditLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        horizontalDivideLine.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(nickNameTextField.snp.width)
            make.height.equalTo(0.5)
        }
    }
}

// MARK: - UITextFieldDelegate

extension NicknameEditorVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nickNameTextField {
            self.dismiss(animated: false)
        }
        return true
    }
}
