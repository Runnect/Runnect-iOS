//
//  UploadViewController.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/05.
//

import UIKit

class CourseUploadVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("코스 업로드")
    private let buttonContainerView = UIView()
    private let uploadButton = CustomButton(title: "업로드하기").setColor(bgColor: .g3, disableColor: .g3, textColor: .w1)
    private let mapImageView = UIImageView().then {
        $0.image = UIImage(named: "")
    }
    private let courseTitleTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "글 제목",
            attributes: [.font: UIFont.h4, .foregroundColor: UIColor.g3]
        )
        $0.font = .h4
        $0.textColor = .g1
        $0.addLeftPadding(width: 2)
    }
    private let distanceInfoView = CourseDetailInfoView(title: "거리",description: "0.0km")
    
    private let departureInfoView = CourseDetailInfoView(title: "출발지", description: "패스트파이브 을지로점")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

// MARK: - Methods



// MARK: - @objc Function



// MARK: - naviVar Layout

extension CourseUploadVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        navibar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    // MARK: - setUI
    
    private func setUI() {
        view.backgroundColor = .w1
        buttonContainerView.backgroundColor = .w1
        mapImageView.backgroundColor = .systemGray4
    }
    
    // MARK: - Layout Helpers
    private func setLayout() {
        view.addSubviews(mapImageView,
                         courseTitleTextField,
                         distanceInfoView,
                         departureInfoView,
                         buttonContainerView)
        buttonContainerView.addSubview(uploadButton)
        self.view.bringSubviewToFront(uploadButton)
        
        mapImageView.snp.makeConstraints { make in
            make.top.equalTo(self.navibar.snp.bottom)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(313)
        }
        courseTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(35)
        }
        
        distanceInfoView.snp.makeConstraints { make in
            make.top.equalTo(courseTitleTextField.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        departureInfoView.snp.makeConstraints { make in
            make.top.equalTo(distanceInfoView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        buttonContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(86)
            make.bottom.equalToSuperview()
        }
        uploadButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    private func setTextFieldBottomBorder() {
        courseTitleTextField.addBottomBorder(height: 2)
    }
}
