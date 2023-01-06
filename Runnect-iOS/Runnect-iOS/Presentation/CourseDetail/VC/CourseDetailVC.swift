//
//  CourseDetailVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/05.
//

import UIKit
import SnapKit
import Then

final class CourseDetailVC: UIViewController {
    
    private var textFieldMaxLength: Int = 150
    
    // MARK: - UI Components
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton)
    private let middleScorollView = UIScrollView()
    private let bottomView = UIView()
    private let firstHorizontalDivideLine = UIView()
    private let secondHorizontalDivideLine = UIView()
    
    private let likeButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icHeart, for: .normal)
        $0.tintColor = .g2
    }
    
    private let startButton = CustomButton(title: "시작하기")
    
    private let mapImage = UIImageView()
    private let profileImage = UIImageView().then {
        $0.image = ImageLiterals.imgStampC3
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.m3.cgColor
    }
    
    private let profileNameLabel = UILabel().then {
        $0.text = "말랑콩떡"
        $0.textColor = .g1
        $0.font = .h5
    }
    
    private let runningLevelLabel = UILabel().then {
        $0.text = "Lv. 3"
        $0.textColor = .m1
        $0.font = .b5
    }
    
    private let courseTitleLabel = UILabel().then {
        $0.text = "잠실 석촌호수 한 바퀴 러닝"
        $0.textColor = .g1
        $0.font = .h4
    }

    private let courseDistanceLabel = CourseDetailInfoView(title: "거리", description: "2.3km")
    
    private let courseDepartureLabel = CourseDetailInfoView(title: "출발지", description: "패스트파이브 을지로점")
    
    private lazy var courseDetailStackView = UIStackView(arrangedSubviews: [courseDistanceLabel, courseDepartureLabel]).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.distribution = .fillEqually
    }
    
    private let courseExplanationLabel = UITextView().then {
        $0.text = nil
        $0.textColor = .g1
        $0.font = .b3
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
    }
}

// MARK: - Method


extension CourseDetailVC {
    
    // MARK: - Layout Helpers
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints {  make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        bottomView.backgroundColor = .blue
        middleScorollView.backgroundColor = .brown
        mapImage.backgroundColor = .g3
        firstHorizontalDivideLine.backgroundColor = .g3
        secondHorizontalDivideLine.backgroundColor = .g5
    }
    
    private func setLayout() {
        view.addSubviews(middleScorollView, bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(84)
        }
        
        bottomView.addSubviews(likeButton, startButton)
        
        likeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalToSuperview().offset(26)
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        setMiddleScrollView()
    }
    
    private func setMiddleScrollView() {
        middleScorollView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        middleScorollView.addSubviews(mapImage, profileImage, profileNameLabel, runningLevelLabel, firstHorizontalDivideLine, courseTitleLabel, courseDetailStackView, secondHorizontalDivideLine, courseExplanationLabel)
        
        mapImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(middleScorollView.snp.width).multipliedBy(0.7)
        }
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(mapImage.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(14)
            make.width.height.equalTo(34)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
        }
        
        runningLevelLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileNameLabel.snp.bottom)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(31)
        }
        
        firstHorizontalDivideLine.snp.makeConstraints { make in
            make.top.equalTo(mapImage.snp.bottom).offset(62)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(0.5)
        }
        
        courseTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(firstHorizontalDivideLine.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        courseDetailStackView.snp.makeConstraints { make in
            make.top.equalTo(courseTitleLabel.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        secondHorizontalDivideLine.snp.makeConstraints { make in
            make.top.equalTo(courseDetailStackView.snp.bottom).offset(27)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(8)
        }
        
        courseExplanationLabel.snp.makeConstraints { make in
            make.top.equalTo(secondHorizontalDivideLine.snp.bottom).offset(3)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(135)
        }
    }
}

