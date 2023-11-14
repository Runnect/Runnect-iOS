//
//  CourseDrawingVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/03.
//

import UIKit
import Combine

import Moya

final class CourseDrawingVC: UIViewController {
    
    // MARK: - Properties
    
    private let courseProvider = Providers.courseProvider
    private let departureSearchingProvider = Providers.departureSearchingProvider
    
    private var departureLocationModel: DepartureLocationModel?
    
    var pathImage: UIImage?
    var distance: Float = 0.0
    
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
        }.store(in: cancelBag)
    }
    
    private func setNavigationGesture(_ isEnabled: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabled
    }
    
    private func presentAlertVC(courseId: Int) {
        let alertVC = CustomAlertVC()
        alertVC.modalPresentationStyle = .overFullScreen
        
        alertVC.leftButtonTapped.sink { [weak self] _ in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = 1
            self.navigationController?.popToRootViewController(animated: true)
            alertVC.dismiss(animated: true)
        }.store(in: cancelBag)
        
        alertVC.rightButtonTapped.sink { [weak self] _ in
            guard let self = self else { return }
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
    
    /// 수정 필요 - 바텀시트에서 완료 버튼을 누른 경우
    /// 아래의 코드를 호출해주어야함
    /// guard let self = self else { return }
    /// guard handleVisitor() else { return }
    /// self.mapView.capturePathImage()
}

// MARK: - @objc Function

extension CourseDrawingVC {
    @objc private func decideDepartureButtonDidTap() {
        showHiddenViews(withDuration: 0.7)
        
        if SelectedInfo.shared.type == .map {
            startMarkStackView.isHidden = true
            guard let model = self.departureLocationModel else { return }
            mapView.makeStartMarker(at: model.toNMGLatLng(), withCameraMove: true)
        }
        
        mapView.setDrawMode(to: true)
    }
    
    @objc private func undoButtonDidTap() {
        mapView.undo()
    }
    
    /// 수정 필요 - 다음으로 버튼 눌린 경우 호출될 함수
    @objc private func completeButtonDidTap() {
//        let bottomSheetVC = CourseNameBottomSheetVC()
//        bottomSheetVC.modalPresentationStyle = .overFullScreen
//        self.present(bottomSheetVC, animated: false)
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
        self.view.addSubviews(naviBarContainerStackView, mapView, departureInfoContainerView)
        self.view.addSubview(startMarkStackView)
        self.departureInfoContainerView.addSubviews(departureLocationLabel, departureDetailLocationLabel, decideDepartureButton)
        view.bringSubviewToFront(naviBarContainerStackView)
        
        notchCoverView.snp.makeConstraints { make in
            var notchHeight = calculateTopInset()
            if notchHeight == -44 {
                let statusBarHeight = UIApplication.shared.statusBarHeight
                notchHeight = -statusBarHeight
            }
            make.height.equalTo(-notchHeight)
        }
        
        naviBar.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        naviBarContainerStackView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        startLabelUIImage.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.width.equalTo(58)
        }
        startMarkUIImage.snp.makeConstraints { make in
            make.height.width.equalTo(65)
        }
        
        startMarkStackView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(65)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-17)
        }
        
        departureInfoContainerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(172)
        }
        
        departureLocationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        departureDetailLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(departureLocationLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        decideDepartureButton.snp.makeConstraints { make in
            make.top.equalTo(departureDetailLocationLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        if SelectedInfo.shared.type == .map {
            self.aboutMapNoticeView.addSubview(aboutMapNoticeLabel)
            self.naviBarContainerStackView.addArrangedSubviews(underlineView,aboutMapNoticeView)
            
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
    
    private func setHiddenViewsLayout() {
        view.addSubviews(naviBarForEditing, guideView, distanceContainerView, completeButton, undoButton)
        view.sendSubviewToBack(naviBarForEditing)
        
        naviBarForEditing.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        guideView.snp.makeConstraints { make in
            make.centerY.equalTo(naviBarForEditing.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(55)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(27)
        }
        
        distanceContainerView.snp.makeConstraints { make in
            make.width.equalTo(96)
            make.height.equalTo(44)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.snp.bottom)
        }
        
        distanceContainerView.addSubviews(distanceStackView)
        
        distanceStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        undoButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.snp.bottom)
        }

        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
            make.top.equalTo(view.snp.bottom).offset(34)
        }
    }
    
    private func showHiddenViews(withDuration: TimeInterval = 0) {
        [naviBarForEditing, guideView, distanceContainerView, completeButton, undoButton].forEach { subView in
            view.bringSubviewToFront(subView)
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
}

// MARK: - Network

extension CourseDrawingVC {
    private func makecourseDrawingRequestDto() -> CourseDrawingRequestDto? {
        guard let image = self.pathImage else { return nil }
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        guard let departureLocationModel = self.departureLocationModel else { return nil }
        let path = mapView.getMarkersLatLng().map { $0.toRNLocationModel() }
        let courseDrawingRequestData = CourseDrawingRequestData(path: path,
                                                                distance: self.distance,
                                                                departureAddress: departureLocationModel.departureAddress,
                                                                departureName: departureLocationModel.departureName)

        let courseDrawingRequestDto = CourseDrawingRequestDto(image: imageData, data: courseDrawingRequestData)
        
        return courseDrawingRequestDto
    }
    
    private func uploadCourseDrawing() {
        guard let requestDto = makecourseDrawingRequestDto() else { return }
        
        LoadingIndicator.showLoading()
        courseProvider.request(.uploadCourseDrawing(param: requestDto)) {[weak self] response in
            guard let self = self else { return }
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<CourseDrawingResponseData>.self)
                        guard let data = responseDto.data else { return }
                        self.presentAlertVC(courseId: data.course.id)
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
    
    private func searchLocationTmapAddress(latitude: Double, longitude: Double) {
        departureSearchingProvider
            .request(.getLocationTmapAddress(latitude: latitude, longitude: longitude)) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let result):
                    let status = result.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try result.map(TmapAddressSearchingResponseDto.self)
                            self.updateData(model: responseDto.toDepartureLocationModel(latitude: latitude, longitude: longitude))
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    if status >= 400 {
                        print("400 error")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showToast(message: "네트워크 통신 실패")
                }
            }
    }
}

