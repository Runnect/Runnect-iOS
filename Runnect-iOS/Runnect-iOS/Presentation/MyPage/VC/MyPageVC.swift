//
//  MyPageVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

import SnapKit
import Then
import Moya
import KakaoSDKUser
import KakaoSDKTalk

final class MyPageVC: UIViewController {

    // MARK: - Properties
    
    private var userProvider = Providers.userProvider
    
    let stampNameImageDictionary: [String: UIImage] = GoalRewardInfoModel.stampNameImageDictionary
        
    var sendEmail = String()
    var sendNickname = String()
        
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .title).setTitle("마이페이지")
    private let myProfileView = UIView()
    private let myRunningProgressView = UIView()
    private let versionInfoView = UIView()
    private let firstDivideView = UIView()
    private let secondDivideView = UIView()
    private let thirdDivideView = UIView()
    private let fourthDivideView = UIView()
    private let fifthDivideView = UIView()
    private let topVersionDivideView = UIView()
    private let bottomVersionDivideView = UIView()
    
    private let myProfileImage = UIImageView()
    
    private let myProfileNameLabel = UILabel().then {
        $0.textColor = .m1
        $0.font = .h4
    }
    
    private lazy var myProfileEditButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icEdit, for: .normal)
        $0.setTitle("수정하기", for: .normal)
        $0.titleLabel?.font = .b7
        $0.setTitleColor(.m2, for: .normal)
        $0.tintColor = .m2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.m2.cgColor
        $0.layer.cornerRadius = 14
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpNicknameEditorView))
        $0.addGestureRecognizer(tap)
    }
    
    private let myRunningLevelLabel = UILabel()
    
    private lazy var myRunningProgressBar = UIProgressView(progressViewStyle: .bar).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setProgress(0, animated: false)
        $0.progressTintColor = .m1
        $0.trackTintColor = .m3
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 6
        $0.subviews[1].clipsToBounds = true
    }
    
    private let myRunnigProgressPercentLabel = UILabel()
    
    private lazy var activityRecordInfoView = makeInfoView(title: "러닝 기록").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpActivityRecordInfoView))
        $0.addGestureRecognizer(tap)
    }
    
    private lazy var goalRewardInfoView = makeInfoView(title: "목표 보상").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpGoalRewardInfoView))
        $0.addGestureRecognizer(tap)
    }
    
    private lazy var uploadedCourseInfoView = makeInfoView(title: "업로드한 코스").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpUploadedCourseRecordInfoView))
        $0.addGestureRecognizer(tap)
    }

    private lazy var settingView = makeInfoView(title: "설정").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpSettingView))
        $0.addGestureRecognizer(tap)
    }
    
    private lazy var kakaoChannelAsk = makeInfoView(title: "카카오톡 채널 문의").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpkakaoChannelAsk))
        $0.addGestureRecognizer(tap)
    }
    
    private let versionInfoLabel = UILabel().then {
        $0.textColor = .g2
        $0.font = .b2
        $0.text = "버전 정보"
    }
    
    private let versionInfoValueLabel = UILabel().then {
        $0.textColor = .g2
        $0.font = .b2
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        $0.text = "v. \(version ?? "1.0.0")"
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard UserManager.shared.userType != .visitor else { return }
        self.getMyPageInfo()
        self.hideTabBar(wantsToHide: false)
    }
}

// MARK: - Methods

extension MyPageVC {
    private func makeInfoView(title: String) -> UIView {
        let containerView = UIView()
        let icStar = UIImageView().then {
            $0.image = ImageLiterals.icStar
        }
        
        let label = UILabel().then {
            $0.text = title
            $0.textColor = .g1
            $0.font = .b2
        }
        
        let icArrowRight = UIImageView().then {
            $0.image = ImageLiterals.icArrowRight
        }
        
        containerView.addSubviews(icStar, label, icArrowRight)
        
        icStar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(17)
            make.width.equalTo(14)
            make.height.equalTo(14)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.leading.equalTo(icStar.snp.trailing).offset(8)
        }
        
        icArrowRight.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().inset(10)
        }
        
        return containerView
    }
    
    private func pushToGoalRewardInfoVC() {
        let goalRewardInfoVC = GoalRewardInfoVC()
        self.navigationController?.pushViewController(goalRewardInfoVC, animated: true)
    }
    
    private func pushToActivityRecordInfoVC() {
        let activityRecordInfoVC = ActivityRecordInfoVC()
        self.navigationController?.pushViewController(activityRecordInfoVC, animated: true)
    }
    
    private func pushToUploadedCourseInfoVC() {
        let uploadedCourseInfoVC = UploadedCourseInfoVC()
        self.navigationController?.pushViewController(uploadedCourseInfoVC, animated: true)
    }
    
    private func pushToNicknameEditorVC() {
        let nicknameEditorVC = NicknameEditorVC()
        nicknameEditorVC.setData(nickname: sendNickname)
        nicknameEditorVC.delegate = self
        self.navigationController?.pushViewController(nicknameEditorVC, animated: true)
    }
    
    private func pushToSettingVC() {
        let settingVC = SettingVC()
        settingVC.setData(email: sendEmail)
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    private func setData(model: MyPageDto) {
        self.sendEmail = model.user.email
        self.sendNickname = model.user.nickname
        self.myProfileNameLabel.text = model.user.nickname
        self.myRunningProgressBar.setProgress(Float(model.user.levelPercent)/100, animated: false)
        setMyRunningProgressPercentLabel(label: myRunnigProgressPercentLabel, model: model)
        setMyRunningLevelLabel(label: myRunningLevelLabel, model: model)
        setMyProfileImage(model: model)
    }
    
    private func setMyRunningProgressPercentLabel(label: UILabel, model: MyPageDto) {
        let attributedString = NSMutableAttributedString(string: String(model.user.levelPercent), attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: " /100", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g2]))
        label.attributedText = attributedString
    }
    
    private func setMyRunningLevelLabel(label: UILabel, model: MyPageDto) {
        let attributedString = NSMutableAttributedString(string: "LV ", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: String(model.user.level), attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1]))
        label.attributedText = attributedString
    }
    
    private func setMyProfileImage(model: MyPageDto) {
        guard let profileImage = stampNameImageDictionary[model.user.latestStamp] else { return }
        myProfileImage.image = profileImage
    }
}

// MARK: - @objc Function

extension MyPageVC {
    @objc
    private func touchUpActivityRecordInfoView() {
        pushToActivityRecordInfoVC()
    }
    
    @objc
    private func touchUpGoalRewardInfoView() {
        pushToGoalRewardInfoVC()
    }
    
    @objc
    private func touchUpUploadedCourseRecordInfoView() {
        pushToUploadedCourseInfoVC()
    }
    
    @objc
    private func touchUpNicknameEditorView() {
        pushToNicknameEditorVC()
    }
    
    @objc
    private func touchUpSettingView() {
        pushToSettingVC()
    }
    
    @objc
    private func touchUpkakaoChannelAsk() {
        if let url = URL(string: "https://pf.kakao.com/_hXduG") {
            UIApplication.shared.open(url)
        }
    }
    
}

// MARK: - UI & Layout

extension MyPageVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        myProfileView.backgroundColor = .m3
        firstDivideView.backgroundColor = .g5
        secondDivideView.backgroundColor = .g4
        thirdDivideView.backgroundColor = .g4
        fourthDivideView.backgroundColor = .g4
        fifthDivideView.backgroundColor = .g4
        topVersionDivideView.backgroundColor = .g5
        bottomVersionDivideView.backgroundColor = .g5
    }
    
    private func setLayout() {
        guard UserManager.shared.userType != .visitor else {
            self.showSignInRequestEmptyView()
            return
        }
        
        view.addSubviews(myProfileView, myRunningProgressView, firstDivideView,
            activityRecordInfoView, secondDivideView, goalRewardInfoView,
            thirdDivideView, uploadedCourseInfoView, fourthDivideView, settingView, fifthDivideView, kakaoChannelAsk)
        
        myProfileView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(84)
        }
        
        setMyProfileLayout()
        setRunningProgressLayout()
        
        firstDivideView.snp.makeConstraints { make in
            make.top.equalTo(myRunningProgressView.snp.bottom).offset(34)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        setInfoButtonLayout()
        setVersionInfoLayout()
    }
    
    private func setMyProfileLayout() {
        myProfileView.addSubviews(myProfileImage, myProfileNameLabel, myProfileEditButton)
        
        myProfileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(23)
            make.width.equalTo(63)
            make.height.equalTo(63)
        }
        
        myProfileNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalTo(myProfileImage.snp.trailing).offset(10)
        }
        
        myProfileEditButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(78)
            make.height.equalTo(28)
        }
        
        myRunningProgressView.snp.makeConstraints { make in
            make.top.equalTo(myProfileView.snp.bottom).offset(31)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(61)
        }
    }
    
    private func setRunningProgressLayout() {
        myRunningProgressView.addSubviews(myRunningLevelLabel, myRunningProgressBar,
                                          myRunnigProgressPercentLabel)
        
        myRunningLevelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(3)
        }
        
        myRunningProgressBar.snp.makeConstraints { make in
            make.top.equalTo(myRunningLevelLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(11)
        }
        
        myRunnigProgressPercentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func setInfoButtonLayout() {
        activityRecordInfoView.snp.makeConstraints { make in
            make.top.equalTo(firstDivideView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        secondDivideView.snp.makeConstraints { make in
            make.top.equalTo(activityRecordInfoView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        goalRewardInfoView.snp.makeConstraints { make in
            make.top.equalTo(secondDivideView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        thirdDivideView.snp.makeConstraints { make in
            make.top.equalTo(goalRewardInfoView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        uploadedCourseInfoView.snp.makeConstraints { make in
            make.top.equalTo(thirdDivideView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        fourthDivideView.snp.makeConstraints { make in
            make.top.equalTo(uploadedCourseInfoView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        settingView.snp.makeConstraints { make in
            make.top.equalTo(fourthDivideView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        fifthDivideView.snp.makeConstraints { make in
            make.top.equalTo(settingView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        kakaoChannelAsk.snp.makeConstraints { make in
            make.top.equalTo(fifthDivideView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }

    }
    
    private func setVersionInfoLayout() {
        view.addSubviews(topVersionDivideView, versionInfoView, bottomVersionDivideView)
        
        topVersionDivideView.snp.makeConstraints { make in
            make.top.equalTo(kakaoChannelAsk.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        versionInfoView.snp.makeConstraints { make in
            make.top.equalTo(kakaoChannelAsk.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        bottomVersionDivideView.snp.makeConstraints { make in
            make.top.equalTo(versionInfoView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        versionInfoView.addSubviews(versionInfoLabel, versionInfoValueLabel)
        
        versionInfoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        }
        
        versionInfoValueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(18)
        }
    }
}

extension MyPageVC: NicknameEditorVCDelegate {
    func nicknameEditDidSuccess() {
        getMyPageInfo()
    }
}

// MARK: - Network

extension MyPageVC {
    func getMyPageInfo() {
        LoadingIndicator.showLoading()
        userProvider.request(.getMyPageInfo) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<MyPageDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setData(model: data)
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
