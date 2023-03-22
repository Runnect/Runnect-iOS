//
//  SignInSocialLoginVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/03/20.
//

import UIKit

import SnapKit
import Then
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

final class SignInSocialLoginVC: UIViewController {
    
    // MARK: - Properties

    let screenWidth = UIScreen.main.bounds.width

    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.image = ImageLiterals.imgBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let logoImageView = UIImageView().then {
        $0.image = ImageLiterals.imgLogo
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var kakaoLoginButton = UIButton(type: .system).then {
        $0.setTitle("카카오로 로그인", for: .normal)
        $0.titleLabel?.font = .b3
        $0.setTitleColor(.black, for: .normal)
        $0.setBackgroundColor(UIColor(hex: "FEE500"), for: .normal)
        $0.layer.cornerRadius = 7
        $0.setImage(ImageLiterals.icKakao, for: .normal)
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: self.screenWidth * 0.5)
        $0.tintColor = .black
    }
    
    private lazy var appleLoginButton = UIButton(type: .system).then {
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.titleLabel?.font = .b3
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.black, for: .normal)
        $0.layer.cornerRadius = 7
        $0.setImage(ImageLiterals.icApple, for: .normal)
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: self.screenWidth * 0.5)
        $0.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        setLayout()
        setAddTarget()
    }
}

// MARK: - @objc Function

extension SignInSocialLoginVC {
    @objc func touchUpAppleLoginButton() {
        pushToAppleLogin()
    }
    
    @objc func pushToAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
                
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func kakaoLoginButtonDidTap(_ sender: Any) {
        // isKakaoTalkLoginAvailable() : 카톡 설치 되어있으면 true
        if (UserApi.isKakaoTalkLoginAvailable()) { //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 톡으로 로그인 성공")
                    
                    _ = oauthToken
                    /// 로그인 관련 메소드 추가
                    
                }
            }
        } else {

            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정으로 로그인 성공")
                    
                    _ = oauthToken
                    // 관련 메소드 추가
                }
            }
        }
    }
}

// MARK: - Methods

extension SignInSocialLoginVC {
    private func setAddTarget() {
        self.appleLoginButton.addTarget(self, action: #selector(touchUpAppleLoginButton), for: .touchUpInside)
        self.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
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

// MARK: - ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate

extension SignInSocialLoginVC: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    /// Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            switch authorization.credential {
                /// Apple ID
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                /// 계정 정보 가져오기
                let userIdentifier = appleIDCredential.user
                let idToken = appleIDCredential.identityToken!
                let tokeStr = String(data: idToken, encoding: .utf8)
             
                print("User ID : \(userIdentifier)")
                print("token : \(String(describing: tokeStr))")
                
            default:
                break
        }
    }
    
    /// Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Login error")
    }
}
