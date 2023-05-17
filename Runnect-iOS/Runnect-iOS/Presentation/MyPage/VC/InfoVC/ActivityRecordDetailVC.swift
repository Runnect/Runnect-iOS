//
//  ActivityRecordDetailVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/05/10.
//

import UIKit

import SnapKit
import Then

final class ActivityRecordDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let recordProvider = Providers.recordProvider
    
    private var activityRecordList = [ActivityRecord]()
    
    private var courseId: Int?
    
    private var publicCourseId: Int?
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton)
    
    private let moreButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icMore, for: .normal)
        $0.tintColor = .g1
    }
    
    private lazy var middleScorollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    
    private let mapImageView = UIImageView()
    
    private let courseTitleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .g1
        $0.font = .h4
    }
    
    private let recordDateInfoView = CourseDetailInfoView(title: "날짜", description: "0000.00.00")
    
    private let recordDepartureInfoView = CourseDetailInfoView(title: "출발지", description: "서울시 영등포구")
    
    private lazy var recordInfoStackView = UIStackView(arrangedSubviews: [recordDateInfoView, recordDepartureInfoView]).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.distribution = .fillEqually
    }
    
    private let firstHorizontalDivideLine = UIView()
    
    private let secondHorizontalDivideLine = UIView()
    
    private lazy var recordDistanceLabel = setGreyTitle().then {
        $0.text = "거리"
    }
    
    private lazy var recordRunningTimeLabel = setGreyTitle().then {
        $0.text = "이동 시간"
    }
    
    private lazy var recordAveragePaceLabel = setGreyTitle().then {
        $0.text = "평균 페이스"
    }
    
    private lazy var recordDistanceValueLabel = setBlackTitle().then {
        $0.text = "5.1km"
    }
    
    private lazy var recordRunningTimeValueLabel = setBlackTitle().then {
        $0.text = "00:28:07"
    }
    
    private lazy var recordAveragePaceValueLabel = setBlackTitle().then {
        $0.text = "5’31’’"
    }
    
    private lazy var recordDistanceStackView = setDetailInfoStakcView(title: recordDistanceLabel, value: recordDistanceValueLabel)
    
    private lazy var recordRunningTimeStackView = setDetailInfoStakcView(title: recordRunningTimeLabel, value: recordRunningTimeValueLabel)
    
    private lazy var recordAveragePaceStackView = setDetailInfoStakcView(title: recordAveragePaceLabel, value: recordAveragePaceValueLabel)
    
    private let firstVerticalDivideLine = UIView()
    private let secondVerticalDivideLine = UIView()
    
    private lazy var recordSubInfoStackView = UIStackView(arrangedSubviews: [recordDistanceStackView, firstVerticalDivideLine, recordRunningTimeStackView, secondVerticalDivideLine, recordAveragePaceStackView]).then {
        $0.axis = .horizontal
        $0.spacing = 3
        $0.distribution = .fill
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideTabBar(wantsToHide: true)
        setNavigationBar()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension ActivityRecordDetailVC {
    func setCourseId(courseId: Int?, publicCourseId: Int?) {
        self.courseId = courseId
        self.publicCourseId = publicCourseId
    }
    
    func setDetailInfoStakcView(title: UIView, value: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [title, value])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }
    
    func setBlackTitle() -> UILabel {
        let label = UILabel()
        label.textColor = .g1
        label.font = .h3
        return label
    }
    
    func setGreyTitle() -> UILabel {
        let label = UILabel()
        label.textColor = .g2
        label.font = .b4
        return label
    }
}

// MARK: - Layout Helpers

extension ActivityRecordDetailVC {
    private func setUI() {
        view.backgroundColor = .w1
        middleScorollView.backgroundColor = .w1
        mapImageView.backgroundColor = .g3
        firstHorizontalDivideLine.backgroundColor = .g5
        secondHorizontalDivideLine.backgroundColor = .g5
        firstVerticalDivideLine.backgroundColor = .g2
        secondVerticalDivideLine.backgroundColor = .g2
    }
    
    private func setNavigationBar() {
        view.addSubview(navibar)
        view.addSubview(moreButton)
        
        navibar.snp.makeConstraints {  make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(navibar)
        }
    }
    
    private func setLayout() {
        view.addSubviews(middleScorollView)
        
        middleScorollView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        middleScorollView.addSubviews(mapImageView, courseTitleLabel, firstHorizontalDivideLine, recordInfoStackView, secondHorizontalDivideLine)
        
        mapImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(middleScorollView.snp.width).multipliedBy(1.13)
        }
        
        courseTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(31)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        firstHorizontalDivideLine.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(2)
            make.top.equalTo(courseTitleLabel.snp.bottom).offset(7)
        }
        
        recordInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(firstHorizontalDivideLine.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        firstVerticalDivideLine.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        secondVerticalDivideLine.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        secondHorizontalDivideLine.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(7)
            make.top.equalTo(recordInfoStackView.snp.bottom).offset(36)
        }
        
        setRecordSubInfoStackView()
    }
    
    private func setRecordSubInfoStackView() {
        middleScorollView.addSubview(recordSubInfoStackView)
        
        let screenWidth = UIScreen.main.bounds.width
        let containerViewWidth = screenWidth - 32
        let stackViewWidth = Int(containerViewWidth - 2) / 3
        
        recordDistanceStackView.snp.makeConstraints { make in
            make.width.equalTo(stackViewWidth)
        }
        
        recordRunningTimeStackView.snp.makeConstraints { make in
            make.width.equalTo(stackViewWidth)
        }
        
        recordAveragePaceStackView.snp.makeConstraints { make in
            make.width.equalTo(stackViewWidth)
        }
        
        recordSubInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(secondHorizontalDivideLine.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Network

extension ActivityRecordDetailVC {
    func getActivityRecordDetailWithPath() {
        LoadingIndicator.showLoading()
        recordProvider.request(.getActivityRecordInfo) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<ActivityRecordInfoDto>.self)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
}
