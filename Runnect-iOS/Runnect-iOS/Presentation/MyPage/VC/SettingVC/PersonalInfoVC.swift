//
//  PersonalInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/04/11.
//

import UIKit

import SnapKit
import Then

final class PersonalInfoVC: UIViewController {
    
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
    
    private let idEmailInfoLabel = UILabel().then {
        $0.font = .b2
        $0.textColor = .g2
        $0.text = "dlwogus0128@ajou.ac.kr"
    }
    
    private lazy var logoutView = makeInfoView(title: "로그아웃")
    private lazy var deleteAccountView = makeInfoView(title: "탈퇴하기")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
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
