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

final class MyPageVC: UIViewController {
    
    // MARK: - Properties
    
    private var userProvider = MoyaProvider<UserRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    
    let stampNameImageDictionary: [String: UIImage] = GoalRewardInfoModel.stampNameImageDictionary
        
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .title).setTitle("마이페이지")
    private let myProfileView = UIView()
    private let myRunningProgressView = UIView()
    private let firstDivideView = UIView()
    private let secondDivideView = UIView()
    private let thirdDivideView = UIView()
    
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
    
    private let myRunningLevelLavel = UILabel()
    
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
    
    private lazy var goalRewardInfoView = makeInfoView(title: "목표 보상").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpGoalRewardInfoView))
        $0.addGestureRecognizer(tap)
    }
    
    private lazy var activityRecordInfoView = makeInfoView(title: "활동 기록").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpActivityRecordInfoView))
        $0.addGestureRecognizer(tap)
    }
    
    private lazy var uploadedCourseInfoView = makeInfoView(title: "업로드한 코스").then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchUpUploadedCourseRecordInfoView))
        $0.addGestureRecognizer(tap)
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        getMyPageInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMyPageInfo()
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
            make.trailing.equalToSuperview().inset(8)
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
        nicknameEditorVC.delegate = self
        nicknameEditorVC.modalPresentationStyle = .overFullScreen
        self.present(nicknameEditorVC, animated: false)
    }
    
    private func setData(model: MyPageDto) {
        self.myProfileNameLabel.text = model.user.nickname
        self.myRunningProgressBar.setProgress(Float(model.user.levelPercent)/100, animated: false)
        setMyRunningProgressPercentLabel(label: myRunnigProgressPercentLabel, model: model)
        setMyRunningLevelLavel(label: myRunningLevelLavel, model: model)
        setMyProfileImage(model: model)
    }
    
    private func setMyRunningProgressPercentLabel(label: UILabel, model: MyPageDto) {
        let attributedString = NSMutableAttributedString(string: String(model.user.levelPercent), attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: " /100", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g2]))
        label.attributedText = attributedString
    }
    
    private func setMyRunningLevelLavel(label: UILabel, model: MyPageDto) {
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
    private func touchUpGoalRewardInfoView() {
        pushToGoalRewardInfoVC()
    }
    
    @objc
    private func touchUpActivityRecordInfoView() {
        pushToActivityRecordInfoVC()
    }
    
    @objc
    private func touchUpUploadedCourseRecordInfoView() {
        pushToUploadedCourseInfoVC()
    }
    
    @objc
    private func touchUpNicknameEditorView() {
        pushToNicknameEditorVC()
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
    }
    
    private func setLayout() {
        view.addSubviews(myProfileView, myRunningProgressView, firstDivideView,
            goalRewardInfoView, secondDivideView, activityRecordInfoView,
            thirdDivideView, uploadedCourseInfoView)
        
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
            make.top.equalTo(myProfileView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(55)
        }
    }
    
    private func setRunningProgressLayout() {
        myRunningProgressView.addSubviews(myRunningLevelLavel, myRunningProgressBar,
                                          myRunnigProgressPercentLabel)
        
        myRunningLevelLavel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(1)
        }
        
        myRunningProgressBar.snp.makeConstraints { make in
            make.top.equalTo(myRunningLevelLavel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(11)
        }
        
        myRunnigProgressPercentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func setInfoButtonLayout() {
        goalRewardInfoView.snp.makeConstraints { make in
            make.top.equalTo(firstDivideView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        secondDivideView.snp.makeConstraints { make in
            make.top.equalTo(goalRewardInfoView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        activityRecordInfoView.snp.makeConstraints { make in
            make.top.equalTo(secondDivideView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        thirdDivideView.snp.makeConstraints { make in
            make.top.equalTo(activityRecordInfoView.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        uploadedCourseInfoView.snp.makeConstraints { make in
            make.top.equalTo(thirdDivideView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
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
