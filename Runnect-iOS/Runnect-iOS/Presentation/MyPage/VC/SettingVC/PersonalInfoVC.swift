//
//  PersonalInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/04/11.
//

import UIKit
import AuthenticationServices

import SnapKit
import Then

final class PersonalInfoVC: UIViewController {

    // MARK: - Properties
    
    private let userProvider = Providers.userProvider
    
    var email = String()
        
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("계정 정보")
    private let bottomNavibarDiviedView = UIView()
    private let firstDiviedView = UIView()
    private let secondDiviedView = UIView()
    private let thirdDiviedView = UIView()
    
    private let idContainerView = UIView()
    private let idLabel = UILabel().then {
        $0.font = .b2
        $0.textColor = .g1
        $0.text = "아이디"
    }
    
    private lazy var idEmailInfoLabel = UILabel().then {
        $0.font = .b2
        $0.textColor = .g2
        $0.text = self.email
    }
    
    private lazy var logoutView = makeInfoView(title: "로그아웃").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpLogoutView))
        $0.addGestureRecognizer(tap)
    }
    private lazy var deleteAccountView = makeInfoView(title: "탈퇴하기").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpDeleteAccountView))
        $0.addGestureRecognizer(tap)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - @objc Function

extension PersonalInfoVC {
    @objc
    func touchUpLogoutView() {
        pushToLogoutVC()
    }
    
    @objc
    func touchUpDeleteAccountView() {
        pushToDeleteAccountVC()
    }
}

// MARK: - Methods

extension PersonalInfoVC {
    private func makeInfoView(title: String) -> UIView {
        let containerView = UIView()
        
        let label = UILabel().then {
            $0.text = title
            $0.textColor = .g1
            $0.font = .b2
        }
        
        let icArrowRight = UIImageView().then {
            $0.image = ImageLiterals.icArrowRight
        }
        
        containerView.addSubviews(label, icArrowRight)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.leading.equalToSuperview().offset(18)
        }
        
        icArrowRight.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().inset(10)
        }
        
        return containerView
    }
    
    private func pushToLogoutVC() {
        let logoutVC = RNAlertVC(description: "로그아웃 하시겠어요?")
        logoutVC.rightButtonTapAction = { [weak self] in
            self?.logout()
        }
        logoutVC.modalPresentationStyle = .overFullScreen
        self.present(logoutVC, animated: false)
    }
    
    private func pushToDeleteAccountVC() {
        let deleteAccountVC = RNAlertVC(description: "정말로 탈퇴하시겠어요?")
        deleteAccountVC.rightButtonTapAction = { [weak self] in
            // 애플 유저가 탈퇴할 경우 애플로부터 토큰을 한번 더 받아서 보내주기
            if let isKakao =  UserManager.shared.isKakao, !isKakao {
                // 애플 토큰 받기
                self?.requestAppleToken()
            } else {
                // 카카오 유저 탈퇴
                self?.deleteUser(appleToken: nil)
            }
        }
        deleteAccountVC.modalPresentationStyle = .overFullScreen
        self.present(deleteAccountVC, animated: false)
    }
    
    private func logout() {
        UserManager.shared.logout()
        self.showSplashVC()
    }
    
    private func deleteUserDidComplete() {
        self.logout()
    }
    
    private func showSplashVC() {
        let splashVC = SplashVC()
        let navigationController = UINavigationController(rootViewController: splashVC)
        guard let window = self.view.window else { return }
        ViewControllerUtils.setRootViewController(window: window, viewController: navigationController, withAnimation: true)
    }
    
    private func requestAppleToken() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
                
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - Layout Helpers

extension PersonalInfoVC {
    private func setUI() {
        view.backgroundColor = .w1
        bottomNavibarDiviedView.backgroundColor = .g5
        firstDiviedView.backgroundColor = .g5
        secondDiviedView.backgroundColor = .g5
        thirdDiviedView.backgroundColor = .g5
    }
    
    private func setLayout() {
        view.addSubviews(navibar, bottomNavibarDiviedView, firstDiviedView)
        
        navibar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        bottomNavibarDiviedView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        setIdContainerViewLayout()
        
        firstDiviedView.snp.makeConstraints { make in
            make.top.equalTo(idContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
    }
    
    private func setIdContainerViewLayout() {
        view.addSubviews(idContainerView, firstDiviedView)
        
        idContainerView.snp.makeConstraints { make in
            make.top.equalTo(bottomNavibarDiviedView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        idContainerView.addSubviews(idLabel, idEmailInfoLabel)
        
        idLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        }
        
        idEmailInfoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(18)
        }
        
        firstDiviedView.snp.makeConstraints { make in
            make.top.equalTo(idContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        setLogoutViewLayout()
        setDeleteAccountViewLayout()
    }
    
    private func setLogoutViewLayout() {
        view.addSubviews(logoutView, secondDiviedView)
        
        logoutView.snp.makeConstraints { make in
            make.top.equalTo(firstDiviedView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        secondDiviedView.snp.makeConstraints { make in
            make.top.equalTo(logoutView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    private func setDeleteAccountViewLayout() {
        view.addSubviews(deleteAccountView, thirdDiviedView)
        
        deleteAccountView.snp.makeConstraints { make in
            make.top.equalTo(secondDiviedView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        thirdDiviedView.snp.makeConstraints { make in
            make.top.equalTo(deleteAccountView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}

// MARK: - Network

extension PersonalInfoVC {
    private func deleteUser(appleToken: String?) {
        LoadingIndicator.showLoading()
        self.userProvider.request(.deleteUser(appleToken: appleToken)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try response.map(BaseResponse<UserDeleteResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        print("삭제된 유저 아이디: \(data.deletedUserId)")
                        self.deleteUserDidComplete()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error)
                self.showNetworkFailureToast()
            }
        }
    }
}

extension PersonalInfoVC: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
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
                guard let tokenStr = String(data: idToken, encoding: .utf8) else { return }
             
                print("User ID : \(userIdentifier)")
                print("token : \(String(describing: tokenStr))")
                
                self.deleteUser(appleToken: tokenStr)
            default:
                break
        }
    }
    
    /// Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Login error")
    }
}
