//
//  LocationSearchResultTVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//

import UIKit

final class LocationSearchResultTVC: UITableViewCell {
    
    // MARK: - UI Components

    private let locationPointImageView = UIImageView().then {
        $0.image = ImageLiterals.icLocationPoint
        $0.tintColor = .g3
    }
    
    private let locationLabel = UILabel().then {
        $0.text = "장소"
        $0.font = .b1
        $0.textColor = .g1
    }
    
    private let detailLocationLabel = UILabel().then {
        $0.text = "상세 주소"
        $0.font = .b6
        $0.textColor = .g2
    }
    
    private lazy var locationStackView = UIStackView(arrangedSubviews: [locationLabel, detailLocationLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .g5
    }
    
    // MARK: - initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension LocationSearchResultTVC {
    func setData(model: KakaoAddressResult) {
        self.locationLabel.text = model.placeName
        self.detailLocationLabel.text = model.addressName
    }
}

// MARK: - UI & Layout

extension LocationSearchResultTVC {
    private func setUI() {
        self.backgroundColor = .w1
        self.contentView.backgroundColor = .w1
    }
    
    private func setLayout() {
        self.addSubviews(locationPointImageView, locationStackView, dividerView)
        
        locationPointImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        locationStackView.snp.makeConstraints { make in
            make.leading.equalTo(locationPointImageView.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        
        dividerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
