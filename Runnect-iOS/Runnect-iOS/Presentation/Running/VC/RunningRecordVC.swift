//
//  RunningRecordVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/04.
//

import UIKit

import Moya
import SnapKit
import Then

final class RunningRecordVC: UIViewController {
    
    // MARK: - Properties
    
    private var runningModel: RunningModel?
    
    private let recordProvider = Providers.recordProvider
    
    private let courseTitleMaxLength = 20
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle("러닝 기록")
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let courseImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
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
    
    private let dateInfoView = CourseDetailInfoView(title: "날짜", description: RNTimeFormatter.getCurrentTimeToString(date: Date()))
    
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
        .setEnabled(false)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setAddTarget()
        self.setKeyboardNotification()
        self.setTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTextFieldBottomBorder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Methods

extension RunningRecordVC {
    private func setAddTarget() {
        self.courseTitleTextField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        
        self.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
    }
    
    // 키보드가 올라오면 scrollView 위치 조정
    private func setKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    // 화면 터치 시 키보드 내리기
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setData(runningModel: RunningModel) {
        self.runningModel = runningModel
        self.distanceStatsView.setAttributedStats(stats: runningModel.distance ?? "0.0")
        self.totalTimeStatsView.setStats(stats: runningModel.getFormattedTotalTime() ?? "00:00:00")
        self.averagePaceStatsView.setStats(stats: runningModel.getFormattedAveragePage() ?? "0'00''")
        self.courseImageView.image = runningModel.pathImage
        
        guard let region = runningModel.region, let city = runningModel.city else { return }
        self.departureInfoView.setDescriptionText(description: "\(region) \(city)")
        
        guard let imageUrl = runningModel.imageUrl else { return }
        self.courseImageView.setImage(with: imageUrl)
    }
}

// MARK: - @objc Function

extension RunningRecordVC {
    @objc private func textFieldTextDidChange() {
        guard let text = courseTitleTextField.text else { return }
        
        saveButton.isEnabled = !text.isEmpty
        
        if text.count > courseTitleMaxLength {
            let index = text.index(text.startIndex, offsetBy: courseTitleMaxLength)
            let newString = text[text.startIndex..<index]
            self.courseTitleTextField.text = String(newString)
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func saveButtonDidTap() {
        self.recordRunning()
    }
}

// MARK: - UI & Layout

extension RunningRecordVC {
    private func setUI() {
        view.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, scrollView, saveButton)
        scrollView.addSubviews(contentView)
        
        naviBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(saveButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.greaterThanOrEqualTo(scrollView)
        }
        
        setContentViewLayout()
        
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalToSuperview().inset(34)
            $0.height.equalTo(44)
        }
    }
    
    private func setContentViewLayout() {
        contentView.addSubviews(
            courseImageView,
            courseTitleTextField,
            dateInfoView,
            departureInfoView,
            dividerView,
            verticalDividerView,
            verticalDividerView2,
            statsContainerStackView
        )
        
        courseImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(courseImageView.snp.width)
        }
        
        courseTitleTextField.snp.makeConstraints {
            $0.top.equalTo(courseImageView.snp.bottom).offset(27)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(35)
        }
        
        dateInfoView.snp.makeConstraints {
            $0.top.equalTo(courseTitleTextField.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(16)
        }
        
        departureInfoView.snp.makeConstraints {
            $0.top.equalTo(dateInfoView.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(16)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(departureInfoView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(7)
        }
        
        verticalDividerView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(0.5)
        }
        
        verticalDividerView2.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(0.5)
        }
        
        statsContainerStackView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().inset(25)
        }
    }
    
    private func setTextFieldBottomBorder() {
        courseTitleTextField.addBottomBorder(height: 2)
    }
}

// MARK: - Network

extension RunningRecordVC {
    private func recordRunning() {
        guard let runningModel = self.runningModel else { return }
        guard let courseId = runningModel.courseId else { return }
        guard let titleText = courseTitleTextField.text else { return }
        guard let time = runningModel.getFormattedTotalTime() else { return }
        guard let secondsPerKm = runningModel.getIntPace() else { return }
        let pace = RNTimeFormatter.secondsToHHMMSS(seconds: secondsPerKm)
        
        let requestDto = RunningRecordRequestDto(courseId: courseId,
                                                 publicCourseId: runningModel.publicCourseId,
                                                 title: titleText,
                                                 time: time,
                                                 pace: pace)
        
        LoadingIndicator.showLoading()
        recordProvider.request(.recordRunning(param: requestDto)) { [weak self] response in
            guard let self = self else { return }
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    analyze(buttonName: GAEvent.Button.clickStoreRunningTracking)
                    self.showToastOnWindow(text: "저장한 러닝 기록은 마이페이지에서 볼 수 있어요.")
                    self.navigationController?.popToRootViewController(animated: true)
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
