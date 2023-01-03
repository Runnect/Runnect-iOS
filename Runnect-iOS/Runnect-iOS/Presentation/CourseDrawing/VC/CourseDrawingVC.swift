//
//  CourseDrawingVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/03.
//

import UIKit

final class CourseDrawingVC: UIViewController {
    
    // MARK: - UI Components
    
    private let notchCoverView = UIView().then {
        $0.backgroundColor = .w1
    }
    private lazy var naviBar = CustomNavigationBar(self, type: .search)
        .setTextFieldText(text: "검색 결과")
        .hideRightButton()
    
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

extension CourseDrawingVC {
    
}

// MARK: - UI & Layout

extension CourseDrawingVC {
    private func setUI() {
        self.view.backgroundColor = .w1
        self.departureInfoContainerView.layer.applyShadow(alpha: 0.35, x: 0, y: 3, blur: 10)
    }
    
    private func setLayout() {
        self.view.addSubviews(notchCoverView, naviBar, mapView, departureInfoContainerView)
        self.departureInfoContainerView.addSubviews(departureLocationLabel, departureDetailLocationLabel, decideDepartureButton)
        
        view.bringSubviewToFront(notchCoverView)
        view.bringSubviewToFront(naviBar)
        
        notchCoverView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(-calculateTopInset())
        }
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
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
}
