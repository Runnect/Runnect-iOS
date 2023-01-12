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

final class CourseDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let courseDetailProvider = MoyaProvider<UploadedCourseDetailRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    
    private let runningProvider = MoyaProvider<RunningRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    
    private var courseModel: Course?
    
    private var courseId: Int?
    private var publicCourseId: Int?
    
    // MARK: - UI Components
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton)
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
        $0.layer.cornerRadius = 20
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

    private let courseDistanceInfoView = CourseDetailInfoView(title: "거리", description: "0.0km")
    
    private let courseDepartureInfoView = CourseDetailInfoView(title: "출발지", description: "위치")
    
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
        getUploadedCourseDetail()
    }
}

// MARK: - @objc Function

extension CourseDetailVC {
    @objc func likeButtonDidTap(_ sender: UIButton) {
        scrapCourse(scrapTF: !sender.isSelected)
    }
    
    @objc func startButtonDidTap() {
        guard let courseId = self.courseId else { return }
        getCourseDetailWithPath(courseId: courseId)
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
        self.mapImageView.setImage(with: model.publicCourse.image)
        self.profileImageView.image = GoalRewardInfoModel.stampNameImageDictionary[model.user.image]
        self.profileNameLabel.text = model.user.nickname
        self.runningLevelLabel.text = "Lv. \(model.user.level)"
        self.courseTitleLabel.text = model.publicCourse.title
        
        guard let scrap = model.publicCourse.scrap else { return }
        self.likeButton.isSelected = scrap
        
        guard let distance = model.publicCourse.distance else { return }
        self.courseDistanceInfoView.setDescriptionText(description: String(distance))
        let location = "\(model.publicCourse.departure.region) \(model.publicCourse.departure.city)"
        self.courseDepartureInfoView.setDescriptionText(description: location)
        self.courseExplanationTextView.text = model.publicCourse.description
    }
    
    private func setAddTarget() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
    }
}

extension CourseDetailVC {
    
    // MARK: - Layout Helpers
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints {  make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
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
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(31)
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

extension CourseDetailVC {
    private func getUploadedCourseDetail() {
        guard let publicCourseId = self.publicCourseId else { return }
        LoadingIndicator.showLoading()
        courseDetailProvider.request(.getUploadedCourseDetail(publicCourseId: publicCourseId)) { [weak self] response in
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
        runningProvider.request(.getCourseDetail(courseId: courseId)) { [weak self] response in
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
        courseDetailProvider.request(.createAndDeleteScrap(publicCourseId: publicCourseId, scrapTF: scrapTF)) { [weak self] response in
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
