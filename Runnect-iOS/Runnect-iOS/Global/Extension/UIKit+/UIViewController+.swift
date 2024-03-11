//
//  UIViewController+.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

import SnapKit
import FirebaseDynamicLinks

extension UIViewController {
    
    /**
     - Description: 화면 터치시 작성 종료
     */
    /// 화면 터치시 작성 종료하는 메서드
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /**
     - Description: 화면 터치시 키보드 내리는 Extension
     */
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// tabBar 숨기기
    func hideTabBar(wantsToHide: Bool) {
        self.tabBarController?.tabBar.isHidden = wantsToHide
    }
    
    /// 인증 과정을 다시 거치도록 SplashVC로 보내기
    func showSplashVC() {
        let splashVC = SplashVC()
        let navigationController = UINavigationController(rootViewController: splashVC)
        guard let window = self.view.window else { return }
        ViewControllerUtils.setRootViewController(window: window, viewController: navigationController, withAnimation: true)
    }
    
    func presentSignInRequestAlertVC() {
        let alertVC = CustomAlertVC()
            .setTitle("가입 후 로그인 시 코스를 저장하고 달릴 수 있어요!")
            .setLeftButtonTitle(NSAttributedString(string: "닫기", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.m1]))
            .setRightButtonTitle(NSAttributedString(string: "가입하기", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.w1]))
        alertVC.modalPresentationStyle = .overFullScreen
        
        alertVC.leftButtonTapAction = {
            alertVC.dismiss(animated: false)
        }
        
        alertVC.rightButtonTapAction = {
            self.showSplashVC()
        }
        
        self.present(alertVC, animated: false)
        alertVC.setImage(ImageLiterals.imgSpaceship, size: CGSize(width: 229, height: 136))
    }
    
    func handleVisitor() -> Bool {
        guard UserManager.shared.userType == .visitor else { return true }
        self.presentSignInRequestAlertVC()
        return false
    }
    
    func showSignInRequestEmptyView() {
        let emptyView = ListEmptyView(description: "러넥트에 가입하면 내가 그린 코스와\n 스크랩 코스를 관리할 수 있어요!",
                                      buttonTitle: "가입하기")
        emptyView.buttonTapAction = {
            self.showSplashVC()
        }
        
        emptyView.setImage(ImageLiterals.imgSpaceship, size: CGSize(width: 229, height: 136))
        
        self.view.addSubview(emptyView)
        
        emptyView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
    }
    
    func showToastOnWindow(text: String) {
        let window = self.view.window!
        Toast.show(message: text, view: window, safeAreaBottomInset: self.safeAreaBottomInset())
    }
}

extension UIViewController {
    
    /**
     ### Description: 공유 기능에 해당하는 정보를 넣어줍니다.
        2025년 8월 25일에 동적링크는 만기 됩니다.
     
     - courseTitle : 타이틀 이름
     - courseId : 코스 아이디
     - courseImageURL : 코스 사진
     - minimumAppVersion : 공유 기능을 사용할 수 있는 최소 버전
     - descriptionText : 내용
     - parameter : 공유 기능에 필요한 파라미터
     */
    /// 공유 기능 메서드
    ///
    func shareCourse(
        courseTitle: String,
        courseId: Int,
        courseImageURL: String,
        minimumAppVersion: String,
        descriptionText: String? = nil,
        parameter: String
    ) {
        let dynamicLinksDomainURIPrefix = "https://rnnt.page.link"
        let courseParameter = parameter
        guard let link = URL(string: "\(dynamicLinksDomainURIPrefix)/?\(courseParameter)=\(courseId)") else {
            print("Invalid link.")
            return
        }
        
        guard let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) else {
            print("Failed to create link builder.")
            return
        }
        
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.runnect.Runnect-iOS")
        linkBuilder.iOSParameters?.appStoreID = "1663884202"
        linkBuilder.iOSParameters?.minimumAppVersion = minimumAppVersion
        
        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.runnect.runnect")
        
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: courseImageURL)
        linkBuilder.socialMetaTagParameters?.title = courseTitle
        linkBuilder.socialMetaTagParameters?.descriptionText = descriptionText ?? ""
        
        linkBuilder.shorten { [weak self] url, _, error in
            guard let shortDynamicLink = url?.absoluteString else {
                if let error = error {
                    print("Error shortening dynamic link: \(error)")
                }
                return
            }
            
            print("Short URL is: \(shortDynamicLink)")
            DispatchQueue.main.async {
                self?.presentShareActivity(with: shortDynamicLink)
            }
        }
    }
    
    private func presentShareActivity(with url: String) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension UIViewController {
    /**
     - Description: 뷰컨에서 GA(구글 애널리틱스) 스크린 , 버튼 이벤트 사용 사는 메서드 입니다.
     */
    
    /// 스크린 이벤트
    func analyze(screenName: String) {
        GAManager.shared.logEvent(eventType: .screen(screenName: screenName))
    }
    
    /// 버튼 이벤트
    func analyze(buttonName: String) {
        GAManager.shared.logEvent(eventType: .button(buttonName: buttonName))
    }
}
