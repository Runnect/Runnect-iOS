//
//  CourseListCVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import UIKit

protocol CourseListCVCDeleagte: AnyObject {
    func likeButtonTapped(wantsTolike: Bool)
}

@frozen
enum CourseListCVCType {
    case title
    case titleWithLocation
    case all
    
    static func getCellHeight(type: CourseListCVCType, cellWidth: CGFloat) -> CGFloat {
        let imageHeight = cellWidth * (124/174)
        switch type {
        case .title:
            return imageHeight + 24
        case .titleWithLocation, .all:
            return imageHeight + 40
        }
    }
}

final class CourseListCVC: UICollectionViewCell {

    // MARK: - Properties
    
    weak var delegate: CourseListCVCDeleagte?
    
    // MARK: - UI Components
    
    private let courseImageView = UIImageView().then {
        $0.backgroundColor = .g3
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.font = .b4
        $0.textColor = .g1
    }
    
    private let locationLabel = UILabel().then {
        $0.text = "위치"
        $0.font = .b6
        $0.textColor = .g2
    }
    
    private lazy var labelStackView = UIStackView(
        arrangedSubviews: [titleLabel, locationLabel]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let likeButton = UIButton(type: .custom).then {
        $0.setImage(ImageLiterals.icHeartFill, for: .selected)
        $0.setImage(ImageLiterals.icHeart, for: .normal)
        $0.isSelected = true
        $0.backgroundColor = .w1
    }
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
        self.setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CourseListCVC {
    private func setAddTarget() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
    }
    
    func setData(imageURL: String, title: String, location: String?, didLike: Bool?) {
        self.courseImageView.setImage(with: imageURL)
        self.titleLabel.text = title
        
        if let location = location {
            self.locationLabel.text = location
        }
        
        if let didLike = didLike {
            self.likeButton.isSelected = didLike
        }
    }
    
    func selectCell(didSelect: Bool) {
        if didSelect {
            courseImageView.layer.borderColor = UIColor.m1.cgColor
            courseImageView.layer.borderWidth = 2
        } else {
            courseImageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}

// MARK: - @objc Function

extension CourseListCVC {
    @objc func likeButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.likeButtonTapped(wantsTolike: (sender.isSelected == true))
    }
}

// MARK: - UI & Layout

extension CourseListCVC {
    private func setUI() {
        self.contentView.backgroundColor = .w1
    }
    
    private func setLayout() {
        self.contentView.addSubviews(courseImageView, labelStackView, likeButton)
    
        courseImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            let imageHeight = contentView.frame.width * (124/174)
            make.height.equalTo(imageHeight)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(courseImageView.snp.bottom).offset(7)
            make.trailing.equalToSuperview()
            make.width.equalTo(14)
            make.height.equalTo(12)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(courseImageView.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.width.equalTo(courseImageView.snp.width).multipliedBy(0.7)
        }
    }
    
    func setCellType(type: CourseListCVCType) {
        switch type {
        case .title:
            self.locationLabel.isHidden = true
            self.likeButton.isHidden = true
        case .titleWithLocation:
            self.locationLabel.isHidden = false
            self.likeButton.isHidden = true
        case .all:
            self.locationLabel.isHidden = false
            self.likeButton.isHidden = false
        }
    }
}
