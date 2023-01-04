//
//  RunningRecordVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/04.
//

import UIKit

final class RunningRecordVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle("러닝 기록")
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let courseImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
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
    
    private let dateInfoView = CourseDetailInfoView(title: "날짜", description: "출발 날짜")
    
    private let departureInfoView = CourseDetailInfoView(title: "출발지", description: "출발지 주소")
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .g5
    }
    
    private let distanceStatsView = StatsInfoView(title: "거리", stats: "0.0 Km").setAttributedStats(stats: "0.0")
    private let totalTimeStatsView = StatsInfoView(title: "이동 시간", stats: "00:00:00")
    private let averagePaceStatsView = StatsInfoView(title: "평균 페이스", stats: "0'00'")
    private let verticalDividerView = UIView().then {
        $0.backgroundColor = .g2
    }
    private let verticalDividerView2 = UIView().then {
        $0.backgroundColor = .g2
    }
    
    private lazy var statsContainerStackView = UIStackView(
        arrangedSubviews: [distanceStatsView,
                           verticalDividerView,
                           totalTimeStatsView,
                           verticalDividerView2,
                           averagePaceStatsView]
    ).then {
        $0.spacing = 25
    }

    private let saveButton = CustomButton(title: "저장하기")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTextFieldBottomBorder()
    }
}

// MARK: - Methods

extension RunningRecordVC {
    
}

// MARK: - UI & Layout

extension RunningRecordVC {
    private func setUI() {
        view.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, scrollView, saveButton)
        scrollView.addSubviews(contentView)

        setContentViewLayout()
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(91)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(scrollView)
        }
    
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(44)
        }
    }
    
    private func setContentViewLayout() {
        contentView.addSubviews(
            courseImageView,
            courseTitleTextField,
            dateInfoView,
            departureInfoView,
            dividerView,
            statsContainerStackView
        )
        
        courseImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(courseImageView.snp.width)
        }
        
        courseTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(courseImageView.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(35)
        }
        
        dateInfoView.snp.makeConstraints { make in
            make.top.equalTo(courseTitleTextField.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        
        departureInfoView.snp.makeConstraints { make in
            make.top.equalTo(dateInfoView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(departureInfoView.snp.bottom).offset(34)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(7)
        }
        
        verticalDividerView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(0.5)
        }
        
        verticalDividerView2.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(0.5)
        }
        
        statsContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(25)
        }
    }
    
    private func setTextFieldBottomBorder() {
        courseTitleTextField.addBottomBorder(height: 2)
    }
}
