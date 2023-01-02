//
//  CourseDrawingHomeVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

final class CourseDrawingHomeVC: UIViewController {
    
    // MARK: - Properties

    private lazy var tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 49
    
    // MARK: - UI Components
    
    private lazy var mapView = RNMapView()
        .setPositionMode(mode: .normal)
        .makeContentPadding(padding: UIEdgeInsets(top: -calculateTopInset(), left: 0, bottom: tabBarHeight, right: 0))
        .moveToUserLocation()
        .showLocationButton(toShow: true)
    
    private let drawCourseButton = CustomButton(title: "코스 그리기")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - UI & Layout

extension CourseDrawingHomeVC {
    private func setUI() {
        view.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(mapView, drawCourseButton)
        
        mapView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        drawCourseButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(75)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
}
