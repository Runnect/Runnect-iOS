//
//  NickNameSetUpVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//

import UIKit

import Moya

final class NickNameSetUpVC: UIViewController {
    
    // MARK: - Properties
    
    private var userProvider = Providers.userProvider
    
    private let nicknameMaxLength = 7
    
    // MARK: - UI Components
    
    private let directionLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "RUNNECT", attributes: [.font: UIFont.h2, .foregroundColor: UIColor.m1])
        attributedString.append(NSAttributedString(string: "에서\n사용할 이름을 입력해주세요", attributes: [.font: UIFont.h2_2, .foregroundColor: UIColor.g1]))
        $0.attributedText = attributedString
        $0.numberOfLines = 2
    }
    
    private let personImageView = UIImageView().then {
        $0.image = ImageLiterals.imgPerson
        $0.backgroundColor = .w1
        $0.clipsToBounds = true
    }
    
    private lazy var nicknameTextField = UITextField().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        $0.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g3, .paragraphStyle: paragraphStyle])
        $0.font = .h5
        $0.textColor = .g1
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.g3.cgColor
        $0.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
    }
    
    private let startButton = CustomButton(title: "시작하기").setEnabled(false)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.setAddTarget()
    }
}

// MARK: - Methods

extension NickNameSetUpVC {
    private func setDelegate() {
        self.nicknameTextField.delegate = self
    }
    
    private func setAddTarget() {
        self.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
    
    private func changeTextFieldLayerColor(_ isEditing: Bool) {
        nicknameTextField.layer.borderColor = isEditing ? UIColor.m1.cgColor : UIColor.g3.cgColor
    }
    
    private func pushToTabBarController() {
        let tabBarController = TabBarController()
        guard let window = self.view.window else { return }
        ViewControllerUtils.setRootViewController(window: window, viewController: tabBarController, withAnimation: true)
    }
}

// MARK: - @objc Function

extension NickNameSetUpVC {
    @objc private func textFieldTextDidChange() {
        guard let text = nicknameTextField.text else { return }
        
        startButton.isEnabled = !text.isEmpty
        changeTextFieldLayerColor(!text.isEmpty)
        
        if text.count > nicknameMaxLength {
            let index = text.index(text.startIndex, offsetBy: nicknameMaxLength)
            let newString = text[text.startIndex..<index]
            self.nicknameTextField.text = String(newString)
        }
    }
    
    @objc func startButtonDidTap() {
        guard let nickname = nicknameTextField.text else { return }
        self.updateUserNickname(nickname: nickname)
    }
}

// MARK: - UI & Layout

extension NickNameSetUpVC {
    private func setUI() {
        view.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(directionLabel, personImageView, nicknameTextField, startButton)
        
        directionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        personImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(directionLabel.snp.bottom).offset(93.adjustedH)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(personImageView.snp.bottom).offset(34)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(44)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(44)
        }
    }
}

// MARK: - UITextFieldDelegate

extension NickNameSetUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Network

extension NickNameSetUpVC {
    func updateUserNickname(nickname: String) {
        LoadingIndicator.showLoading()
        userProvider.request(.updateUserNickname(nickname: nickname)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<BlankData>.self)
                        if responseDto.status == 200 {
                            self.pushToTabBarController()
                        } else {
                            self.showToast(message: responseDto.message)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
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
