//
//  AdImageCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/10.
//

import UIKit
import SnapKit

import Then

class AdImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private let adImageView = UIImageView().then {
        $0.image = ImageLiterals.imgAd
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

extension AdImageCollectionViewCell {
    
    // MARK: - Layout Helpers
    
    func layout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(adImageView)
        adImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
