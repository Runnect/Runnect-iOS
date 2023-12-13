//
//  UserUploadedLabelCell.swift
//  Runnect-iOS
//
//  Created by 이명진 on 12/11/23.
//

import UIKit

final class UserUploadedLabelCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private lazy var uploadedCourseInfoLabelView = makeInfoView(title: "업로드한 코스")
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: - Layout Helpers

extension UserUploadedLabelCell {
    
    private func setUI() {
        contentView.addSubview(uploadedCourseInfoLabelView)
        uploadedCourseInfoLabelView.backgroundColor = .clear
        
        uploadedCourseInfoLabelView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(62)
        }
    }
    
    private func makeInfoView(title: String) -> UIView {
        let containerView = UIView()
        let icStar = UIImageView().then {
            $0.image = ImageLiterals.icStar
        }

        let label = UILabel().then {
            $0.text = title
            $0.textColor = .g1
            $0.font = .b2
        }

        containerView.addSubviews(icStar, label)

        icStar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().offset(17)
            $0.width.height.equalTo(14)
        }

        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.leading.equalTo(icStar.snp.trailing).offset(8)
        }

        return containerView
    }
}
