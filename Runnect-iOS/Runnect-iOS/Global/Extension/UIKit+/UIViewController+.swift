//
//  UIViewController+.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

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
    private func showSplashVC() {
        let splashVC = SplashVC()
        let navigationController = UINavigationController(rootViewController: splashVC)
        guard let window = self.view.window else { return }
        ViewControllerUtils.setRootViewController(window: window, viewController: navigationController, withAnimation: true)
    }
}
