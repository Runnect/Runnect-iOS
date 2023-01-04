//
//  CourseDetailInfoView.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/04.
//

import UIKit

final class CourseDetailInfoView: UIView {
    
    // MARK: - UI Components
    
    private let leftImageView = UIImageView().then {
        $0.image = ImageLiterals.icStar
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .b5
        $0.textColor = .g1
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .b6
        $0.textColor = .g1
    }
    
    // MARK: - initialization
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        self.setUI(title: title, description: description)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CourseDetailInfoView {
    @discardableResult
    func setDescriptionText(description: String) -> Self {
        self.descriptionLabel.text = description
        return self
    }
}

// MARK: - UI & Layout

extension CourseDetailInfoView {
    private func setUI(title: String, description: String) {
        self.backgroundColor = .w1
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
    
    private func setLayout() {
        self.addSubviews(leftImageView, titleLabel, descriptionLabel)
        
        leftImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(leftImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(leftImageView.snp.trailing).offset(9)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading).offset(57)
            make.trailing.greaterThanOrEqualToSuperview()
        }
    }
}
