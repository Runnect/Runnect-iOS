//
//  SplashVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

import SnapKit
import Then

final class SplashVC: UIViewController {

    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.image = ImageLiterals.imgBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let logoImageView = UIImageView().then {
        $0.image = ImageLiterals.imgLogo
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setNavigationBar()
        self.setLayout()
        self.checkDidSignIn()
    }
}

// MARK: - Methods

extension SplashVC {
    private func checkDidSignIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UserManager.shared.hasAccessToken {
                UserManager.shared.getNewToken { [weak self] result in
                    switch result {
                    case .success(let _):
                        print("SplashVC - 토큰 재발급 성공")
                        self?.pushToTabBarController()
                    case .failure(let error):
                        print(error)
                        self?.pushToSignInView()
                    }
                }
                // accessToken 재발급
            } else {
                self.pushToSignInView()
            }
        }
    }
    
    private func pushToSignInView() {
        let signInVC = SignInSocialLoginVC()
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func pushToTabBarController() {
        let tabBarController = TabBarController()
        guard let window = self.view.window else { return }
        ViewControllerUtils.setRootViewController(window: window, viewController: tabBarController, withAnimation: true)
    }
}

// MARK: - UI & Layout

extension SplashVC {
    private func setUI() {
        view.backgroundColor = .m1
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(backgroundImageView, logoImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
