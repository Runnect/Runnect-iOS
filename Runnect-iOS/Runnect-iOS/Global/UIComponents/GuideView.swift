//
//  GuideView.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/03/27.
//

import UIKit

final class GuideView: UIView {
    
    // MARK: - UI Components
    
    private let logoImageView = UIImageView().then {
        $0.image = ImageLiterals.icLogoCircle
        $0.backgroundColor = .clear
    }
    
    private let titleContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .b6
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    
    // MARK: - initialization
    
    init(title: String) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension GuideView {
    private func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        self.layer.applyShadow(color: .black, alpha: 0.12, x: 0, y: 2, blur: 11, spread: 0)
    }
    
    private func setLayout() {
        self.addSubviews(logoImageView, titleContainerView)
        titleContainerView.addSubviews(titleLabel)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(43)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        titleContainerView.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.center)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
