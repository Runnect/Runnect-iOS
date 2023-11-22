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
    func showSplashVC() {
        let splashVC = SplashVC()
        let navigationController = UINavigationController(rootViewController: splashVC)
        guard let window = self.view.window else { return }
        ViewControllerUtils.setRootViewController(window: window, viewController: navigationController, withAnimation: true)
    }
    
    func presentSignInRequestAlertVC() {
        let alertVC = CustomAlertVC(type: .image)
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
        
        emptyView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
    }
    
    func showToastOnWindow(text: String) {
        let window = self.view.window!
        Toast.show(message: text, view: window, safeAreaBottomInset: self.safeAreaBottomInset())
    }
}
