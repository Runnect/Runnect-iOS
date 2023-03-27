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
        $0.image = ImageLiterals.imgAppIcon
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
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
        $0.textAlignment = .center
    }
    
    // MARK: - initialization
    
    init(title: String) {
        super.init(frame: .zero)
        setUI()
        setLayout()
        setTitle(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension GuideView {
    private func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 22
        self.clipsToBounds = true
        self.layer.applyShadow(color: .black, alpha: 0.12, x: 0, y: 2, blur: 11, spread: 0)
    }
    
    private func setLayout() {
        self.addSubviews(logoImageView, titleContainerView)
        titleContainerView.addSubviews(titleLabel)
        
        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(200)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        titleContainerView.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.centerX)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
}
