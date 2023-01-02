//
//  GoalRewardInfoCVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit
import SnapKit
import Then

// MARK: - GoalRewardInfoCVC

class GoalRewardInfoCVC: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "GoalRewardInfoCVC"
    
    // MARK: - UI Components
    
    private let containerView = UIView()
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

extension GoalRewardInfoCVC {
    
    // MARK: - Layout Helpers
    
    private func setLayout() {
        contentView.addSubviews(stampImageView, stampStandardLabel)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(112)
        }
        
        stampImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(90)
        }
        
        stampStandardLabel.snp.makeConstraints { make in
            make.top.equalTo(stampImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - General Helpers
    
    func dataBind(model: GoalRewardInfoModel) {
        stampImageView.image = model.stampImg
        stampStandardLabel.text = model.stampStandard
    }
}
