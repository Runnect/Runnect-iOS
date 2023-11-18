//
//  MarathonTitleCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by 이명진 on 11/18/23.
//

import UIKit

class MarathonTitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private lazy var titleStackView = UIStackView(arrangedSubviews: [mainLabel, subLabel]).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .leading
    }
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "2023 마라톤 코스"
        label.font =  UIFont.h3
        label.textColor = UIColor.g1
        return label
    }()
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "실제 마라톤 코스를 만나보세요"
        label.font =  UIFont.b6
        label.textColor = UIColor.g2
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension MarathonTitleCollectionViewCell {
    
    // MARK: - Layout Helpers
    
    func layout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(titleStackView)
        
        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
    }
}
