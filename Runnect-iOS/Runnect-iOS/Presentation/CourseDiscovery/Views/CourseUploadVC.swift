//
//  UploadViewController.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/05.
//

import UIKit

import SnapKit
import Then

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
    private let distanceInfoView = CourseDetailInfoView(title: "거리", description: "0.0km")
    private let departureInfoView = CourseDetailInfoView(title: "출발지", description: "패스트파이브 을지로점")
    private let placeholder = "코스에 대한 소개를 적어주세요.(난이도/풍경/지형)"
    
    let activityTextView = UITextView().then {
        $0.font = .b4
        $0.backgroundColor = .m3
        $0.tintColor = .m1
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        setupTextView()

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
                         buttonContainerView,
                         activityTextView)
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
        activityTextView.snp.makeConstraints { make in
            make.top.equalTo(departureInfoView.snp.bottom).offset(34)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonContainerView.snp.top).offset(-13)
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
    
    func setupTextView() {
        activityTextView.delegate = self
        activityTextView.text = placeholder
        activityTextView.textColor = .g3
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension CourseUploadVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            activityTextView.textColor = .g3
            activityTextView.text = placeholder
        } else if textView.text == placeholder {
            activityTextView.textColor = .g1
            activityTextView.text = nil
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if activityTextView.text.count > 150 {
            activityTextView.deleteBackward()
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == placeholder {
            activityTextView.textColor = .g3
            activityTextView.text = placeholder
            uploadButton.setColor(bgColor: .m3, disableColor: .g3)
        }
    }
}
