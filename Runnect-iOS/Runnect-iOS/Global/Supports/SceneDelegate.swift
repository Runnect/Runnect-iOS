//
//  SceneDelegate.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import FirebaseDynamicLinks
import FirebaseCore
import FirebaseCoreInternal

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        print("🔥 scene에서 willConnectTo 동작 🔥")
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first {
            print("🔥 scene에서 userActivity 동작 🔥")
            self.scene(scene, continue: userActivity)
        }
        
        print("🔥 scene에서 SplashVC() 동작 🔥")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController(rootViewController: SplashVC())
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks()
                .handleUniversalLink(incomingURL) { dynamicLink, error in
                    
                    
                    if let courseId = self.handleDynamicLink(dynamicLink) {
                        guard let _ = (scene as? UIWindowScene) else { return }
                        
                        if let windowScene = scene as? UIWindowScene {
                            let window = UIWindow(windowScene: windowScene)
                            
                            let rootVC = CourseDetailVC()
                            rootVC.setPublicCourseId(publicCourseId: Int(courseId))
                            rootVC.getUploadedCourseDetail(courseId: Int(courseId))
                            
                            // CourseDetailVC를 NavigationController로 감싸고, rootViewController로 설정합니다.
                            let navigationController = UINavigationController(rootViewController: rootVC)
                            window.rootViewController = navigationController
                            window.makeKeyAndVisible()
                            self.window = window
                        }
                    }
                }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("🔥 SceneDelegate의 openURLContexts입니다~ 🔥")
        
        print(URLContexts)
        print(URLContexts.first!)
        
        if let url = URLContexts.first?.url {
            // Firebase Dynamic Links를 사용하여 딥 링크를 처리합니다.
            print("🔥 SceneDelegate의 url은 : \(url) 🔥")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
                if let courseId = self.handleDynamicLink(dynamicLink) {
                    guard let _ = (scene as? UIWindowScene) else { return }
                    
                    if let windowScene = scene as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        window.overrideUserInterfaceStyle = .light
                        
                        // CourseDetailVC 인스턴스를 생성합니다.
                        let rootVC = CourseDetailVC()
                        rootVC.setPublicCourseId(publicCourseId: Int(courseId))
                        
                        // CourseDetailVC를 NavigationController로 감싸고, rootViewController로 설정합니다.
                        let navigationController = UINavigationController(rootViewController: rootVC)
                        window.rootViewController = navigationController
                        window.makeKeyAndVisible()
                        self.window = window
                    }
                }
            }
            print("🔥 바인딩 유무 ", linkHandled, "🔥")
            
            // Kakao SDK가 처리해야 하는지 확인합니다.
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func handleDynamicLink(_ dynamicLink: DynamicLink?) -> String? {
        if let dynamicLink = dynamicLink, let url = dynamicLink.url,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for item in queryItems {
                if item.name == "courseId", let courseId = item.value {
                    // courseId를 사용하여 특정 뷰로 이동
                    // 예: courseId를 기반으로 상세 화면을 열거나 특정 기능 수행
                    print("🔥코스아이디가 제대로 여기까지 오는가!", courseId, "🔥")
                    return courseId
                }
            }
        }
        return nil
    }
    
}

extension CourseDetailVC {

    func getUploadedCourseDetail(courseId: Int?) {
        guard let publicCourseId = courseId else { return }
        LoadingIndicator.showLoading()
        Providers.publicCourseProvider.request(.getUploadedCourseDetail(publicCourseId: publicCourseId)) { [weak self] response in
            guard let self = self else { return }
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<UploadedCourseDetailResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setData(model: data)
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
