//
//  SplashVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit
import Combine

import FirebaseRemoteConfig
import SnapKit
import Then

final class SplashVC: UIViewController {
    
    // MARK: - Property
    
    private var cancelBag = CancelBag()
    
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
        self.setRemoteConfig()
        self.setObserver()
    }
}

// MARK: - Methods

extension SplashVC {
    private func checkDidSignIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UserManager.shared.hasAccessToken {
                UserManager.shared.getNewToken { [weak self] result in
                    switch result {
                    case .success:
                        print("SplashVC-토큰 재발급 성공")
                        self?.pushToTabBarController()
                    case .failure(let error):
                        print(error)
                        self?.pushToSignInView()
                    }
                }
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

// MARK: - Remote Config

extension SplashVC {
    /// ** RemoteConfig  **
    /// 심사버전 > 스토어 버전이면 강제 업데이트 Alert을 진행 합니다.
    private func setRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        
        settings.minimumFetchInterval = 86400 // 개발 중에는 0으로 설정, 실제 앱에서는 적절한 값을 설정
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { (_, _) in
                    // 현재 앱 버전 가져오기
                    guard let info = Bundle.main.infoDictionary,
                          let currentVersion = info["CFBundleShortVersionString"] as? String,
                          let storeVersion = remoteConfig["iOS_current_market_version"].stringValue
                    else { return }
                    
                    let splitCurrentVersion = currentVersion.split(separator: ".").map { $0 }
                    let splitStoreVersion = storeVersion.split(separator: ".").map { $0 }
                    
                    if splitCurrentVersion[0] < splitStoreVersion[0] {
                        // 스토어 버전이 더 높으면 업데이트 필요
                        self.showUpdateAlert()
                    } else {
                        // 업데이트가 필요하지 않으면 기본 로직 수행
                        self.checkDidSignIn()
                    }
                }
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "No error available.")")
                self.checkDidSignIn()
            }
        }
    }
    private func showUpdateAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "업데이트 알림",
                message: "새로운 기능이 추가된 'Runnect'의 최신 버전을 만나보세요!\n지금 바로 업데이트하고 개선된 사용자 경험을 즐겨보세요.",
                preferredStyle: .alert
            )
            
            let updateAction = UIAlertAction(title: "업데이트 링크", style: .default) { [self] _ in
                self.openAppstore()
            }
            
            alert.addAction(updateAction)
            
            self.present(alert, animated: false)
            
        }
    }
    
    private func openAppstore() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/1663884202") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 13.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func setObserver() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.setRemoteConfig()
            }
            .store(in: cancelBag)
    }
}
