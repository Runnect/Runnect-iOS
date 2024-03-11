//
//  CourseDetailVC.swift
//  Runnect-iOS
//
//  Created by 이명진 on 2023/10/09.
//

import UIKit

import SnapKit
import Then
import NMapsMap
import Moya
import SafariServices
import KakaoSDKCommon
import KakaoSDKTemplate
import DropDown

final class CourseDetailVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: ScrapStateDelegate? // 코스 발견 스크랩 이벤트
    weak var marathonDelegate: MarathonScrapStateDelegate? // 마라톤 스크랩 이벤트
    
    private let scrapProvider = Providers.scrapProvider
    private let publicCourseProvider = Providers.publicCourseProvider
    private let courseProvider = Providers.courseProvider
    
    private var courseModel: Course?
    private var uploadedCourseDetailModel: UploadedCourseDetailResponseDto?
    
    private var courseId: Int?
    private var publicCourseId: Int?
    private var userId: Int?
    private var isMyCourse: Bool?
    
    private var scrapCount: Int = 0
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton)
    private let moreButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icMore, for: .normal)
        $0.tintColor = .g1
    }
    private let shareButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icShareButton, for: .normal)
        $0.tintColor = .g1
    }
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
    
    private lazy var userProfileStackView = UIStackView(
        arrangedSubviews: [profileImageView, profileNameLabel, runningLevelLabel]
    ).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var startButton = CustomButton(title: "시작하기").then {
        $0.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
    
    private let mapImageView = UIImageView()
    private let profileImageView = UIImageView().then {
        $0.image = ImageLiterals.imgStampC3
        $0.layer.cornerRadius = 17
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.m3.cgColor
    }
    
    private let profileNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .g1
        $0.font = .h5
    }
    
    private let runningLevelLabel = UILabel().then {
        $0.text = "Lv. 0"
        $0.textColor = .m1
        $0.font = .b5
    }
    
    private let scrapCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .b9
        $0.textColor = UIColor(hex: "#9E9E9E", alpha: 1.0)
        $0.textAlignment = .center
    }
    
    private let courseTitleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .g1
        $0.font = .h4
    }
    
    private let courseDistanceInfoView = CourseDetailInfoView(title: "거리", description: String())
    
    private let courseDepartureInfoView = CourseDetailInfoView(title: "출발지", description: String())
    
    private lazy var courseDetailStackView = UIStackView(arrangedSubviews: [courseDistanceInfoView, courseDepartureInfoView]).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.distribution = .fillEqually
    }
    
    private lazy var courseExplanationTextView = UITextView().then {
        $0.text = "설명"
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
        setRefreshControl()
        analyze(screenName: GAEvent.View.viewCourseDetail)
        self.hideTabBar(wantsToHide: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideTabBar(wantsToHide: true)
        getUploadedCourseDetail()
    }
}

// MARK: - @objc Function

extension CourseDetailVC {
    @objc func likeButtonDidTap(_ sender: UIButton) {
        guard UserManager.shared.userType != .visitor else {
            showToastOnWindow(text: "러넥트에 가입하면 코스를 스크랩할 수 있어요")
            return
        }
        
        guard let publicCourseId = publicCourseId else { return }
        
        scrapCourse(scrapTF: !sender.isSelected)
        delegate?.didUpdateScrapState(publicCourseId: publicCourseId, isScrapped: !sender.isSelected)       /// 코스 발견 UI Update 부분
        marathonDelegate?.didUpdateMarathonScrapState(publicCourseId: publicCourseId, isScrapped: !sender.isSelected) // 마라톤 코스 UI
    }
    
    @objc private func shareButtonTapped() {
        guard let model = self.uploadedCourseDetailModel else {
            return
        }
        
        let publicCourse = model.publicCourse
        
        analyze(buttonName: GAEvent.Button.clickShare)
        
        self.shareCourse(
            courseTitle: publicCourse.title,
            courseId: publicCourse.id,
            courseImageURL: publicCourse.image,
            minimumAppVersion: "1.0.4",
            descriptionText: publicCourse.description,
            parameter: "courseId"
        )
    }
    
    @objc private func pushToUserProfileVC() {
        guard UserManager.shared.userType != .visitor else {
            // 방문자일 경우 토스트 메세지만
            self.showToast(message: "회원만 조회 가능 합니다.")
            return
        }
        
        analyze(screenName: GAEvent.Button.clickUserProfile)
        
        guard let userId = self.userId else {return}
        let userProfile = UserProfileVC()
        userProfile.setUserId(userId: userId)
        self.navigationController?.pushViewController(userProfile, animated: true)
    }
    
    @objc private func startButtonDidTap() {
        guard handleVisitor() else { return }
        guard let courseId = self.courseId else { return }
        getCourseDetailWithPath(courseId: courseId)
    }
    
    @objc private func moreButtonDidTap() {
        guard let isMyCourse = self.isMyCourse, let uploadedCourseDetailModel = self.uploadedCourseDetailModel else { return }
        
        let items = isMyCourse ? ["수정하기", "삭제하기"] : ["신고하기"]
        let imageArray: [UIImage] = isMyCourse ? [ImageLiterals.icModify, ImageLiterals.icRemove] : [ImageLiterals.icReport]
        
        let menu = DropDown().then {
            $0.anchorView = moreButton
            $0.backgroundColor = .w1
            $0.bottomOffset = CGPoint(x: -136, y: moreButton.bounds.height - 10)
            $0.width = 170
            $0.cellHeight = 40
            $0.cornerRadius = 12
            $0.dismissMode = .onTap
            $0.separatorColor = UIColor(hex: "#EBEBEB")
            $0.dataSource = items
            $0.textFont = .b3
        }
        
        menu.customCellConfiguration = { (index: Index, _: String, cell: DropDownCell) -> Void in
            let lastDividerLineRemove = UIView(frame: CGRect(origin: CGPoint(x: 0, y: isMyCourse ? 79 : 39), size: CGSize(width: 170, height: 10)))
            lastDividerLineRemove.backgroundColor = .white
            cell.separatorInset = .zero
            cell.dropDownImage.image = imageArray[index]
            cell.addSubview(lastDividerLineRemove)
        }
        
        dropDownTouchAction(menu: menu, uploadedCourseDetailModel: uploadedCourseDetailModel, isMyCourse: isMyCourse)
        
        menu.show()
    }
    
    @objc private func didBeginRefresh() {
        refresh()
    }
}

// MARK: - Method

extension CourseDetailVC {
    func setCourseId(courseId: Int?, publicCourseId: Int?) {
        self.courseId = courseId
        self.publicCourseId = publicCourseId
    }
    
    func setData(model: UploadedCourseDetailResponseDto) {
        self.uploadedCourseDetailModel = model
        self.userId = model.user.id
        self.mapImageView.setImage(with: model.publicCourse.image)
        self.profileImageView.image = GoalRewardInfoModel.stampNameImageDictionary[model.user.image]
        // 탈퇴 유저 처리
        model.user.nickname == "알 수 없음" ? setNullUser() : (self.profileNameLabel.text = model.user.nickname)
        self.runningLevelLabel.text = "Lv. \(model.user.level)"
        self.courseTitleLabel.text = model.publicCourse.title
        self.isMyCourse = model.user.isNowUser
        guard let scrap = model.publicCourse.scrap else { return }
        self.likeButton.isSelected = scrap
        guard let scrapCount = model.publicCourse.scrapCount else {return}
        self.scrapCount = scrapCount
        self.scrapCountLabel.text = (self.scrapCount > 0) ? "\(self.scrapCount)" : ""
        
        guard let distance = model.publicCourse.distance else { return }
        self.courseDistanceInfoView.setDescriptionText(description: "\(distance)km")
        
        let locate = [
            model.publicCourse.departure.region,
            model.publicCourse.departure.city,
            model.publicCourse.departure.town,
            model.publicCourse.departure.name
        ]
            .compactMap { $0 }
            .joined(separator: " ")
        
        self.courseDepartureInfoView.setDescriptionText(description: locate)
        self.courseExplanationTextView.text = model.publicCourse.description
    }
    
    private func setAddTarget() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        let profileTouch = UITapGestureRecognizer(target: self, action: #selector(pushToUserProfileVC))
        userProfileStackView.addGestureRecognizer(profileTouch)
    }
    
    private func pushToCountDownVC() {
        guard let courseModel = self.courseModel,
              let path = courseModel.path,
              let distance = courseModel.distance
        else { return }
        
        let countDownVC = CountDownVC()
        let locations = path.map { NMGLatLng(lat: $0[0], lng: $0[1]) }
        
        let runningModel = RunningModel(courseId: self.courseId,
                                        publicCourseId: self.publicCourseId,
                                        locations: locations,
                                        distance: String(distance),
                                        imageUrl: courseModel.image,
                                        region: courseModel.departure.region,
                                        city: courseModel.departure.city)
        
        countDownVC.setData(runningModel: runningModel)
        self.navigationController?.pushViewController(countDownVC, animated: true)
    }
    
    private func setNullUser() {
        self.profileImageView.image = ImageLiterals.imgPerson
        self.profileNameLabel.textColor = .g2
        self.profileNameLabel.text = "(알 수 없음)"
        self.runningLevelLabel.isHidden = true
    }
    
    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(didBeginRefresh),
            for: .valueChanged
        )
        middleScorollView.refreshControl = refreshControl
    }
    
    private func refresh() {
        self.getUploadedCourseDetail()
    }
}

// MARK: - Layout Helpers

extension CourseDetailVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        view.addSubview(moreButton)
        view.addSubview(shareButton)
        
        navibar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.centerY.equalTo(navibar)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.trailing.equalTo(moreButton).offset(-50)
            $0.centerY.equalTo(navibar)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        bottomView.backgroundColor = .w1
        middleScorollView.backgroundColor = .w1
        mapImageView.backgroundColor = .g3
        firstHorizontalDivideLine.backgroundColor = .g3
        secondHorizontalDivideLine.backgroundColor = .g5
        thirdHorizontalDivideLine.backgroundColor = .g3
    }
    
    private func setLayout() {
        view.addSubviews(middleScorollView, thirdHorizontalDivideLine, bottomView)
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(84)
        }
        
        thirdHorizontalDivideLine.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(0.5)
        }
        
        bottomView.addSubviews(likeButton, startButton, scrapCountLabel)
        
        likeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(26)
            $0.width.equalTo(24)
            $0.height.equalTo(22)
        }
        
        scrapCountLabel.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(28)
            $0.width.equalTo(20)
            $0.height.equalTo(13)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.trailing).offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        setMiddleScrollView()
    }
    
    private func setMiddleScrollView() {
        middleScorollView.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(thirdHorizontalDivideLine.snp.top)
        }
        
        middleScorollView.addSubviews(mapImageView, userProfileStackView, firstHorizontalDivideLine, courseTitleLabel, courseDetailStackView, secondHorizontalDivideLine, courseExplanationTextView)
        
        mapImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(middleScorollView.snp.width).multipliedBy(0.7)
        }
        
        userProfileStackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.top.equalTo(mapImageView.snp.bottom).offset(14)
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(37)
        }
        
        firstHorizontalDivideLine.snp.makeConstraints {
            $0.top.equalTo(mapImageView.snp.bottom).offset(62)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(0.5)
        }
        
        courseTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstHorizontalDivideLine.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        courseDetailStackView.snp.makeConstraints {
            $0.top.equalTo(courseTitleLabel.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        secondHorizontalDivideLine.snp.makeConstraints {
            $0.top.equalTo(courseDetailStackView.snp.bottom).offset(27)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(8)
        }
        
        courseExplanationTextView.snp.makeConstraints {
            $0.top.equalTo(secondHorizontalDivideLine.snp.bottom).offset(17)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Network

extension CourseDetailVC {
    private func getUploadedCourseDetail() {
        guard let publicCourseId = self.publicCourseId else { return }
        LoadingIndicator.showLoading()
        publicCourseProvider.request(.getUploadedCourseDetail(publicCourseId: publicCourseId)) { [weak self] response in
            guard let self = self else { return }
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<UploadedCourseDetailResponseDto>.self)
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
            self.middleScorollView.refreshControl?.endRefreshing()
        }
    }
    
    private func getCourseDetailWithPath(courseId: Int) {
        LoadingIndicator.showLoading()
        courseProvider.request(.getCourseDetail(courseId: courseId)) { [weak self] response in
            guard let self = self else { return }
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<CourseDetailResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.courseModel = data.course
                        self.pushToCountDownVC()
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
    
    private func scrapCourse(scrapTF: Bool) {
        guard let publicCourseId = self.publicCourseId else { return }
        LoadingIndicator.showLoading()
        scrapProvider.request(.createAndDeleteScrap(publicCourseId: publicCourseId, scrapTF: scrapTF)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<CourseDetailScrapCountDto>.self)
                        guard let data = responseDto.data else { return }
                        self.likeButton.isSelected.toggle()
                        self.scrapCount = data.scrapCount
                        self.scrapCountLabel.text = "\(self.scrapCount)"
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

extension CourseDetailVC {
    private func deleteCourse() {
        guard let courseId = self.courseId else { return }
        LoadingIndicator.showLoading()
        courseProvider.request(.deleteCourse(courseIdList: [courseId])) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                print("리절트", result)
                let status = result.statusCode
                if 200..<300 ~= status {
                    delegate?.didRemoveCourse(publicCourseId: courseId)
                    print("코스 \(courseId) 번 삭제 성공")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.navigationController?.popViewController(animated: true)
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

// MARK: - DropDown

extension CourseDetailVC {
    private func dropDownTouchAction(menu: DropDown, uploadedCourseDetailModel: UploadedCourseDetailResponseDto, isMyCourse: Bool) {
        
        DropDown.appearance().textColor = .g1
        DropDown.appearance().selectionBackgroundColor = .w1
        DropDown.appearance().shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        DropDown.appearance().shadowOpacity = 1
        DropDown.appearance().shadowRadius = 10
        
        menu.selectionAction = { [unowned self] (_, item) in
            menu.clearSelection()
            
            switch item {
            case "수정하기":
                let courseEditVC = CourseEditVC()
                courseEditVC.loadData(model: uploadedCourseDetailModel)
                courseEditVC.publicCourseId = self.publicCourseId
                self.navigationController?.pushViewController(courseEditVC, animated: false)
            case "삭제하기":
                let deleteAlertVC = RNAlertVC(description: "러닝 기록을 정말로 삭제하시겠어요?").setButtonTitle("취소", "삭제하기")
                deleteAlertVC.modalPresentationStyle = .overFullScreen
                deleteAlertVC.rightButtonTapAction = {
                    self.deleteCourse()
                    deleteAlertVC.dismiss(animated: false)
                }
                self.present(deleteAlertVC, animated: false)
            case "신고하기":
                if !isMyCourse {
                    let formUrl = NSURL(string: "https://docs.google.com/forms/d/e/1FAIpQLSek2rkClKfGaz1zwTEHX3Oojbq_pbF3ifPYMYezBU0_pe-_Tg/viewform")
                    let formSafariView: SFSafariViewController = SFSafariViewController(url: formUrl! as URL)
                    self.present(formSafariView, animated: true, completion: nil)
                }
            default:
                self.showToast(message: "없는 명령어 입니다.")
            }
        }
    }
}
