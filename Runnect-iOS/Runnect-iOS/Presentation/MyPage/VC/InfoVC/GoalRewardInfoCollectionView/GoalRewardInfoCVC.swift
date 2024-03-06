//
//  GoalRewardInfoCVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit

import SnapKit
import Then
import Kingfisher

// MARK: - GoalRewardInfoCVC

final class GoalRewardInfoCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let stampImageView = UIImageView()
    private let stampStandardLabel = UILabel().then {
        $0.textColor = .g1
        $0.font = .b7
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension GoalRewardInfoCVC {
    func setData(model: GoalRewardInfoModel, item: Bool) {
        if item == true {
            stampImageView.image = model.stampImg
            
        } else {
            stampImageView.image = ImageLiterals.imgLock
        }
        stampStandardLabel.text = model.stampStandard
    }
}

// MARK: - Layout Helpers

extension GoalRewardInfoCVC {
    private func setLayout() {
        contentView.addSubviews(stampImageView, stampStandardLabel)
        
        stampImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.width)
        }
        
        stampStandardLabel.snp.makeConstraints {
            $0.top.equalTo(stampImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
}
