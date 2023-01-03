//
//  CourseDrawingVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/03.
//

import UIKit
import Combine

final class CourseDrawingVC: UIViewController {
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let notchCoverView = UIView().then {
        $0.backgroundColor = .w1
    }
    private lazy var naviBar = CustomNavigationBar(self, type: .search)
        .setTextFieldText(text: "검색 결과")
        .hideRightButton()
    
    private lazy var naviBarForEditing = CustomNavigationBar(self, type: .titleWithLeftButton)
        .then {
            $0.alpha = 0
        }
    
    private lazy var naviBarContainerStackView = UIStackView(
        arrangedSubviews: [notchCoverView, naviBar]
    ).then {
        $0.axis = .vertical
    }
    
    private let mapView = RNMapView().makeStartMarkerAtUserLocation()
    
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
    
    private let completeButton = CustomButton(title: "완성하기").setEnabled(false)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setAddTarget()
        self.bindMapView()
    }
}

// MARK: - Methods

extension CourseDrawingVC {
    private func setAddTarget() {
        self.decideDepartureButton.addTarget(self, action: #selector(decideDepartureButtonDidTap), for: .touchUpInside)
    }
    
    private func bindMapView() {
        mapView.$pathDistance.sink { distance in
            let kilometers = String(format: "%.1f", distance/1000)
            self.distanceLabel.text = kilometers
        }.store(in: cancelBag)
        
        mapView.$markerCount.sink { [weak self] count in
            print(count)
            self?.completeButton.setEnabled(count >= 2)
        }.store(in: cancelBag)
    }
}

// MARK: - @objc Function

extension CourseDrawingVC {
    @objc private func decideDepartureButtonDidTap() {
        showHiddenViews()
        
        mapView.showUndoButton(toShow: true)
        mapView.setDrawMode(to: true)
        
        UIView.animate(withDuration: 0.7) {
            let naviBarContainerStackViewHeight = self.naviBarContainerStackView.frame.height
            self.naviBarContainerStackView.transform = CGAffineTransform(translationX: 0, y: -naviBarContainerStackViewHeight)
            self.departureInfoContainerView.transform = CGAffineTransform(translationX: 0, y: 172)
        }
    }
}

// MARK: - UI & Layout

extension CourseDrawingVC {
    private func setUI() {
        self.view.backgroundColor = .w1
        self.naviBarForEditing.backgroundColor = .clear
        self.departureInfoContainerView.layer.applyShadow(alpha: 0.35, x: 0, y: 3, blur: 10)
        self.distanceContainerView.layer.applyShadow(alpha: 0.2, x: 2, y: 4, blur: 9)
    }
    
    private func setLayout() {
        setHiddenViewsLayout()
        self.view.addSubviews(naviBarContainerStackView, mapView, departureInfoContainerView)
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
    }
    
    private func setHiddenViewsLayout() {
        view.addSubviews(naviBarForEditing, distanceContainerView, completeButton)
        view.sendSubviewToBack(naviBarForEditing)
        
        naviBarForEditing.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
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
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
            make.top.equalTo(view.snp.bottom).offset(34)
        }
    }
    
    private func showHiddenViews() {
        [naviBarForEditing, distanceContainerView, completeButton].forEach { subView in
            view.bringSubviewToFront(subView)
        }
        
        UIView.animate(withDuration: 0.7) {
            self.naviBarForEditing.alpha = 1
            self.distanceContainerView.transform = CGAffineTransform(translationX: 0, y: -151)
            self.completeButton.transform = CGAffineTransform(translationX: 0, y: -112)
        }
    }
}
