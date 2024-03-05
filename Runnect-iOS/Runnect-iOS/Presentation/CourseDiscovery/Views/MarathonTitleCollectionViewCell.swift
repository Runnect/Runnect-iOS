//
//  MarathonTitleCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by 이명진 on 11/18/23.
//

import UIKit

import SnapKit
import Then

final class MarathonTitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private lazy var titleStackView = UIStackView(
        arrangedSubviews: [
            mainLabel,
            subLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .leading
    }
    
    private let mainLabel: UILabel = UILabel().then {
        $0.text = "2023 마라톤 코스"
        $0.font = UIFont.h3
        $0.textColor = UIColor.g1
    }
    
    private let subLabel: UILabel = UILabel().then {
        $0.text = "실제 마라톤 코스를 만나보세요"
        $0.font = UIFont.b6
        $0.textColor = UIColor.g2
    }
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: - Layout Helpers

extension MarathonTitleCollectionViewCell {
    private func setLayout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(titleStackView)
        
        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
    }
}
