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
    
    // MARK: - Properties
    
    private var courseId: Int?
    private var publicCourseId: Int?
    
    // MARK: - UI Components
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton)
    private lazy var middleScorollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    private let bottomView = UIView()
    private let firstHorizontalDivideLine = UIView()
    private let secondHorizontalDivideLine = UIView()
    private let thirdHorizontalDivideLine = UIView()
    
    private lazy var likeButton = UIButton(type: .custom).then {
        $0.setImage(ImageLiterals.icHeart, for: .normal)
        $0.setImage(ImageLiterals.icHeartFill, for: .selected)
        $0.tintColor = .g2
        $0.backgroundColor = .w1
    }
    
    private lazy var startButton = CustomButton(title: "시작하기").then {
        $0.addTarget(self, action: #selector(pushToCountDownVC), for: .touchUpInside)
    }
    
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
    
    private lazy var courseExplanationTextView = UITextView().then {
        $0.text = "석촌 호수 한 바퀴 뛰는 코스에요! 평탄한 길과 느린 페이스, 난이도 하 코스입니다! 롯데월드 야경 감상 하면서 뛰기에 좋은 야간 코스에요! 석촌 호수 한 바퀴 뛰는 코스에요! 평탄한 길과 느린 페이스, 난이도 하 코스입니다! 롯데월드 야경 감상 하면서 뛰기에 좋은"
        $0.isEditable = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attributedString = NSMutableAttributedString(string: $0.text, attributes: [.font: UIFont.b3, .foregroundColor: UIColor.g1])
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        $0.attributedText = attributedString
        $0.isScrollEnabled = false
        $0.sizeToFit()
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        setAddTarget()
    }
}

// MARK: - @objc Function

extension CourseDetailVC {
    @objc func likeButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc private func pushToCountDownVC() {
        let countDownVC = CountDownVC()
        let runningModel = RunningModel(locations: [],
                                        distance: "1.0",
                                        pathImage: UIImage())
        countDownVC.setData(runningModel: runningModel)
        self.navigationController?.pushViewController(countDownVC, animated: true)
    }
}

// MARK: - Method

extension CourseDetailVC {
    func setCourseId(courseId: Int?, publicCourseId: Int?) {
        self.courseId = courseId
        self.publicCourseId = publicCourseId
    }
    
    private func setAddTarget() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
    }
}

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
        bottomView.backgroundColor = .w1
        middleScorollView.backgroundColor = .w1
        mapImage.backgroundColor = .g3
        firstHorizontalDivideLine.backgroundColor = .g3
        secondHorizontalDivideLine.backgroundColor = .g5
        thirdHorizontalDivideLine.backgroundColor = .g3
    }
    
    private func setLayout() {
        view.addSubviews(middleScorollView, thirdHorizontalDivideLine, bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(84)
        }
        
        thirdHorizontalDivideLine.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0.5)
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
            make.bottom.equalTo(thirdHorizontalDivideLine.snp.top)
        }
        
        middleScorollView.addSubviews(mapImage, profileImage, profileNameLabel, runningLevelLabel, firstHorizontalDivideLine, courseTitleLabel, courseDetailStackView, secondHorizontalDivideLine, courseExplanationTextView)
        
        mapImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
        
        courseExplanationTextView.snp.makeConstraints { make in
            make.top.equalTo(secondHorizontalDivideLine.snp.bottom).offset(17)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
