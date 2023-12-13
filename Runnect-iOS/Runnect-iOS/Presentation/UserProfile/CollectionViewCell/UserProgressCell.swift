//
//  UserProgressCell.swift
//  Runnect-iOS
//
//  Created by 이명진 on 12/11/23.
//

import UIKit

final class UserProgressCell: UICollectionViewCell {
    
    // MARK: - properties
    
    // MARK: - UI Components
    private let runningProgressInfoView = UIView()
    private let userRunningLevelLabel = UILabel().then {
        $0.textColor = .m1
        $0.font = .h4
    }
    private lazy var myRunningProgressBar = UIProgressView(progressViewStyle: .bar).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setProgress(0, animated: false)
        $0.progressTintColor = .m1
        $0.trackTintColor = .m6
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.layer.sublayers![1].cornerRadius = 6
        $0.subviews[1].clipsToBounds = true
    }
    private let myRunnigProgressPercentLabel = UILabel()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension UserProgressCell {
    
    private func setUI() {
        contentView.addSubview(runningProgressInfoView)
        runningProgressInfoView.backgroundColor = .m3
        
        runningProgressInfoView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    private func setLayout() {
        runningProgressInfoView.addSubviews(userRunningLevelLabel, myRunningProgressBar, myRunnigProgressPercentLabel)
        
        userRunningLevelLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(36)
        }
        
        myRunningProgressBar.snp.makeConstraints {
            $0.top.equalTo(userRunningLevelLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(36.53)
            $0.trailing.equalToSuperview().inset(31.6)
            $0.height.equalTo(11)
        }
        
        myRunnigProgressPercentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(31.6)
        }
    }
    
    func setData(model: UserProfileDto) {
        setMyRunningLevelLabel(model: model)
        myRunningProgressBar.setProgress(Float(model.user.levelPercent) / 100, animated: false)
        setMyRunningProgressPercentLabel(model: model)
    }
    
    private func setMyRunningLevelLabel(model: UserProfileDto) {
        let attributedString = NSMutableAttributedString(string: "LV ", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: String(model.user.level), attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g1]))
        userRunningLevelLabel.attributedText = attributedString
    }
    
    private func setMyRunningProgressPercentLabel(model: UserProfileDto) {
        let attributedString = NSMutableAttributedString(string: String(model.user.levelPercent), attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: " /100", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.g2]))
        myRunnigProgressPercentLabel.attributedText = attributedString
    }
}
