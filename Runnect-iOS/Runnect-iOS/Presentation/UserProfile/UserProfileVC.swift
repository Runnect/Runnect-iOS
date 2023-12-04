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
    
    private let userProvider = Providers.userProvider
    private let uploadedCourseProvider = Providers.publicCourseProvider
    private let scrapProvider = Providers.scrapProvider
    private let stampNameImageDictionary: [String: UIImage] = GoalRewardInfoModel.stampNameImageDictionary
    
    private var uploadedCourseList = [UserCourseInfo]()
    private var userId: Int?
    
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
    
    private lazy var uploadedCourseInfoLabel = makeInfoView(title: "업로드한 코스")
    
    private lazy var UploadedCourseInfoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        register()
        setNavigationBar()
        setDelegate()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard UserManager.shared.userType != .visitor else { return }
        getMyPageInfo()
    }
}

// MARK: - Methods

extension UserProfileVC {
    func setUserId(userId: Int) {
        self.userId = userId
    }
    
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
        
        icStar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().offset(17)
            $0.width.height.equalTo(14)
        }
        
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.leading.equalTo(icStar.snp.trailing).offset(8)
        }
        
        return containerView
    }
    
    private func setData(model: UserProfileDto) {
        myProfileNameLabel.text = model.user.nickname
        myRunningProgressBar.setProgress(Float(model.user.levelPercent) / 100, animated: false)
        setMyRunningLevelLabel(model: model)
        setMyRunningProgressPercentLabel(model: model)
        setMyProfileImage(model: model)
        uploadedCourseList = model.courses
        UploadedCourseInfoCollectionView.reloadData()
    }
    
    private func setMyRunningLevelLabel(model: UserProfileDto) {
        let attributedString = NSMutableAttributedString(string: "LV ", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: String(model.user.level), attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1]))
        myRunningLevelLabel.attributedText = attributedString
    }
    
    private func setMyRunningProgressPercentLabel(model: UserProfileDto) {
        let attributedString = NSMutableAttributedString(string: String(model.user.levelPercent), attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: " /100", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g2]))
        myRunnigProgressPercentLabel.attributedText = attributedString
    }
    
    private func setMyProfileImage(model: UserProfileDto) {
        guard let profileImage = stampNameImageDictionary[model.user.latestStamp] else { return }
        myProfileImage.image = profileImage
    }
    
    private func setDelegate() {
        UploadedCourseInfoCollectionView.delegate = self
        UploadedCourseInfoCollectionView.dataSource = self
    }
    
    private func register() {
        UploadedCourseInfoCollectionView.register(CourseListCVC.self, forCellWithReuseIdentifier: CourseListCVC.className)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadedCourseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className, for: indexPath) as? CourseListCVC else { return UICollectionViewCell() }
        configureCourseCell(cell, at: indexPath)
        return cell
    }
    
    private func configureCourseCell(_ cell: CourseListCVC, at indexPath: IndexPath) {
        cell.setCellType(type: .all)
        let model = uploadedCourseList[indexPath.item]
        let location = "\(model.departure.region) \(model.departure.city)"
        cell.setData(imageURL: model.image, title: model.title, location: location, didLike: model.scrapTF, indexPath: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    
    private struct Constants {
        static let cellSpacing: CGFloat = 20
        static let cellPadding: CGFloat = 10
        static let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 2 * Constants.sectionInsets.left - Constants.cellSpacing) / 2
        let cellHeight = CourseListCVCType.getCellHeight(type: .all, cellWidth: cellWidth)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushToCourseDetail(at: indexPath)
    }
    
    private func pushToCourseDetail(at indexPath: IndexPath) {
        let courseDetailVC = CourseDetailVC()
        let courseModel = uploadedCourseList[indexPath.item]
        courseDetailVC.setCourseId(courseId: courseModel.courseId, publicCourseId: courseModel.publicCourseId)
        courseDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(courseDetailVC, animated: true)
    }
}

// MARK: - CourseListCVCDeleagte

extension UserProfileVC: CourseListCVCDeleagte {
    func likeButtonTapped(wantsTolike: Bool, index: Int) {
        guard UserManager.shared.userType != .visitor else {
            showToastOnWindow(text: "러넥트에 가입하면 코스를 스크랩할 수 있어요")
            return
        }
        
        let publicCourseId = uploadedCourseList[index].publicCourseId
        scrapCourse(publicCourseId: publicCourseId, scrapTF: wantsTolike)
    }
}

// MARK: - UI & Layout

extension UserProfileVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        myProfileView.backgroundColor = .w1
        myRunningProgressView.backgroundColor = .m3
    }
    
    private func setLayout() {
        view.addSubviews(myProfileView, myRunningProgressView, uploadedCourseInfoLabel, UploadedCourseInfoCollectionView)
        
        myProfileView.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(84)
        }
        
        setMyProfileLayout()
        setRunningProgressLayout()
        
        uploadedCourseInfoLabel.snp.makeConstraints {
            $0.top.equalTo(myRunningProgressView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        UploadedCourseInfoCollectionView.snp.makeConstraints {
            $0.top.equalTo(uploadedCourseInfoLabel.snp.bottom).offset(62)
            $0.leading.trailing.height.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setMyProfileLayout() {
        myProfileView.addSubviews(myProfileImage, myProfileNameLabel, myRunningProgressView)
        
        myProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.leading.equalToSuperview().offset(23)
            $0.width.height.equalTo(63)
        }
        
        myProfileNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalTo(myProfileImage.snp.trailing).offset(10)
        }
        
        myRunningProgressView.snp.makeConstraints {
            $0.top.equalTo(myProfileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    private func setRunningProgressLayout() {
        myRunningProgressView.addSubviews(myRunningLevelLabel, myRunningProgressBar, myRunnigProgressPercentLabel)
        
        myRunningLevelLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(36)
        }
        
        myRunningProgressBar.snp.makeConstraints {
            $0.top.equalTo(myRunningLevelLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(36.53)
            $0.trailing.equalToSuperview().inset(31.6)
            $0.height.equalTo(11)
        }
        
        myRunnigProgressPercentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(31.6)
        }
    }
}

// MARK: - Network

extension UserProfileVC {
    private func getMyPageInfo() {
        guard let userId = self.userId else { return }
        LoadingIndicator.showLoading()
        userProvider.request(.getUserProfileInfo(userId: userId)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<UserProfileDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setData(model: data)
                        self.UploadedCourseInfoCollectionView.reloadData()
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
                self.showToast(message: "탈퇴한 유저 입니다.", duration: 1.2)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func scrapCourse(publicCourseId: Int, scrapTF: Bool) {
        LoadingIndicator.showLoading()
        scrapProvider.request(.createAndDeleteScrap(publicCourseId: publicCourseId, scrapTF: scrapTF)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    print("스크랩 성공")
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

extension UserProfileVC {
    func showToast(message: String, duration: TimeInterval = 1.0) {
        let toastLabel = UILabel().then {
            $0.backgroundColor = .g1.withAlphaComponent(0.6)
            $0.textColor = UIColor.white
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.text = message
            $0.alpha = 0.0
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        view.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(300)
            make.height.equalTo(35)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseIn, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
