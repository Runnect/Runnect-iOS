//
//  CourseDetailVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/05.
//

import UIKit

import SnapKit
import Then
import NMapsMap
import Moya
import SafariServices
import KakaoSDKCommon
import FirebaseCore
import FirebaseDynamicLinks
import KakaoSDKShare
import KakaoSDKTemplate
import DropDown

final class CourseDetailVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: ScrapStateDelegate?
    
    private let scrapProvider = Providers.scrapProvider
    
    private let PublicCourseProvider = Providers.publicCourseProvider
    
    private let courseProvider = Providers.courseProvider
    
    private var courseModel: Course?
    
    private var uploadedCourseDetailModel: UploadedCourseDetailResponseDto?
    
    private var courseId: Int?
    private var publicCourseId: Int?
    private var userId: Int?
    private var isMyCourse: Bool?
    
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
        $0.isUserInteractionEnabled = true
    }
    
    private let runningLevelLabel = UILabel().then {
        $0.text = "Lv. 0"
        $0.textColor = .m1
        $0.font = .b5
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
        delegate?.didUpdateScrapState(publicCourseId: publicCourseId, isScrapped: !sender.isSelected)
        print("CourseDetailVC 스크랩 탭🔥publicCourseId=\(publicCourseId), isScrapped은 \(!sender.isSelected)요렇게 변경 ")
    }
    
    @objc func shareButtonTapped() {
        guard let model = self.uploadedCourseDetailModel else {
            return
        }
        
        let publicCourse = model.publicCourse
        let title = publicCourse.title
        let courseId = publicCourse.id // primaryKey
        let description = publicCourse.description
        let courseImage = publicCourse.image
        
        let dynamicLinksDomainURIPrefix = "https://runnect.page.link"
        guard let link = URL(string: "\(dynamicLinksDomainURIPrefix)/?courseId=\(courseId)") else {
            return
        }
        
        guard let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) else {
            return
        }
        
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.runnect.Runnect-iOS")
        linkBuilder.iOSParameters?.appStoreID = "1663884202"
        linkBuilder.iOSParameters?.minimumAppVersion = "1.0.4"
        
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: courseImage)
        linkBuilder.socialMetaTagParameters?.title = title
        linkBuilder.socialMetaTagParameters?.descriptionText = description
        
        guard let longDynamicLink = linkBuilder.url else {
            return
        }
        print("The long URL is: \(longDynamicLink)")
        
        /// 짧은 Dynamic Link로 변환하는 부분 입니다.
        linkBuilder.shorten { [weak self] url, warnings, error in
            guard let shortDynamicLink = url else {
                if let error = error {
                    print("❌Error shortening dynamic link: \(error)")
                }
                return
            }
            
            print("🔥The short URL is: \(shortDynamicLink)")
            
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [shortDynamicLink.absoluteString], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self?.view
                self?.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    @objc func pushToUserProfileVC() {
        guard let userId = self.userId else {return}
        let userProfile = UserProfileVC()
        userProfile.setUserId(userId: userId)
        self.navigationController?.pushViewController(userProfile, animated: true)
    }

    @objc func startButtonDidTap() {
        guard handleVisitor() else { return }
        guard let courseId = self.courseId else { return }
        getCourseDetailWithPath(courseId: courseId)
    }
    @objc func moreButtonDidTap() {
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
}

// MARK: - Method

extension CourseDetailVC {
    func setCourseId(courseId: Int?, publicCourseId: Int?) {
        self.courseId = courseId
        self.publicCourseId = publicCourseId
    }
    
    func setPublicCourseId(publicCourseId: Int?) { // 추가한 것
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
        
        guard let distance = model.publicCourse.distance else { return }
        self.courseDistanceInfoView.setDescriptionText(description: "\(distance)km")
        let location = "\(model.publicCourse.departure.region) \(model.publicCourse.departure.city)"
        self.courseDepartureInfoView.setDescriptionText(description: location)
        self.courseExplanationTextView.text = model.publicCourse.description
    }
    
    private func setAddTarget() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        let profileTouch = UITapGestureRecognizer(target: self, action: #selector(pushToUserProfileVC))
        profileNameLabel.addGestureRecognizer(profileTouch)
    }
    
    private func setNullUser() {
        self.profileImageView.image = ImageLiterals.imgPerson
        self.profileNameLabel.textColor = .g2
        self.profileNameLabel.text = "(알 수 없음)"
        self.runningLevelLabel.isHidden = true
    }
    
}

// MARK: - Layout Helpers

extension CourseDetailVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        view.addSubview(moreButton)
        view.addSubview(shareButton)
        navibar.snp.makeConstraints {  make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.centerY.equalTo(navibar)
        }
        shareButton.snp.makeConstraints { make in
            make.trailing.trailing.equalTo(moreButton).offset(-50)
            make.centerY.equalTo(navibar)
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
        
        middleScorollView.addSubviews(mapImageView, profileImageView, profileNameLabel, runningLevelLabel, firstHorizontalDivideLine, courseTitleLabel, courseDetailStackView, secondHorizontalDivideLine, courseExplanationTextView)
        
        mapImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(middleScorollView.snp.width).multipliedBy(0.7)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(14)
            make.width.height.equalTo(34)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        runningLevelLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileNameLabel.snp.bottom)
            make.leading.equalTo(profileNameLabel.snp.trailing).offset(10)
        }
        
        firstHorizontalDivideLine.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(62)
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

// MARK: - Network

extension CourseDetailVC {
    private func getUploadedCourseDetail() {
        guard let publicCourseId = self.publicCourseId else { return }
        LoadingIndicator.showLoading()
        PublicCourseProvider.request(.getUploadedCourseDetail(publicCourseId: publicCourseId)) { [weak self] response in
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
                    self.likeButton.isSelected.toggle()
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
                    print("삭제 성공")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
                    deleteAlertVC.dismiss(animated: false)
                    self.deleteCourse()
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
