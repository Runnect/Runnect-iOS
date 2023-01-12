//
//  UploadedCourseInfoCVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/03.
//

import UIKit

import SnapKit
import Then
import Moya
import Kingfisher

final class UploadedCourseInfoCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let uploadedCourseMapImage = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let uploadedCourseTitleLabel = UILabel().then {
        $0.textColor = .g1
        $0.font = .b4
    }
    
    private let uploadedCoursePlaceLabel = UILabel()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension UploadedCourseInfoCVC {
    func setData(model: PublicCourse) {
        uploadedCourseMapImage.setImage(with: model.image)
        uploadedCourseTitleLabel.text = model.title
        setUploadedCoursePlaceLabel(model: model, label: uploadedCoursePlaceLabel)
    }
    
    func setUploadedCoursePlaceLabel(model: PublicCourse, label: UILabel) {
        let attributedString = NSMutableAttributedString(string: String(model.departure.region) + " ", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.g2])
        attributedString.append(NSAttributedString(string: String(model.departure.city), attributes: [.font: UIFont.b6, .foregroundColor: UIColor.g2]))
        label.attributedText = attributedString
    }
}

extension UploadedCourseInfoCVC {
    
    // MARK: - Layout Helpers
    
    private func setUI() {
        uploadedCourseMapImage.backgroundColor = .g3
    }
    
    private func setLayout() {
        contentView.addSubviews(uploadedCourseMapImage, uploadedCourseTitleLabel, uploadedCoursePlaceLabel)
        
        uploadedCourseMapImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(0.7)
        }
        
        uploadedCourseTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(uploadedCourseMapImage.snp.bottom).offset(7)
            make.leading.equalToSuperview()
        }
        
        uploadedCoursePlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(uploadedCourseTitleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }
    }
}
