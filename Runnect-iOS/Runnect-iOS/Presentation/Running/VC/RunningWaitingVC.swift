//
//  RunningWaitingVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import UIKit

import NMapsMap
import Moya

final class RunningWaitingVC: UIViewController {
    
    // MARK: - Properties
    
    private var courseId: Int?
    private var publicCourseId: Int?
    private var courseModel: Course?
    
    private let courseProvider = Providers.courseProvider
    
    private let recordProvider = Providers.recordProvider
    
    // MARK: - UI Components

    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
    
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
        
        getCourseDetail(courseId: courseId)
    }
    
    private func setCourseData(courseModel: Course) {
        self.courseModel = courseModel
        
        guard let path = courseModel.path, let distance = courseModel.distance else { return }
        let locations = path.map { NMGLatLng(lat: $0[0], lng: $0[1]) }
        self.makePath(locations: locations)
        self.distanceLabel.text = String(distance)
    }
    
    func makePath(locations: [NMGLatLng]) {
        self.mapView.makeMarkersWithStartMarker(at: locations, moveCameraToStartMarker: true)
    }
    
    private func setAddTarget() {
        self.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
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
}

// MARK: - UI & Layout

extension RunningWaitingVC {
    private func setUI() {
        self.view.backgroundColor = .w1
        self.distanceContainerView.layer.applyShadow(alpha: 0.2, x: 2, y: 4, blur: 9)
        self.naviBar.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(naviBar,
                         mapView,
                         distanceContainerView,
                         startButton)
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        view.bringSubviewToFront(naviBar)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
            make.top.equalTo(view.snp.bottom).offset(34)
        }
    }
    
    private func showHiddenViews(withDuration: TimeInterval = 0) {
        [distanceContainerView, startButton].forEach { subView in
            view.bringSubviewToFront(subView)
        }
        
        UIView.animate(withDuration: withDuration) {
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
