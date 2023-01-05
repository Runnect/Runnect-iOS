//
//  MapCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/02.
//

import UIKit
import SnapKit

import Then

class MapCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "MapCollectionViewCell"
    // MARK: - UI Components
    private let mapContainerView = UIView()
    private let mapImageView = UIImageView().then {
        $0.image = ImageLiterals.imgLogo
        $0.layer.cornerRadius = 5
    }
    private let titleLabel = UILabel().then {
        $0.text = "제목제목제목제목제목"
        $0.font =  UIFont.b4
        $0.textColor = UIColor.black
    }
    private let locationLabel = UILabel().then {
        $0.text = "00시 00구"
        $0.font = UIFont.b6
        $0.textColor = UIColor.g2
    }
    private let heartButton = UIImageView().then {
        $0.image = ImageLiterals.icHeartFill
    }
    // MARK: - ClickAction Constants
    var clickCount: Int = 0 {
            didSet {
                if clickCount == 0 {
                    mapImageView.backgroundColor = UIColor.systemGray4
                    mapImageView.alpha = 1
                    mapImageView.layer.borderColor = UIColor.w1.cgColor
                    mapImageView.layer.borderWidth = 0
                }
                else {
                    mapImageView.backgroundColor = UIColor.m1
                    mapImageView.alpha = 0.15
                    mapImageView.layer.borderColor = UIColor.purple.cgColor
                    mapImageView.layer.borderWidth = 2
                }
            }
        }
        override var isSelected: Bool {
            didSet {
                if !isSelected {
                    mapImageView.backgroundColor = UIColor.systemGray4
                    mapImageView.alpha = 1
                    mapImageView.layer.borderColor = UIColor.w1.cgColor
                    mapImageView.layer.borderWidth = 0
                    clickCount = 0
                }
            }
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

extension MapCollectionViewCell {
    // MARK: - Function
   
    // MARK: - Layout Helpers
    
    private func layout() {
        contentView.backgroundColor = .clear
        mapImageView.backgroundColor = .systemGray4
        [mapContainerView, mapImageView, titleLabel, locationLabel, heartButton].forEach {
            contentView.addSubview($0)}
        mapContainerView.addSubview(mapImageView)
        mapContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(161)
        }
        mapImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(110)
            
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mapImageView.snp.bottom).offset(4)
            $0.leading.equalTo(self.mapContainerView.snp.leading)
        }
        heartButton.snp.makeConstraints {
            $0.top.equalTo(mapImageView.snp.bottom).offset(4)
            $0.width.equalTo(14)
            $0.height.equalTo(12)
            $0.trailing.equalTo(self.mapContainerView.snp.trailing)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.leading.equalTo(self.mapContainerView.snp.leading)
        }
    }
    
    // MARK: - General Helpers
    
    func dataBind(model: MapModel) {
        mapImageView.image = UIImage(named: model.mapImage)
        titleLabel.text = model.title
        locationLabel.text = model.location
    }
}
