//
//  RunningWaitingVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import UIKit

final class RunningWaitingVC: UIViewController {
    
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
    private func setAddTarget() {
        self.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - @objc Function

extension RunningWaitingVC {
    @objc private func startButtonDidTap() {
        if self.distanceLabel.text == "0.0" {
            return
        }
        
        let countDownVC = CountDownVC()
        countDownVC.setData(locations: self.mapView.getMarkersLatLng(),
                            distance: self.distanceLabel.text,
                            pathImage: UIImage())
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
