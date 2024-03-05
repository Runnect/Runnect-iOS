//
//  CourseListCVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import UIKit

import SnapKit
import Then

protocol CourseListCVCDelegate: AnyObject {
    func likeButtonTapped(wantsTolike: Bool, index: Int)
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
    
    weak var delegate: CourseListCVCDelegate?
    
    private var indexPath: Int?
    
    // MARK: - UI Components
    
    private let courseImageView = UIImageView().then {
        $0.backgroundColor = .g3
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let imageCoverView = UIImageView().then {
        $0.backgroundColor = .m1.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 5
        $0.isHidden = true
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
        arrangedSubviews: [
            titleLabel,
            locationLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let likeButton = UIButton(type: .custom).then {
        $0.setImage(ImageLiterals.icHeartFill, for: .selected)
        $0.setImage(ImageLiterals.icHeart, for: .normal)
        $0.backgroundColor = .w1
    }
    
    private let selectIndicatorButton = UIButton(type: .custom).then {
        $0.setImage(ImageLiterals.icCheckFill, for: .selected)
        $0.setImage(ImageLiterals.icCheck, for: .normal)
        $0.isSelected = false
        $0.isHidden = true
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
    
    func setData(imageURL: String, title: String, location: String?, didLike: Bool?, indexPath: Int? = nil, isEditMode: Bool = false) {
        self.courseImageView.setImage(with: imageURL)
        self.titleLabel.text = title
        self.indexPath = indexPath
        if let location = location {
            self.locationLabel.text = location
        }
        if let didLike = didLike {
            self.likeButton.isSelected = didLike
        }
        self.selectIndicatorButton.isHidden = !isEditMode
    }
    
    func selectCell(didSelect: Bool) {
        if didSelect {
            courseImageView.layer.borderColor = UIColor.m1.cgColor
            courseImageView.layer.borderWidth = 2
            imageCoverView.isHidden = false
            selectIndicatorButton.isSelected = true
        } else {
            courseImageView.layer.borderColor = UIColor.clear.cgColor
            imageCoverView.isHidden = true
            selectIndicatorButton.isSelected = false
            
        }
    }
}

// MARK: - @objc Function

extension CourseListCVC {
    @objc func likeButtonDidTap(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        if UserManager.shared.userType != .visitor {
            sender.isSelected.toggle()
        }
        delegate?.likeButtonTapped(wantsTolike: (sender.isSelected == true), index: indexPath)
    }
}

// MARK: - UI & Layout

extension CourseListCVC {
    private func setUI() {
        self.contentView.backgroundColor = .w1
        self.courseImageView.layer.borderColor = UIColor(hex: "EAEAEA").cgColor /// 모든 코스 테두리 1px 요구사항
        self.courseImageView.layer.borderWidth = 1.0
    }
    
    private func setLayout() {
        self.contentView.addSubviews(courseImageView, imageCoverView, labelStackView, likeButton, selectIndicatorButton)
        
        courseImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            let imageHeight = contentView.frame.width * (124/174)
            make.height.equalTo(imageHeight)
        }
        
        imageCoverView.snp.makeConstraints { make in
            make.edges.equalTo(courseImageView)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(courseImageView.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
        
        selectIndicatorButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(20)
            make.height.equalTo(20)
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
