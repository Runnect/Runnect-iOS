//
//  GoalRewardTitleCVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/05/18.
//

import UIKit

import SnapKit
import Then

// MARK: - GoalRewardTitleCVC

final class GoalRewardTitleCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let stampTopView = UIView()
    
    private let stampImage = UIImageView().then {
        $0.image = ImageLiterals.imgStamp
    }
    
    private let stampExcourageLabel = UILabel().then {
        $0.text = "다양한 코스를 달리며 러닝 스탬프를 모아봐요"
        $0.textColor = .g2
        $0.font = .b4
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension GoalRewardTitleCVC {
    private func setUI() {
        contentView.backgroundColor = .w1
    }
    
    private func setLayout() {
        contentView.addSubviews(stampImage, stampExcourageLabel)
        
        stampImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(139)
            $0.height.equalTo(126)
        }
        
        stampExcourageLabel.snp.makeConstraints {
            $0.top.equalTo(stampImage.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(37)
        }
    }
}
