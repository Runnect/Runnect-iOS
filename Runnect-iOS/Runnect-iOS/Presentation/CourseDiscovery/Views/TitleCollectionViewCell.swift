//
//  TitleCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/10.
//

import UIKit
import SnapKit

import Then

class TitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private lazy var titleStackView = UIStackView(arrangedSubviews: [mainLabel, subLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "코스 추천"
        label.font =  UIFont.h4
        label.textColor = UIColor.g1
        return label
    }()
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 코스를 발견해나가요"
        label.font =  UIFont.b6
        label.textColor = UIColor.g1
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

extension TitleCollectionViewCell {
    
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
