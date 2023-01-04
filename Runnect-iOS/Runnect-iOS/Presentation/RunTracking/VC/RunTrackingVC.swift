//
//  RunTrackingVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/04.
//

import UIKit
import Combine

import NMapsMap

final class RunTrackingVC: UIViewController {
    
    // MARK: - Properties
    
    private let stopwatch = Stopwatch()
    private var cancelBag = CancelBag()
    var totalTime: Int = 0
    var distance: String = "0.0"
    var pathImage: UIImage?
    
    // MARK: - UI Components
    
    private let statsView = UIView().then {
        $0.backgroundColor = .w1
        $0.layer.cornerRadius = 40
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
    
    private let backButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icArrowBack, for: .normal)
        $0.tintColor = .g1
    }
    
    private let distanceImageView = UIImageView().then {
        $0.image = ImageLiterals.icDistance
        $0.tintColor = .g2
    }
    
    private let distanceLabel = UILabel().then {
        $0.text = "총 거리"
        $0.font = .b4
        $0.textColor = .g2
    }
    
    private lazy var distanceInfoStackView = UIStackView(
        arrangedSubviews: [distanceImageView, distanceLabel]
    ).then {
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private lazy var totalDistanceLabel = UILabel().then {
        $0.attributedText = makeAttributedLabelForDistance(distance: "0.0")
    }
    
    private lazy var distanceStatsStackView = UIStackView(
        arrangedSubviews: [distanceInfoStackView, totalDistanceLabel]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 14
    }
    
    private let timeImageView = UIImageView().then {
        $0.image = ImageLiterals.icTime
        $0.tintColor = .g2
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "시간"
        $0.font = .b4
        $0.textColor = .g2
    }
    
    private lazy var timeInfoStackView = UIStackView(
        arrangedSubviews: [timeImageView, timeLabel]
    ).then {
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private let timeStatsLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.font = .h1
        $0.textColor = .g1
    }
    
    private lazy var timeStatsStackView = UIStackView(
        arrangedSubviews: [timeInfoStackView, timeStatsLabel]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 14
    }
    
    private lazy var statsStackView = UIStackView(
        arrangedSubviews: [distanceStatsStackView, timeStatsStackView]
    ).then {
        $0.spacing = 38
    }
    
    private let bigStarImageView = UIImageView().then {
        $0.image = ImageLiterals.icStar2
    }
    
    private let smallStarImageView = UIImageView().then {
        $0.image = ImageLiterals.icStar
    }
    
    private let mapView = RNMapView()
        .showLocationButton(toShow: true)
        .makeContentPadding(padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        .setPositionMode(mode: .normal)
    
    private let runningCompleteButton = CustomButton(title: "러닝 종료")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setAddTarget()
        self.bindMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindStopwatch()
    }
}

// MARK: - Methods

extension RunTrackingVC {
    func makePath(locations: [NMGLatLng], distance: String) {
        self.mapView.makeMarkersWithStartMarker(at: locations, willCapture: true)
        self.totalDistanceLabel.attributedText = makeAttributedLabelForDistance(distance: distance)
        self.distance = distance
    }
    
    private func setAddTarget() {
        self.backButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
        self.runningCompleteButton.addTarget(self, action: #selector(runningCompleteButtonDidTap), for: .touchUpInside)
    }
    
    private func makeAttributedLabelForDistance(distance: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: distance,
            attributes: [.font: UIFont.h1, .foregroundColor: UIColor.g1]
        )
        attributedString.append(
            NSAttributedString(
                string: " Km",
                attributes: [.font: UIFont.b4, .foregroundColor: UIColor.g2]
            )
        )
        
        return attributedString
    }
    
    private func bindStopwatch() {
        stopwatch.isRunning.toggle()
        
        stopwatch.$elapsedTime.sink { [weak self] time in
            guard let self = self else { return }
            let time = Int(time)
            self.totalTime = time
            self.setTimeLabel(with: time)
        }.store(in: cancelBag)
    }
    
    private func bindMapView() {
        mapView.pathImage.sink { [weak self] image in
            guard let self = self else { return }
            self.pathImage = image
            LoadingIndicator.hideLoading()
        }.store(in: cancelBag)
    }
    
    private func setTimeLabel(with totalSeconds: Int) {
        let formattedString = RNTimeFormatter.secondsToHHMMSS(seconds: totalSeconds)
        
        timeStatsLabel.text = formattedString
    }
    
    private func pushToRunningRecordVC() {
        guard let distance = Float(self.distance) else { return }
        let averagePaceSeconds = Int(Float(self.totalTime) / distance)
        let formatedAveragePace = "\(averagePaceSeconds / 60)'\(averagePaceSeconds % 60)''"
        
        let runningRecordVC = RunningRecordVC()
        runningRecordVC.setData(distance: self.distance,
                                totalTime: RNTimeFormatter.secondsToHHMMSS(seconds: self.totalTime),
                                averagePace: formatedAveragePace, pathImage: pathImage)
        self.navigationController?.pushViewController(runningRecordVC, animated: true)
    }
}

// MARK: - @objc Function

extension RunTrackingVC {
    @objc private func popToPreviousVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func runningCompleteButtonDidTap() {
        LoadingIndicator.showLoading()
        self.mapView.getPathImage()
        stopwatch.isRunning.toggle()
        let bottomSheetVC = CustomBottomSheetVC()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        
        bottomSheetVC.completeButtonTapped.sink { [weak self] _ in
            guard let self = self else { return }
            self.pushToRunningRecordVC()
            bottomSheetVC.dismiss(animated: true)
        }.store(in: cancelBag)
        
        self.present(bottomSheetVC, animated: true)
    }
}

// MARK: - UI & Layout
extension RunTrackingVC {
    private func setUI() {
        view.backgroundColor = .w1
        statsView.layer.applyShadow(alpha: 0.2, x: 0, y: 5, blur: 6, spread: 0)
    }
    
    private func setLayout() {
        view.addSubviews(mapView, statsView, runningCompleteButton)
        statsView.addSubviews(backButton, statsStackView, bigStarImageView, smallStarImageView)
        
        statsView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        statsStackView.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing)
            make.top.equalToSuperview().inset(15)
        }
        
        bigStarImageView.snp.makeConstraints { make in
            make.centerY.equalTo(timeStatsLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(15)
        }
        
        smallStarImageView.snp.makeConstraints { make in
            make.top.equalTo(bigStarImageView.snp.bottom).offset(2)
            make.centerX.equalTo(bigStarImageView.snp.leading).multipliedBy(0.99)
        }
        
        mapView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        runningCompleteButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(34)
        }
    }
}
