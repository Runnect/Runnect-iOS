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
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목제목제목제목제목"
        label.font =  UIFont.b4
        label.textColor = UIColor.black
        return label
    }()
    private let locationLabel : UILabel = {
        let label = UILabel()
        label.text = "00시 00구"
        label.font = UIFont.b6
        label.textColor = UIColor.g2
        return label
    }()
    private let heartButton = UIImageView().then {
        $0.image = ImageLiterals.icHeartFill
    }
    
    //MARK: - Life Cycle
    override init(frame : CGRect){
        super.init(frame: frame)
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Extensions

extension MapCollectionViewCell {
    // MARK: - Layout Helpers
    
    private func layout() {
//        backgroundColor = .red
        contentView.backgroundColor = .clear
        mapImageView.backgroundColor = .systemGray4
        [mapContainerView,mapImageView,titleLabel,locationLabel,heartButton].forEach{
            contentView.addSubview($0)
        }
        mapContainerView.addSubview(mapImageView)
        mapContainerView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(161)
        }
        mapImageView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(self.titleLabel.snp.top)
            $0.height.equalTo(110)
            
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(mapImageView.snp.bottom).offset(4)
            $0.leading.equalTo(self.mapContainerView.snp.leading)
        }
        heartButton.snp.makeConstraints{
            $0.top.equalTo(mapImageView.snp.bottom).offset(4)
//            $0.trailing.equalTo(self.mapContainerView.snp.trailing)
            $0.width.equalTo(14)
            $0.height.equalTo(12)
            $0.trailing.equalTo(self.mapContainerView.snp.trailing)
        }
        
        locationLabel.snp.makeConstraints{
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
