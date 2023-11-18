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
        $0.spacing = 6
        $0.alignment = .leading
    }
    
    private let divideView = UIView()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "이런 코스 어때요?"
        label.font =  UIFont.h3
        label.textColor = UIColor.g1
        return label
    }()
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "나에게 최적화된 코스를 찾아보세요"
        label.font =  UIFont.b6
        label.textColor = UIColor.g2
        return label
    }()
    
    private lazy var dateSort = UIButton(type: .custom).then {
        $0.setTitle("최신순", for: .normal)
        $0.titleLabel?.font = .h5
        $0.setTitleColor(.g2, for: .normal)
    }
    
    private lazy var scrapSort = UIButton(type: .custom).then {
        $0.setTitle("스크랩순", for: .normal)
        $0.titleLabel?.font = .h5
        $0.setTitleColor(.g2, for: .normal)
    }
    
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
        contentView.addSubviews(titleStackView, divideView, dateSort, scrapSort)
        
        divideView.backgroundColor = .g4
        
        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        divideView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.top).offset(-34)
            $0.centerX.equalToSuperview().inset(16)
            $0.width.equalTo(358)
            $0.height.equalTo(1)
        }
        
        dateSort.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(54)
            $0.leading.equalTo(titleStackView.snp.trailing).offset(57)
        }
        
        scrapSort.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(54)
            $0.leading.equalTo(dateSort.snp.trailing).offset(8)
        }
    }
}
