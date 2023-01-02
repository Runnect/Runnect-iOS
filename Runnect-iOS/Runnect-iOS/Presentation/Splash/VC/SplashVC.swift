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
        self.pushToSignInView()
    }
}

// MARK: - Methods

extension SplashVC {
    private func pushToSignInView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let signInVC = SignInVC()
            self.navigationController?.pushViewController(signInVC, animated: true)
        }
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
