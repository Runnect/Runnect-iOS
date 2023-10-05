//
//  UserProfileVC.swift
//  Runnect-iOS
//
//  Created by 이명진 on 2023/10/05.
//

import UIKit

import SnapKit
import Then
import Moya

final class UserProfileVC: UIViewController {

    // MARK: - Properties
    
    private var userProvider = Providers.userProvider
    private var uploadedCourseProvider = Providers.publicCourseProvider
    let stampNameImageDictionary: [String: UIImage] = GoalRewardInfoModel.stampNameImageDictionary
    
    private var uploadedCourseList = [PublicCourse]()
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("프로필")
    
    private let myProfileView = UIView()
    private let myProfileImage = UIImageView()
    private let myProfileNameLabel = UILabel().then {
        $0.textColor = .m1
        $0.font = .h4
    }
    
    private let myRunningProgressView = UIView()
    private let myRunningLevelLabel = UILabel().then {
        $0.textColor = .m1
        $0.font = .h4
    }
    private lazy var myRunningProgressBar = UIProgressView(progressViewStyle: .bar).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setProgress(0, animated: false)
        $0.progressTintColor = .m1
        $0.trackTintColor = .m6
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 6
        $0.subviews[1].clipsToBounds = true
    }
    private let myRunnigProgressPercentLabel = UILabel()
    
    private lazy var uploadedCourseInfoView = makeInfoView(title: "업로드한 코스")
    
    private lazy var UploadedCourseInfoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
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

extension UserProfileVC {
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
        
        containerView.addSubviews(icStar, label)
        
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
        
        return containerView
    }
    
    private func setData(model: MyPageDto) {
        self.myProfileNameLabel.text = model.user.nickname
        self.myRunningProgressBar.setProgress(Float(model.user.levelPercent)/100, animated: false)
        setMyRunningLevelLabel(label: myRunningLevelLabel, model: model)
        setMyRunningProgressPercentLabel(label: myRunnigProgressPercentLabel, model: model)
        setMyProfileImage(model: model)

    }
    
    private func setCourseData(courseList: [PublicCourse]) {
        self.uploadedCourseList = courseList
        self.UploadedCourseInfoCollectionView.reloadData()
    }
    
    private func setMyRunningLevelLabel(label: UILabel, model: MyPageDto) {
        let attributedString = NSMutableAttributedString(string: "LV ", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: String(model.user.level), attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1]))
        label.attributedText = attributedString
    }
    
    private func setMyRunningProgressPercentLabel(label: UILabel, model: MyPageDto) {
        let attributedString = NSMutableAttributedString(string: String(model.user.levelPercent), attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: " /100", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g2]))
        label.attributedText = attributedString
    }
    
    private func setMyProfileImage(model: MyPageDto) {
        guard let profileImage = stampNameImageDictionary[model.user.latestStamp] else { return }
        myProfileImage.image = profileImage
    }
    
}

// MARK: - @objc Function

extension UserProfileVC {

}

// MARK: - UI & Layout

extension UserProfileVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        myProfileView.backgroundColor = .w1
        myRunningProgressView.backgroundColor = .m3
    }
    
    private func setLayout() {
        view.addSubviews(myProfileView, myRunningProgressView, uploadedCourseInfoView, UploadedCourseInfoCollectionView)
        
        myProfileView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(84)
        }
        
        setMyProfileLayout()
        setRunningProgressLayout()
        
        uploadedCourseInfoView.snp.makeConstraints { make in
            make.top.equalTo(myRunningProgressView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        UploadedCourseInfoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(uploadedCourseInfoView.snp.bottom)
        }
        
    }
    
    private func setMyProfileLayout() {
        myProfileView.addSubviews(myProfileImage, myProfileNameLabel, myRunningProgressView)
        
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
        
        myRunningProgressView.snp.makeConstraints { make in
            make.top.equalTo(myProfileView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func setRunningProgressLayout() {
        myRunningProgressView.addSubviews(myRunningLevelLabel, myRunningProgressBar,
                                          myRunnigProgressPercentLabel)
        
        myRunningLevelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(36)
        }
        
        myRunningProgressBar.snp.makeConstraints { make in
            make.top.equalTo(myRunningLevelLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(36.53)
            make.trailing.equalToSuperview().inset(31.6)
            make.height.equalTo(11)
        }
        
        myRunnigProgressPercentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(31.6)
        }
    }
}

extension UserProfileVC: NicknameEditorVCDelegate {
    func nicknameEditDidSuccess() {
        getMyPageInfo()
    }
}

// MARK: - Network

extension UserProfileVC {
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
