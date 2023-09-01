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
import KakaoSDKShare
import KakaoSDKTemplate

final class CourseDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let scrapProvider = Providers.scrapProvider
    
    private let PublicCourseProvider = Providers.publicCourseProvider
    
    private let courseProvider = Providers.courseProvider
    
    private var courseModel: Course?
    
    private var uploadedCourseDetailModel: UploadedCourseDetailResponseDto?
    
    private var courseId: Int?
    private var publicCourseId: Int?
    private var isMyCourse: Bool?
    
    private var safariViewController: SFSafariViewController?
    
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
    
    private lazy var followButton = UIButton(type: .custom).then {
        $0.setImage(ImageLiterals.icFollowButton, for: .normal)
        $0.setImage(ImageLiterals.icFollowedButton, for: .selected)
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
        
        scrapCourse(scrapTF: !sender.isSelected)
    }
    
    @objc func followButtonTapped() {
        followButton.isSelected.toggle()
    }
    
//    @objc func shareButtonTapped() {
//        guard let model = self.uploadedCourseDetailModel else {
//            return
//        }
//
//        let courseImage = model.publicCourse.image
//        let courseId = model.publicCourse.courseId
//        let courseTitle = model.publicCourse.title
//        let courseDescription = model.publicCourse.description
//
//        // Create a deep link URL for your app
//        let deepLinkURLString = "myapp://detail?courseId=\(courseId)"
//
//        // 공유할 배열 생성
//        var itemsToShare: [Any] = []
//
//        // Add course description
////        itemsToShare.append(courseImage)
////        itemsToShare.append(courseTitle)
////        itemsToShare.append(courseDescription!)
//
//        // Check if your app is installed
//        if let deepLinkURL = URL(string: deepLinkURLString),
//           UIApplication.shared.canOpenURL(deepLinkURL) {
//            // Your app is installed, share the deep link
//            itemsToShare.append(deepLinkURL)
//        } else {
//            // Your app is not installed, share the app store link
//            let appBundleID = "com.runnect.Runnect-iOS"
//            let appStoreURLString = "https://itunes.apple.com/app/id\(appBundleID)"
//
//            if let appStoreURL = URL(string: appStoreURLString) {
//                itemsToShare.append(appStoreURL)
//            }
//        }
//
//        // Create an activity view controller
//        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
//
//        // Remove the excludedActivityTypes array to include all options
//        activityViewController.excludedActivityTypes = nil
//
//        // Present the activity view controller
//        if let popoverPresentationController = activityViewController.popoverPresentationController {
//            popoverPresentationController.sourceView = self.view
//            popoverPresentationController.sourceRect = self.shareButton.frame
//        }
//
//        present(activityViewController, animated: true, completion: nil)
//    }
        
    @objc func shareButtonTapped() {
        guard let model = self.uploadedCourseDetailModel else {
            return
        }

        let title = model.publicCourse.title
        let courseId = model.publicCourse.courseId
        let description = model.publicCourse.description
        let courseImage = model.publicCourse.image

        // 딥 링크 URL 생성
        let deepLinkURLString = "kakao27d01e20b51e5925bf386a6c5465849f://kakaolink?publicCourseId=\(courseId)"
        print("🔥내가 누른 코스 아이디 \(courseId) \n 🔥내가 만든 딥링크 확인 \(deepLinkURLString)")
        // KakaoLink 템플릿을 생성.
        let link = Link(mobileWebUrl: URL(string: deepLinkURLString))
        let appLink = Link(iosExecutionParams: ["publicCourseId": String(courseId)])
        let button = Button(title: "앱에서 보기", link: appLink)
        let content = Content(title: title,
                              imageUrl: URL(string: courseImage)!,
                              description: description,
                              link: link)
        let template = FeedTemplate(content: content, buttons: [button])

        // 카카오톡으로 공유합니다.
        if ShareApi.isKakaoTalkSharingAvailable() {
            if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
                if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                    ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (linkResult, error) in
                        if let error = error {
                            print("🔥카카오링크 공유 실패: error : \(error)🔥")
                        } else {
                            print("⭐️카카오 링크 공유 성공 success.⭐️")
                            guard let linkResult = linkResult else { return }
                            UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        } else {
            // 카카오톡 앱이 없을 경우 근데 딥링크는 요거 아마 안됌.. Universial Link인가 그거해야함
            print("⭐️카카오톡 없어서 앱스토어 가야지?")
            let appBundleID = "com.runnect.Runnect-iOS"
            let appStoreURLString = "https://itunes.apple.com/app/id\(appBundleID)"
            if let url = URL(string: appStoreURLString), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

    @objc func startButtonDidTap() {
        guard handleVisitor() else { return }
        guard let courseId = self.courseId else { return }
        getCourseDetailWithPath(courseId: courseId)
    }
    @objc func moreButtonDidTap() {
        guard let isMyCourse = self.isMyCourse, let uploadedCourseDetailModel = self.uploadedCourseDetailModel else { return }
        
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        if isMyCourse == true {
            let editAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let editAction = UIAlertAction(title: "수정하기", style: .default, handler: {(_: UIAlertAction!) in
                let courseEditVC = CourseEditVC()
                courseEditVC.loadData(model: uploadedCourseDetailModel)
                courseEditVC.publicCourseId = self.publicCourseId
                self.navigationController?.pushViewController(courseEditVC, animated: false)
            })
            let deleteAlertVC = RNAlertVC(description: "러닝 기록을 정말로 삭제하시겠어요?").setButtonTitle("취소", "삭제하기")
            deleteAlertVC.rightButtonTapAction = { [weak self] in
                deleteAlertVC.dismiss(animated: false)
                self?.deleteCourse()
            }
            deleteAlertVC.modalPresentationStyle = .overFullScreen
            let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: {(_: UIAlertAction!) in
                self.present(deleteAlertVC, animated: false, completion: nil)
            })
            [ editAction, deleteAction, cancelAction].forEach { editAlertController.addAction($0) }
            present(editAlertController, animated: false, completion: nil)
        } else {
            // 신고폼 올라오는 거(유저아이디가 내가 아닌 경우)
            let reportAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let formUrl = NSURL(string: "https://docs.google.com/forms/d/e/1FAIpQLSek2rkClKfGaz1zwTEHX3Oojbq_pbF3ifPYMYezBU0_pe-_Tg/viewform")
            let formSafariView: SFSafariViewController = SFSafariViewController(url: formUrl! as URL)
            let reportAction = UIAlertAction(title: "신고하기", style: .destructive, handler: {(_: UIAlertAction!) in
                self.present(formSafariView, animated: true, completion: nil)
            })
            [ reportAction, cancelAction ].forEach { reportAlertController.addAction($0) }
            present(reportAlertController, animated: true, completion: nil)
        }
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
    
    func setData(model: UploadedCourseDetailResponseDto) {
        self.uploadedCourseDetailModel = model
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
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
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
        
        middleScorollView.addSubviews(mapImageView, profileImageView, profileNameLabel, runningLevelLabel, followButton, firstHorizontalDivideLine, courseTitleLabel, courseDetailStackView, secondHorizontalDivideLine, courseExplanationTextView)
        
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
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileNameLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
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

#if DEBUG
import SwiftUI
struct Preview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        // 이부분
        CourseDetailVC()
        // 이거 보고싶은 현재 VC로 바꾸셈
    }
    
    func updateUIViewController(_ uiView: UIViewController, context: Context) {
        // leave this empty
    }
}

struct ViewController_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            Preview()
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
    }
}
#endif
