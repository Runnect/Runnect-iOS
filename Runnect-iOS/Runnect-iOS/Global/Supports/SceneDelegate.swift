//
//  SceneDelegate.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController(rootViewController: SplashVC())
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        print("🔥 scene에서 뷰 동작 🔥")
        
        if let url = URLContexts.first?.url {
            
            print("🔥 url : \(url)🔥 \n")
            
            if url.scheme == "kakao27d01e20b51e5925bf386a6c5465849f" { // 앱의 URL Scheme를 확인합니다.

                if let host = url.host, host == "kakaolink" {
                    // 딥링크 경로가 "detail"일 경우 CourseDetailView로 이동하도록 처리합니다.
                    if let courseIdString = url.queryParameters?["publicCourseId"], let courseId = Int(courseIdString) {
                        
                        print("🔥 url.queryParameters : \(url.queryParameters!)🔥 \n")
                        print("🔥 courseIdString : \(courseIdString)🔥 \n")
                        let courseDetailVC = CourseDetailVC() // 해당 뷰 컨트롤러 클래스를 생성합니다.
//                        courseDetailVC.courseId = courseId // CourseDetailView에 값을 전달합니다.

                        // 이제 courseDetailVC를 현재 화면에 추가하거나 모달로 표시할 수 있습니다.
                        // 예를 들어, 현재의 루트 뷰 컨트롤러에 추가하는 경우:
//                        if let rootViewController = window?.rootViewController {
//                            rootViewController.addChild(courseDetailVC)
//                            rootViewController.view.addSubview(courseDetailVC.view)
//                            courseDetailVC.didMove(toParent: rootViewController)
//                        }
                    }
                }

            }
        
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
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
    
}

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else {
                return nil
        }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }

        return parameters
    }
}

