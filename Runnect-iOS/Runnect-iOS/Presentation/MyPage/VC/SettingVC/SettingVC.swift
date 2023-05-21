//
//  SettingVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/04/10.
//

import UIKit

import SnapKit
import Then
import SafariServices

final class SettingVC: UIViewController {

    private var email = String()
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("설정")
    private let bottomNavibarDiviedView = UIView()
    private let firstDiviedView = UIView()
    private let secondDiviedView = UIView()
    private let thirdDiviedView = UIView()
    
    let reportUrl = NSURL(string: "https://docs.google.com/forms/d/e/1FAIpQLSek2rkClKfGaz1zwTEHX3Oojbq_pbF3ifPYMYezBU0_pe-_Tg/viewform")
    lazy var reportSafariView: SFSafariViewController = SFSafariViewController(url: self.reportUrl! as URL)
    
    let termsOfServiceUrl = NSURL(string: "https://www.notion.so/Runnect-81cf5a3a507b40e4b6104b5d08f12792?pvs=4")
    lazy var termsOfServiceSafariView: SFSafariViewController = SFSafariViewController(url: self.termsOfServiceUrl! as URL)
    
    private lazy var personalInfoView = makeInfoView(title: "계정 정보").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpPersonalInfoView))
        $0.addGestureRecognizer(tap)
    }

    private lazy var reportView = makeInfoView(title: "문의 및 신고하기").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpReportView))
        $0.addGestureRecognizer(tap)
    }
    
    private lazy var termsOfServiceView = makeInfoView(title: "이용약관").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpTermsOfServiceView))
        $0.addGestureRecognizer(tap)
    }
        
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension SettingVC {
    func setData(email: String) {
        self.email = email
    }
    
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
    
    private func pushToPersonalInfoVC() {
        let personalInfoVC = PersonalInfoVC()
        personalInfoVC.email = self.email
        self.navigationController?.pushViewController(personalInfoVC, animated: true)
    }
}

// MARK: - @objc Function

extension SettingVC {
    @objc
    private func touchUpPersonalInfoView() {
        pushToPersonalInfoVC()
    }
    
    @objc
    private func touchUpReportView() {
        self.present(self.reportSafariView, animated: true, completion: nil)
    }
    
    @objc
    private func touchUpTermsOfServiceView() {
        self.present(self.termsOfServiceSafariView, animated: true, completion: nil)
    }
}

// MARK: - UI & Layout

extension SettingVC {
    private func setUI() {
        view.backgroundColor = .w1
        bottomNavibarDiviedView.backgroundColor = .g5
        firstDiviedView.backgroundColor = .g5
        secondDiviedView.backgroundColor = .g5
        thirdDiviedView.backgroundColor = .g5
    }
    
    private func setLayout() {
        view.addSubviews(navibar, bottomNavibarDiviedView)
        
        navibar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        bottomNavibarDiviedView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        setPersonalInfoViewLayout()
        setReportViewLayout()
        setTermsOfServiceViewLayout()
    }
    
    private func setPersonalInfoViewLayout() {
        view.addSubviews(personalInfoView, firstDiviedView)
        
        personalInfoView.snp.makeConstraints { make in
            make.top.equalTo(bottomNavibarDiviedView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        firstDiviedView.snp.makeConstraints { make in
            make.top.equalTo(personalInfoView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    private func setReportViewLayout() {
        view.addSubviews(reportView, secondDiviedView)
        
        reportView.snp.makeConstraints { make in
            make.top.equalTo(firstDiviedView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        secondDiviedView.snp.makeConstraints { make in
            make.top.equalTo(reportView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    private func setTermsOfServiceViewLayout() {
        view.addSubviews(termsOfServiceView, thirdDiviedView)
        
        termsOfServiceView.snp.makeConstraints { make in
            make.top.equalTo(secondDiviedView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        thirdDiviedView.snp.makeConstraints { make in
            make.top.equalTo(termsOfServiceView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
