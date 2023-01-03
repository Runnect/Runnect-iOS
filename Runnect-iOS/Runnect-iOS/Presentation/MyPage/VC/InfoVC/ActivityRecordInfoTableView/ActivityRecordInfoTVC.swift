//
//  ActivityRecordInfoTVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/03.
//

import UIKit
import SnapKit
import Then

final class ActivityRecordInfoTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    private let activityRecordContainerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.m5.cgColor
    }
    
    private let horizontalDivideLine = UIView()
    private let firstVerticalDivideLine = UIView()
    private let secondVerticalDivideLine = UIView()
    
    private let activityRecordMapImage = UIView().then {
        $0.layer.cornerRadius = 10
    }
    
    private lazy var activityRecordTitleLabel = setBlackTitle()
    private lazy var activityRecordPlaceLabel = setGreyTitle()
    
    private lazy var activityRecordVirticalBarLabel = setGreyTitle().then {
        $0.text = "|"
    }
    
    private lazy var activityRecordDateLabel = setGreyTitle()
    
    private lazy var activityRecordSubTitleStackView = UIStackView(arrangedSubviews: [activityRecordPlaceLabel, activityRecordVirticalBarLabel, activityRecordDateLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private lazy var activityRecordMainInfoStackView = UIStackView(arrangedSubviews: [activityRecordTitleLabel, activityRecordSubTitleStackView]).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 7
    }
    
    private lazy var activityRecordTotalDistanceValueLabel = setBlackTitle()
    private lazy var activityRecordRunningTimeValueLabel = setBlackTitle()
    private lazy var activityRecordAveragePaceValueLabel = setBlackTitle()
    
    private lazy var activityRecordTotalDistanceLabel = setGreyTitle().then {
        $0.text = "총 거리"
    }

    private lazy var activityRecordRunningTimeLabel = setGreyTitle().then {
        $0.text = "이동 시간"
    }
    
    private lazy var activityRecordAveragePaceLabel = setGreyTitle().then {
        $0.text = "평균 페이스"
    }
    
    private lazy var activityRecordTotalDistanceStackView = setDetailInfoStakcView(title: activityRecordTotalDistanceLabel, value: activityRecordTotalDistanceValueLabel)
    
    private lazy var activityRecordRunningTimeStackView = setDetailInfoStakcView(title: activityRecordRunningTimeLabel, value: activityRecordRunningTimeValueLabel)
    
    private lazy var activityRecordAveragePaceStackView = setDetailInfoStakcView(title: activityRecordAveragePaceLabel, value: activityRecordAveragePaceValueLabel)
    
    private lazy var activityRecordSubInfoStackView = UIStackView(arrangedSubviews: [activityRecordTotalDistanceStackView, firstVerticalDivideLine, activityRecordRunningTimeStackView, secondVerticalDivideLine, activityRecordAveragePaceStackView]).then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
    }
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivityRecordInfoTVC {
    
    // MARK: - Method
    
    func setDetailInfoStakcView(title: UIView, value: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [title, value])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }
    
    func setBlackTitle() -> UILabel {
        let label = UILabel()
        label.textColor = .g1
        label.font = .h5
        return label
    }
    
    func setGreyTitle() -> UILabel {
        let label = UILabel()
        label.textColor = .g2
        label.font = .b8
        return label
    }
}

extension ActivityRecordInfoTVC {
    
    // MARK: - Layout Helpers
    
    func setUI() {
        activityRecordMapImage.backgroundColor = .g3
        horizontalDivideLine.backgroundColor = .g4
        firstVerticalDivideLine.backgroundColor = .g4
        secondVerticalDivideLine.backgroundColor = .g4
    }
    
    func setLayout() {
        addSubview(activityRecordContainerView)
        
        activityRecordContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(177)
        }
        
        activityRecordContainerView.addSubviews(
            activityRecordMapImage,
            activityRecordMainInfoStackView,
            horizontalDivideLine,
            activityRecordSubInfoStackView
        )
        
        activityRecordMapImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.72)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(86)
            make.height.equalTo(84.57)
        }
        
        activityRecordMainInfoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(activityRecordMapImage.snp.centerY)
            make.leading.equalTo(activityRecordMapImage.snp.trailing).offset(14)
        }
        
        horizontalDivideLine.snp.makeConstraints { make in
            make.top.equalTo(activityRecordMapImage.snp.bottom).offset(7.87)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
        
        firstVerticalDivideLine.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        secondVerticalDivideLine.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        activityRecordSubInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalDivideLine.snp.bottom).offset(14.82)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    // MARK: - General Helpers
    
    func dataBind(model: ActivityRecordInfoModel) {
        activityRecordTitleLabel.text = model.title
        activityRecordPlaceLabel.text = model.place
        activityRecordDateLabel.text = model.date
        activityRecordTotalDistanceValueLabel.text = model.distance
        activityRecordRunningTimeValueLabel.text = model.runningTime
        activityRecordAveragePaceValueLabel.text = model.averagePace
    }
}
