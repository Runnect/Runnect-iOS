//
//  NicknameEditorVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/05.
//

import UIKit

import SnapKit
import Then
import Moya

protocol NicknameEditorVCDelegate: AnyObject {
    func nicknameEditDidSuccess()
}

final class NicknameEditorVC: UIViewController {
    
    // MARK: - Properties
    
    private var userProvider = Providers.userProvider
    
    weak var delegate: NicknameEditorVCDelegate?
    
    private let nicknameMaxLength: Int = 7
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("닉네임 수정")

    private let nickNameTextField = UITextField().then {
        $0.resignFirstResponder()
        $0.text = nil
        $0.textColor = .g1
        $0.font = .h5
        $0.textAlignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력하세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.g2, NSAttributedString.Key.font: UIFont.h5]
        )
        $0.keyboardType = .webSearch
    }
    
    private let personImageView = UIImageView().then {
        $0.image = ImageLiterals.imgPerson
    }
    
    private let nickNameContainer = UIView().then {
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.m1.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var finishNickNameLabel = UILabel().then {
        $0.text = "완료"
        $0.font = .h4
        $0.textColor = .m1
        let tap = UITapGestureRecognizer(target: self, action: #selector(finishEditNickname))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
    }
    
    // MARK: - View Life Cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTextField.delegate = self
        isTextExist(textField: nickNameTextField)
        setUI()
        setLayout()
        showKeyboard()
        setAddTarget()
    }
}

// MARK: - Method

extension NicknameEditorVC {
    private func setAddTarget() {
        nickNameTextField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
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
    
    @objc private func didNicknameReturn() {
        guard let nickname = nickNameTextField.text else { return }
        self.updateUserNickname(nickname: nickname)
    }
    
    @objc private func textFieldTextDidChange() {
        guard let text = nickNameTextField.text else { return }
                
        if text.count > nicknameMaxLength {
            let index = text.index(text.startIndex, offsetBy: nicknameMaxLength)
            let newString = text[text.startIndex..<index]
            self.nickNameTextField.text = String(newString)
        }
    }
    
    @objc private func finishEditNickname() {
        didNicknameReturn()
        self.navigationController?.popViewController(animated: false)
    }
}

// MARK: - Layout Helpers

extension NicknameEditorVC {
    private func setUI() {
        view.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(navibar, finishNickNameLabel, personImageView, nickNameContainer)
        
        navibar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        finishNickNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(23)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        personImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(96)
            make.top.equalTo(navibar.snp.bottom).offset(98)
        }
        
        nickNameContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(44)
            make.top.equalTo(personImageView.snp.bottom).offset(51)
        }
        
        nickNameContainer.addSubview(nickNameTextField)
        
        nickNameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - UITextFieldDelegate

extension NicknameEditorVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nickNameTextField {
            finishEditNickname()
        }
        return true
    }
}

// MARK: - Network

extension NicknameEditorVC {
    func updateUserNickname(nickname: String) {
        LoadingIndicator.showLoading()
        userProvider.request(.updateUserNickname(nickname: nickname)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    self.delegate?.nicknameEditDidSuccess()
                    self.dismiss(animated: false)
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
}
