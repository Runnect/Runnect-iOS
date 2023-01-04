//
//  UploadedCourseInfoCVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/03.
//

import UIKit
import SnapKit
import Then

final class UploadedCourseInfoCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let uploadedCourseMapImage = UIView().then {
        $0.layer.cornerRadius = 5
    }
    
    private let uploadedCourseTitleLabel = UILabel().then {
        $0.textColor = .g1
        $0.font = .b4
    }
    
    private let uploadedCoursePlaceLabel = UILabel().then {
        $0.textColor = .g2
        $0.font = .b6
    }
    
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

extension UploadedCourseInfoCVC {
    
    // MARK: - Layout Helpers
    
    private func setUI() {
        uploadedCourseMapImage.backgroundColor = .g3
    }
    
    private func setLayout() {
        contentView.addSubviews(uploadedCourseMapImage, uploadedCourseTitleLabel, uploadedCoursePlaceLabel)
        
        contentView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        uploadedCourseMapImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(174)
            make.height.equalTo(124)
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
    
    // MARK: - General Helpers
    
    func dataBind(model: UploadedCourseInfoModel) {
        uploadedCourseTitleLabel.text = model.title
        uploadedCoursePlaceLabel.text = model.place
    }
    
}
