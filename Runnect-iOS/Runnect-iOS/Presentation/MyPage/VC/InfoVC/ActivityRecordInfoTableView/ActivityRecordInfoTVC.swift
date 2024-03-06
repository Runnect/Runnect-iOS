//
//  ActivityRecordInfoTVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/03.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class ActivityRecordInfoTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    var activityRecordContainerView = UIImageView().then {
        $0.image = ImageLiterals.imgRecordContainer
    }
    
    private lazy var horizontalDivideLine = UIView().then {
        setLineDot(view: $0)
    }
    
    private let firstVerticalDivideLine = UIView()
    private let secondVerticalDivideLine = UIView()
    
    private let activityRecordMapImage = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.g4.cgColor
        $0.clipsToBounds = true
    }
    
    private lazy var activityRecordTitleLabel = SetInfoLayout.makeBlackSmallTitleLabel()
    private lazy var activityRecordPlaceLabel = SetInfoLayout.makeGreyTitleLabel()
    private lazy var activityRecordVirticalBarLabel = SetInfoLayout.makeGreySmailTitleLabel().then {
        $0.text = "|"
    }
    
    private lazy var activityRecordDateLabel = SetInfoLayout.makeGreySmailTitleLabel()
    
    private lazy var activityRecordSubTitleStackView = UIStackView(arrangedSubviews: [activityRecordPlaceLabel, activityRecordVirticalBarLabel, activityRecordDateLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    private lazy var activityRecordMainInfoStackView = UIStackView(arrangedSubviews: [activityRecordTitleLabel, activityRecordSubTitleStackView]).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 7
    }
    
    private lazy var activityRecordTotalDistanceValueLabel = SetInfoLayout.makeBlackSmallTitleLabel()
    private lazy var activityRecordRunningTimeValueLabel = SetInfoLayout.makeBlackSmallTitleLabel()
    private lazy var activityRecordAveragePaceValueLabel = SetInfoLayout.makeBlackSmallTitleLabel()
    
    private lazy var activityRecordTotalDistanceLabel = SetInfoLayout.makeGreySmailTitleLabel().then {
        $0.text = "총 거리"
    }
    
    private lazy var activityRecordRunningTimeLabel = SetInfoLayout.makeGreySmailTitleLabel().then {
        $0.text = "이동 시간"
    }
    
    private lazy var activityRecordAveragePaceLabel = SetInfoLayout.makeGreySmailTitleLabel().then {
        $0.text = "평균 페이스"
    }
    
    private lazy var activityRecordTotalDistanceStackView = setDetailInfoStakcView(title: activityRecordTotalDistanceLabel, value: activityRecordTotalDistanceValueLabel)
    
    private lazy var activityRecordRunningTimeStackView = setDetailInfoStakcView(title: activityRecordRunningTimeLabel, value: activityRecordRunningTimeValueLabel)
    
    private lazy var activityRecordAveragePaceStackView = setDetailInfoStakcView(title: activityRecordAveragePaceLabel, value: activityRecordAveragePaceValueLabel)
    
    private lazy var activityRecordSubInfoStackView = UIStackView(arrangedSubviews: [activityRecordTotalDistanceStackView, firstVerticalDivideLine, activityRecordRunningTimeStackView, secondVerticalDivideLine, activityRecordAveragePaceStackView]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        setLineDot(view: self.horizontalDivideLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.activityRecordContainerView.image = selected ? ImageLiterals.imgRecordContainerSelected : ImageLiterals.imgRecordContainer
    }
}

// MARK: - Methods

extension ActivityRecordInfoTVC {
    func setData(model: ActivityRecord) {
        // 날짜 바꾸기
        let activityRecordDate = model.createdAt.prefix(10)
        let resultDate = RNTimeFormatter.changeDateSplit(date: String(activityRecordDate))
        
        // 이동 시간 바꾸기
        let activityRecordRunningTime = model.time.suffix(7)
        
        // 평균 페이스 바꾸기
        let array = spiltActivityRecordAveragePace(model: model)
        
        activityRecordTitleLabel.text = model.title
        setUpActivityRecordPlaceLabel(model: model, label: activityRecordPlaceLabel)
        activityRecordDateLabel.text = resultDate
        setUpactivityRecordTotalDistanceValueLabel(model: model, label: activityRecordTotalDistanceValueLabel)
        activityRecordRunningTimeValueLabel.text = String(activityRecordRunningTime)
        setUpActivityRecordAveragePaceValueLabel(array: array, label: activityRecordAveragePaceValueLabel)
        activityRecordMapImage.setImage(with: model.image)
    }
    
    func updateSelectionCellUI(isSelected: Bool) {
        activityRecordContainerView.image = isSelected ? ImageLiterals.imgRecordContainerSelected : ImageLiterals.imgRecordContainer
    }
    
    private func setUpActivityRecordPlaceLabel(model: ActivityRecord, label: UILabel) {
        let attributedString = NSMutableAttributedString(string: String(model.departure.region) + " ", attributes: [.font: UIFont.b8, .foregroundColor: UIColor.g2])
        attributedString.append(NSAttributedString(string: String(model.departure.city), attributes: [.font: UIFont.b8, .foregroundColor: UIColor.g2]))
        label.attributedText = attributedString
    }
    
    private func setUpactivityRecordTotalDistanceValueLabel(model: ActivityRecord, label: UILabel) {
        let attributedString = NSMutableAttributedString(string: String(model.distance) + " ", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: "km", attributes: [.font: UIFont.b4, .foregroundColor: UIColor.g1]))
        label.attributedText = attributedString
    }
    
    private func setUpActivityRecordAveragePaceValueLabel(array: [String], label: UILabel) {
        let numberArray = array.compactMap { Int($0) }   /// 페이스에서 첫번째 인덱스 두번째 값만 가져오기 위해
        let attributedString = NSMutableAttributedString(string: String(numberArray[1]) + "’", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: String(array[2]) + "”", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1]))
        label.attributedText = attributedString
    }
    
    private func spiltActivityRecordAveragePace(model: ActivityRecord) -> [String] {
        let activityRecordAveragePace = model.pace
        let array = activityRecordAveragePace.split(separator: ":").map { String($0) }
        return array
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
    
    func setLineDot(view: UIView) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.g4.cgColor
        borderLayer.lineDashPattern = [4, 4]
        borderLayer.frame = view.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: view.bounds).cgPath
        
        view.layer.addSublayer(borderLayer)
    }
}

extension ActivityRecordInfoTVC {
    
    // MARK: - Layout Helpers
    
    func setUI() {
        horizontalDivideLine.backgroundColor = .g4
        firstVerticalDivideLine.backgroundColor = .g4
        secondVerticalDivideLine.backgroundColor = .g4
        self.backgroundColor = .clear
    }
    
    func setLayout() {
        addSubview(activityRecordContainerView)
        
        activityRecordContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(177)
        }
        
        activityRecordContainerView.addSubviews(
            activityRecordMapImage,
            activityRecordMainInfoStackView,
            horizontalDivideLine,
            activityRecordSubInfoStackView
        )
        
        activityRecordMapImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(86)
            $0.height.equalTo(85)
        }
        
        activityRecordMainInfoStackView.snp.makeConstraints {
            $0.centerY.equalTo(activityRecordMapImage.snp.centerY)
            $0.leading.equalTo(activityRecordMapImage.snp.trailing).offset(14)
        }
        
        horizontalDivideLine.snp.makeConstraints {
            $0.top.equalTo(activityRecordMapImage.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        firstVerticalDivideLine.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        
        secondVerticalDivideLine.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        
        setActivityRecordSubInfoStackView()
    }
    
    private func setActivityRecordSubInfoStackView() {
        let screenWidth = UIScreen.main.bounds.width
        let containerViewWidth = screenWidth - 32
        let stackViewWidth = Int(containerViewWidth - 2) / 3
        
        activityRecordTotalDistanceStackView.snp.makeConstraints {
            $0.width.equalTo(stackViewWidth)
        }
        
        activityRecordRunningTimeStackView.snp.makeConstraints {
            $0.width.equalTo(stackViewWidth)
        }
        
        activityRecordAveragePaceStackView.snp.makeConstraints {
            $0.width.equalTo(stackViewWidth)
        }
        
        activityRecordSubInfoStackView.snp.makeConstraints {
            $0.top.equalTo(horizontalDivideLine.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
}
