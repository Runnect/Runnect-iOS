//
//  RunningWaitingVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import UIKit

import DropDown
import NMapsMap
import Moya
import SnapKit
import Then

import FirebaseDynamicLinks

final class RunningWaitingVC: UIViewController {
    
    // MARK: - Properties
    
    private var courseId: Int?
    private var publicCourseId: Int?
    private var courseModel: Course?
    private var courseTitle: String?
    
    private let courseProvider = Providers.courseProvider
    
    private let recordProvider = Providers.recordProvider
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
    
    private let shareButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icShareButton, for: .normal)
        $0.tintColor = .g1
    }
    
    private let moreButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icMore, for: .normal)
        $0.tintColor = .g1
    }
    
    private let mapView = RNMapView()
    
    private let distanceLabel = UILabel().then {
        $0.font = .h1
        $0.textColor = .g1
        $0.text = "0.0"
    }
    
    private let kilometerLabel = UILabel().then {
        $0.font = .b4
        $0.textColor = .g2
        $0.text = "km"
    }
    
    private lazy var distanceStackView = UIStackView(
        arrangedSubviews: [distanceLabel, kilometerLabel]
    ).then {
        $0.spacing = 3
        $0.alignment = .bottom
    }
    
    private let distanceContainerView = UIView().then {
        $0.backgroundColor = .w1
        $0.layer.cornerRadius = 22
    }
    
    private let startButton = CustomButton(title: "시작하기")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setAddTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showHiddenViews(withDuration: 0.7)
    }
}

// MARK: - Methods

extension RunningWaitingVC {
    func setData(courseId: Int, publicCourseId: Int?) {
        self.courseId = courseId
        self.publicCourseId = publicCourseId
        
        self.isMyCourse()
        getCourseDetail(courseId: courseId)
    }
    
    private func setCourseData(courseModel: Course) {
        self.courseModel = courseModel
        
        // 코스 모델에서 타이틀을 가져와 UI에 설정합니다.
        self.courseTitle = courseModel.title
        self.naviBar.setTitle(self.courseTitle ?? "Test Code")
        
        guard let path = courseModel.path, let distance = courseModel.distance else { return }
        let locations = path.map { NMGLatLng(lat: $0[0], lng: $0[1]) }
        self.makePath(locations: locations)
        self.distanceLabel.text = String(format: "%.1f", distance)
    }
    
    private func makePath(locations: [NMGLatLng]) {
        self.mapView.makeMarkersWithStartMarker(at: locations, moveCameraToStartMarker: true)
    }
    
    private func setAddTarget() {
        self.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        self.shareButton.addTarget(self, action: #selector(shareButtonDidTap), for: .touchUpInside)
    }
    
    private func isMyCourse() {
        guard let isMyCourse = courseModel?.isNowUser else { return }
        
        // 자기 코스가 아니라면 <공유, 더보기 버튼> 히든 처리
        if !isMyCourse {
            self.shareButton.isHidden = true
            self.moreButton.isHidden = true
        }
    }
}

// MARK: - @objc Function

extension RunningWaitingVC {
    @objc private func startButtonDidTap() {
        guard let courseModel = self.courseModel, self.distanceLabel.text != "0.0" else { return }
        
        let countDownVC = CountDownVC()
        let runningModel = RunningModel(courseId: self.courseId,
                                        publicCourseId: self.publicCourseId,
                                        locations: self.mapView.getMarkersLatLng(),
                                        distance: self.distanceLabel.text,
                                        imageUrl: courseModel.image,
                                        region: courseModel.departure.region,
                                        city: courseModel.departure.city)
        
        countDownVC.setData(runningModel: runningModel)
        self.navigationController?.pushViewController(countDownVC, animated: true)
    }
    
    @objc private func shareButtonDidTap() {
        guard let model = self.courseModel else {
            return
        }
        analyze(buttonName: GAEvent.Button.clickShare)
        
        self.shareCourse(
            courseTitle: model.title,
            courseId: model.id,
            courseImageURL: model.image,
            minimumAppVersion: "2.0.1",
            descriptionText: "이 코스는 링크로만 들어올 수 있어요!",
            parameter: "privateCourseId"
        )
    }
    
    @objc private func moreButtonDidTap() {
        guard let courseModel = self.courseModel else { return }
        
        let items = ["수정하기", "삭제하기"]
        let imageArray: [UIImage] = [ImageLiterals.icModify, ImageLiterals.icRemove]
        
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
            let lastDividerLineRemove = UIView(frame: CGRect(origin: CGPoint(x: 0, y: (items.count * 40) - 1), size: CGSize(width: 170, height: 10)))
            lastDividerLineRemove.backgroundColor = .white
            cell.separatorInset = .zero
            cell.dropDownImage.image = imageArray[index]
            cell.addSubview(lastDividerLineRemove)
        }
        
        dropDownTouchAction(menu: menu, courseModel: courseModel)
        
        menu.show()
    }
}

// MARK: - UI & Layout

extension RunningWaitingVC {
    private func setUI() {
        self.view.backgroundColor = .w1
        self.distanceContainerView.layer.applyShadow(alpha: 0.2, x: 2, y: 4, blur: 9)
    }
    
    private func setLayout() {
        view.addSubviews(naviBar,
                         moreButton,
                         shareButton,
                         mapView,
                         distanceContainerView,
                         startButton)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        view.bringSubviewToFront(naviBar)
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(moreButton.snp.leading)
            $0.centerY.equalTo(naviBar)
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.centerY.equalTo(naviBar)
        }
        
        view.bringSubviewToFront(shareButton)
        view.bringSubviewToFront(moreButton)
        
        mapView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.top.equalTo(naviBar.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        distanceContainerView.snp.makeConstraints {
            $0.width.equalTo(96)
            $0.height.equalTo(44)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(view.snp.bottom)
        }
        
        distanceContainerView.addSubviews(distanceStackView)
        
        distanceStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
            $0.top.equalTo(view.snp.bottom).offset(24)
        }
    }
    
    private func showHiddenViews(withDuration duration: TimeInterval = 0) {
        [distanceContainerView, startButton].forEach { subView in
            view.bringSubviewToFront(subView)
        }
        
        UIView.animate(withDuration: duration) {
            self.distanceContainerView.transform = CGAffineTransform(translationX: 0, y: -151)
            self.startButton.transform = CGAffineTransform(translationX: 0, y: -112)
        }
    }
}

// MARK: - Network

extension RunningWaitingVC {
    private func getCourseDetail(courseId: Int) {
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
                        self.setCourseData(courseModel: data.course)
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
// MARK: - Network

extension RunningWaitingVC {
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
    
    private func editCourseTitle(courseTitle: String) {
        guard let courseId = courseId else { return }
        
        LoadingIndicator.showLoading()
        courseProvider.request(.updateCourseTitle(courseId: courseId, title: courseTitle)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    showToast(message: "내 코스 이름 수정이 완료되었어요")
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

extension RunningWaitingVC {
    private func dropDownTouchAction(menu: DropDown, courseModel: Course) {
        DropDown.appearance().textColor = .g1
        DropDown.appearance().selectionBackgroundColor = .w1
        DropDown.appearance().shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        DropDown.appearance().shadowOpacity = 1
        DropDown.appearance().shadowRadius = 10
        
        menu.selectionAction = { [unowned self] (_, item) in
            menu.clearSelection()
            
            switch item {
            case "수정하기":
                analyze(buttonName: GAEvent.Button.clickMyStorageTryModify)
                ModifyCourseTitle()
            case "삭제하기":
                analyze(buttonName: GAEvent.Button.clickMyStorageTryRemove)
                let deleteAlertVC = RNAlertVC(description: "러닝 기록을 정말로 삭제하시겠어요?").setButtonTitle("취소", "삭제하기")
                deleteAlertVC.modalPresentationStyle = .overFullScreen
                deleteAlertVC.rightButtonTapAction = {
                    deleteAlertVC.dismiss(animated: false)
                    self.deleteCourse()
                    self.navigationController?.popViewController(animated: true)
                }
                self.present(deleteAlertVC, animated: false)
            default:
                self.showToast(message: "없는 명령어 입니다.")
            }
        }
    }
    
    private func ModifyCourseTitle() {
        let bottomSheetVC = CustomBottomSheetVC(type: .textField)
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.completeButtonTapAction = { [weak self] text in
            guard let self = self else { return }
            guard handleVisitor() else { return }
            self.editCourseTitle(courseTitle: text)
            self.naviBar.setTitle(text)
            self.dismiss(animated: false)
        }
        self.present(bottomSheetVC, animated: false)
    }
}
