//
//  CourseDrawingVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/03.
//

import UIKit
import Combine

import Moya
import SnapKit
import Then

final class CourseDrawingVC: UIViewController {
    
    // MARK: - Properties
    private let departureSearchingProvider = NetworkProvider<DepartureSearchingRouter>(withAuth: false)
    private let courseProvider = NetworkProvider<CourseRouter>(withAuth: true)
    
    private var departureLocationModel: DepartureLocationModel?
    
    var pathImage: UIImage?
    var distance: Float = 0.0
    private var courseName = String()
    
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let notchCoverView = UIView().then {
        $0.backgroundColor = .w1
    }
    
    private lazy var naviBar = CustomNavigationBar(self, type: SelectedInfo.shared.type == .map ? .titleWithLeftButton : .search)
        .hideRightButton()
        .changeTitleWithLeftButton(.b1, .g1)
        .setTitle("지도에서 선택")
    
    private lazy var naviBarForEditing = CustomNavigationBar(self, type: .titleWithLeftButton)
        .then {
            $0.alpha = 0
        }
    
    private let guideView = GuideView(title: "지도를 눌러 코스를 그려주세요")
    
    private lazy var naviBarContainerStackView = UIStackView(
        arrangedSubviews: [notchCoverView, naviBar]
    ).then {
        $0.axis = .vertical
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .g4
    }
    
    private let aboutMapNoticeView = UIView().then {
        $0.backgroundColor = .w1
    }
    
    private let aboutMapNoticeLabel = UILabel().then {
        $0.font = .b4
        $0.textColor = .g2
        $0.text = "지도를 움직여 출발지를 설정해 주세요"
    }
    
    private let mapView = RNMapView().makeNaverLogoMargin(inset: UIEdgeInsets(top: 52, left: 0, bottom: 0, right: 0))
    
    private let departureLocationLabel = UILabel().then {
        $0.font = .b1
        $0.textColor = .g1
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "장소 이름"
    }
    
    private let departureDetailLocationLabel = UILabel().then {
        $0.font = .b6
        $0.textColor = .g2
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "상세 주소"
    }
    
    private let decideDepartureButton = CustomButton(title: "출발지 설정하기")
    
    private let departureInfoContainerView = UIView().then {
        $0.backgroundColor = .w1
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
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
    
    private let undoButton = UIButton(type: .custom).then {
        $0.setImage(ImageLiterals.icCancel, for: .normal)
    }
    
    private let completeButton = CustomButton(title: "다음으로").setEnabled(false)
    
    private let startMarkUIImage = UIImageView().then {
        $0.image = ImageLiterals.icMapDeparture
    }
    private let startLabelUIImage = UIImageView().then {
        $0.image = ImageLiterals.icMapStart
    }
    private lazy var startMarkStackView = UIStackView().then {
        $0.addArrangedSubviews(startLabelUIImage, startMarkUIImage)
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 1
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setAddTarget()
        self.bindMapView()
        self.setNavigationGesture(false)
    }
}

// MARK: - Methods

extension CourseDrawingVC {
    func setData(model: DepartureLocationModel) {
        self.departureLocationModel = model
        self.naviBar.setTextFieldText(text: model.departureName)
        self.mapView.makeStartMarker(at: model.toNMGLatLng(), withCameraMove: true)
        self.departureLocationLabel.text = model.departureName
        self.departureDetailLocationLabel.text = model.departureAddress
    }
    
    func updateData(model: DepartureLocationModel) {
        self.departureLocationModel = model
        self.naviBar.setTextFieldText(text: model.departureName)
        self.departureLocationLabel.text = model.departureName
        self.departureDetailLocationLabel.text = model.departureAddress
        
        if SelectedInfo.shared.type == .other {
            self.naviBar.setTextFieldText(text: model.departureName)
        }
    }
    
    private func setAddTarget() {
        self.decideDepartureButton.addTarget(self, action: #selector(decideDepartureButtonDidTap), for: .touchUpInside)
        self.undoButton.addTarget(self, action: #selector(undoButtonDidTap), for: .touchUpInside)
        self.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    
    private func bindMapView() {
        mapView.$pathDistance.sink { [weak self] distance in
            guard let self = self else { return }
            let kilometers = String(format: "%.1f", distance/1000)
            self.distanceLabel.text = kilometers
            self.distance = Float(kilometers) ?? 0.0
        }.store(in: cancelBag)
        
        mapView.$markerCount.sink { [weak self] count in
            guard let self = self else { return }
            self.completeButton.setEnabled(count >= 2)
            self.undoButton.isEnabled = (count >= 2)
        }.store(in: cancelBag)
        
        mapView.pathImage.sink { [weak self] image in
            guard let self = self else { return }
            self.pathImage = image
            self.uploadCourseDrawing()
        }.store(in: cancelBag)
        
        mapView.eventSubject.sink { [weak self] arr in
            guard let self = self else { return }
            self.searchLocationTmapAddress(latitude: arr[0], longitude: arr[1])
            //            self.searchTest(latitude: arr[0], longitude: arr[1])
        }.store(in: cancelBag)
    }
    
    private func setNavigationGesture(_ isEnabled: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabled
    }
    
    private func presentAlertVC(courseId: Int) {
        let alertVC = CustomAlertVC()
        alertVC.modalPresentationStyle = .overFullScreen
        
        // 보관함 가기
        alertVC.leftButtonTapped.sink { [weak self] _ in
            guard let self = self else { return }
            analyze(buttonName: GAEvent.Button.clickStoredAfterCourseComplete)
            
            self.tabBarController?.selectedIndex = 1
            self.navigationController?.popToRootViewController(animated: true)
            alertVC.dismiss(animated: true)
        }.store(in: cancelBag)
        
        // 바로 달리기
        alertVC.rightButtonTapped.sink { [weak self] _ in
            guard let self = self else { return }
            analyze(buttonName: GAEvent.Button.clickRunAfterCourseComplete)
            
            let countDownVC = CountDownVC()
            let runningModel = RunningModel(courseId: courseId,
                                            locations: self.mapView.getMarkersLatLng(),
                                            distance: self.distanceLabel.text,
                                            pathImage: self.pathImage,
                                            region: self.departureLocationModel?.region,
                                            city: self.departureLocationModel?.city)
            countDownVC.setData(runningModel: runningModel)
            self.navigationController?.pushViewController(countDownVC, animated: true)
            alertVC.dismiss(animated: true)
        }.store(in: cancelBag)
        
        self.present(alertVC, animated: false)
    }
}

// MARK: - @objc Function

extension CourseDrawingVC {
    @objc private func decideDepartureButtonDidTap() {
        showHiddenViews(withDuration: 0.7)
        
        if SelectedInfo.shared.type == .map {
            startMarkStackView.isHidden = true
            guard let model = self.departureLocationModel else { return }
            SelectedInfo.shared.type = .other
            mapView.makeStartMarker(at: model.toNMGLatLng(), withCameraMove: true)
        }
        
        mapView.setDrawMode(to: true)
    }
    
    @objc private func undoButtonDidTap() {
        mapView.undo()
    }
    
    @objc private func completeButtonDidTap() {
        let bottomSheetVC = CustomBottomSheetVC(type: .textField)
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.completeButtonTapAction = { [weak self] text in
            guard let self = self else { return }
            guard bottomSheetVC.handleVisitor() else { return } // 사실상 여기까지 못 들어오는게 맞음 (코스 그리기에서 막았다.)
            self.courseName = text
            self.mapView.capturePathImage()
            self.dismiss(animated: false)
        }
        self.present(bottomSheetVC, animated: false)
    }
}

// MARK: - UI & Layout

extension CourseDrawingVC {
    private func setUI() {
        self.view.backgroundColor = .w1
        self.naviBarForEditing.backgroundColor = .clear
        self.departureInfoContainerView.layer.applyShadow(alpha: 0.35, x: 0, y: 3, blur: 10)
        self.distanceContainerView.layer.applyShadow(alpha: 0.2, x: 2, y: 4, blur: 9)
        self.startMarkStackView.isHidden = SelectedInfo.shared.type == .map ? false : true
    }
    
    private func setLayout() {
        setHiddenViewsLayout()
        self.view.addSubviews(
            naviBarContainerStackView,
            mapView,
            departureInfoContainerView
        )
        self.view.addSubview(startMarkStackView)
        self.departureInfoContainerView.addSubviews(
            departureLocationLabel,
            departureDetailLocationLabel,
            decideDepartureButton
        )
        view.bringSubviewToFront(naviBarContainerStackView)
        
        setNotchCoverViewLayout()
        setNaviBarLayout()
        setMapViewLayout()
        setStartMarkStackViewLayout()
        setDepartureInfoContainerViewLayout()
        setAboutMapNoticeViewLayout()
    }
    
    private func setHiddenViewsLayout() {
        view.addSubviews(
            naviBarForEditing,
            guideView,
            distanceContainerView,
            completeButton,
            undoButton
        )
        view.sendSubviewToBack(naviBarForEditing)
        
        naviBarForEditing.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        guideView.snp.makeConstraints {
            $0.centerY.equalTo(naviBarForEditing.snp.centerY)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(55)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(27)
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
        
        undoButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.snp.bottom)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
            $0.top.equalTo(view.snp.bottom).offset(34)
        }
    }
    
    private func showHiddenViews(withDuration: TimeInterval = 0) {
        [naviBarForEditing, guideView, distanceContainerView, completeButton, undoButton].forEach {
            view.bringSubviewToFront($0)
        }
        
        UIView.animate(withDuration: withDuration) {
            let naviBarContainerStackViewHeight = self.naviBarContainerStackView.frame.height
            self.naviBarContainerStackView.transform = CGAffineTransform(translationX: 0, y: -naviBarContainerStackViewHeight)
            self.departureInfoContainerView.transform = CGAffineTransform(translationX: 0, y: 172)
        }
        
        self.guideView.transform = CGAffineTransform(translationX: 0, y: -100)
        
        UIView.animate(withDuration: withDuration) {
            self.naviBarForEditing.alpha = 1
            self.guideView.transform = .identity
            self.distanceContainerView.transform = CGAffineTransform(translationX: 0, y: -151)
            self.completeButton.transform = CGAffineTransform(translationX: 0, y: -112)
            self.undoButton.transform = CGAffineTransform(translationX: 0, y: -(self.undoButton.frame.height+95))
        }
    }
    
    private func setNotchCoverViewLayout() {
        notchCoverView.snp.makeConstraints {
            var notchHeight = calculateTopInset()
            if notchHeight == -44 {
                let statusBarHeight = UIApplication.shared.statusBarHeight
                notchHeight = -statusBarHeight
            }
            $0.height.equalTo(-notchHeight)
        }
    }
    
    private func setNaviBarLayout() {
        naviBar.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        naviBarContainerStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
    }
    
    private func setMapViewLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setStartMarkStackViewLayout() {
        startLabelUIImage.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(58)
        }
        
        startMarkUIImage.snp.makeConstraints {
            $0.height.width.equalTo(65)
        }
        
        startMarkStackView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.width.equalTo(65)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-17)
        }
    }
    
    private func setDepartureInfoContainerViewLayout() {
        departureInfoContainerView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(172)
        }
        
        departureLocationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        departureDetailLocationLabel.snp.makeConstraints {
            $0.top.equalTo(departureLocationLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        decideDepartureButton.snp.makeConstraints {
            $0.top.equalTo(departureDetailLocationLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
    }
    
    private func setAboutMapNoticeViewLayout() {
        if SelectedInfo.shared.type == .map {
            aboutMapNoticeView.addSubview(aboutMapNoticeLabel)
            naviBarContainerStackView.addArrangedSubviews(underlineView, aboutMapNoticeView)
            
            underlineView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(1)
            }
            
            aboutMapNoticeView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(32)
            }
            
            aboutMapNoticeLabel.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        }
    }
}

// MARK: - Network

extension CourseDrawingVC {
    private func makecourseDrawingRequestDto() -> CourseDrawingRequestDto? {
        guard let image = self.pathImage else { return nil }
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        guard let departureLocationModel = self.departureLocationModel else { return nil }
        let path = mapView.getMarkersLatLng().map { $0.toRNLocationModel() }
        
        let courseDrawingRequestDto = CourseDrawingRequestDto(
            image: imageData,
            path: path,
            title: self.courseName,
            distance: self.distance,
            departureAddress: departureLocationModel.departureAddress,
            departureName: departureLocationModel.departureName)
        
        return courseDrawingRequestDto
    }
    
    private func uploadCourseDrawing() {
        guard let requestDto = makecourseDrawingRequestDto() else { return }
        LoadingIndicator.showLoading()
        
        courseProvider.request(target: .uploadCourseDrawing(param: requestDto), instance: BaseResponse<CourseDrawingResponseData>.self, vc: self) { response in
            LoadingIndicator.hideLoading()
            guard let data = response.data else { return }
            self.presentAlertVC(courseId: data.id)
        }
    }
    
    private func searchLocationTmapAddress(latitude: Double, longitude: Double) {
        departureSearchingProvider.request(
            target: .getLocationTmapAddress(latitude: latitude, longitude: longitude),
            instance: TmapAddressSearchingResponseDto.self,
            vc: self
        ) { data in
            self.updateData(
                model: data.toDepartureLocationModel(
                    latitude: latitude,
                    longitude: longitude
                )
            )
        }
    }
}
