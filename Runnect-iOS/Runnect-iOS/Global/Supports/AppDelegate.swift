//
//  AppDelegate.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

import NMapsMap
import KakaoSDKAuth
import KakaoSDKCommon
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
            
            
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        setRemoteConfig()
        
        NMFAuthManager.shared().clientId = Config.naverMapClientId
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    func setRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        
        /// 개발 중에는 0으로 설정
        settings.minimumFetchInterval = 86400 // 24hour
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate() { (changed, error) in
                    guard let info = Bundle.main.infoDictionary,
                          let currentVersion = info["CFBundleShortVersionString"] as? String,
                          let identifier = info["CFBundleIdentifier"] as? String,
                          let storeVersion = remoteConfig["iOS_current_market_version"].stringValue
                    else { return }
                    
                    if currentVersion.compare(storeVersion, options: .numeric) == .orderedAscending {
                        self.showUpdateAlert()
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }

    func showUpdateAlert() {
        DispatchQueue.main.sync {
            let alert = UIAlertController(
                title: "업데이트 알림",
                message: "새로운 기능이 추가된 'Runnect'의 최신 버전을 만나보세요!\n지금 바로 업데이트하고 개선된 사용자 경험을 즐겨보세요.",
                preferredStyle: .alert
            )
            
            let updateAction = UIAlertAction(title: "업데이트 링크", style: .default) { _ in
                let url = "itms-apps://itunes.apple.com/app/1663884202"
                if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 13.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
            alert.addAction(updateAction)
            if let vc = UIApplication.shared.keyWindow?.rootViewController {
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
}
