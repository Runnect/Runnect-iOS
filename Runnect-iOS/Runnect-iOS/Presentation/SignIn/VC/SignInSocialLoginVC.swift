//
//  SignInSocialLoginVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/03/20.
//

import UIKit

import SnapKit
import Then

final class SignInSocialLoginVC: UIViewController {

    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.image = ImageLiterals.imgBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let logoImageView = UIImageView().then {
        $0.image = ImageLiterals.imgLogo
        $0.contentMode = .scaleAspectFill
    }
    
    private let kakaoLoginButton = UIButton(type: .system).then {
        $0.setTitle("카카오로 로그인", for: .normal)
        $0.titleLabel?.font = .b3
        $0.setTitleColor(.black, for: .normal)
        $0.setBackgroundColor(UIColor(hex: "FEE500"), for: .normal)
        $0.layer.cornerRadius = 7
        $0.setImage(ImageLiterals.icKakao, for: .normal)
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 200)
    }
    
    private let appleLoginButton = UIButton(type: .system).then {
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.titleLabel?.font = .b3
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.black, for: .normal)
        $0.layer.cornerRadius = 7
        $0.setImage(ImageLiterals.icApple, for: .normal)
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 200)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        setLayout()
    }
}

// MARK: - UI & Layout

extension SignInSocialLoginVC {
    private func setUI() {
        view.backgroundColor = .m1
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(backgroundImageView, logoImageView, kakaoLoginButton, appleLoginButton)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(54)
            make.height.equalTo(55)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-10)
            make.height.equalTo(55)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
}
