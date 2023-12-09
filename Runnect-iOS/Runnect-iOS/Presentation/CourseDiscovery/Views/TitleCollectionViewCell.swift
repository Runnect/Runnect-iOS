//
//  TitleCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by 이명진 on 2023/11/21.
//

import UIKit
import Combine

protocol TitleCollectionViewCellDelegate: AnyObject {
    func didTapSortButton(ordering: String)
}

class TitleCollectionViewCell: UICollectionViewCell {
    
    private var cancellables: Set<AnyCancellable> = []
    weak var delegate: TitleCollectionViewCellDelegate?
    
    // MARK: - UI Components
    
    private lazy var titleStackView = UIStackView(arrangedSubviews: [mainLabel, subLabel]).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .leading
    }
    
    private let divideView = UIView().then {
        $0.backgroundColor = .g4
    }
    
    private let mainLabel: UILabel = UILabel().then {
        $0.text = "이런 코스 어때요?"
        $0.font = UIFont.h3
        $0.textColor = UIColor.g1
    }
    
    private let subLabel: UILabel = UILabel().then {
        $0.text = "나에게 최적화된 코스를 찾아보세요"
        $0.font = UIFont.b6
        $0.textColor = UIColor.g2
    }
    
    private lazy var dateSortButton: UIButton = createSortButton(title: "최신순", ordering: "date").then {
        $0.isSelected = true
        $0.titleLabel?.font = .h5
    }

    private lazy var scrapSortButton: UIButton = createSortButton(title: "스크랩순", ordering: "scrap")
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Method

extension TitleCollectionViewCell {
    private func createSortButton(title: String, ordering: String) -> UIButton {
        let button = UIButton(type: .custom).then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .b3
            $0.setTitleColor(.g2, for: .normal)
        }
        
        button.setTitleColor(.m1, for: .selected)
        
        button.tapPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.dateSortButton.isSelected = (button == self.dateSortButton)
                self.scrapSortButton.isSelected = (button == self.scrapSortButton)
                
                self.dateSortButton.setTitleColor(self.dateSortButton.isSelected ? .m1 : .g2, for: .normal)
                self.scrapSortButton.setTitleColor(self.scrapSortButton.isSelected ? .m1 : .g2, for: .normal)
                
                self.dateSortButton.titleLabel?.font = self.dateSortButton.isSelected ? .h5 : .b3
                self.scrapSortButton.titleLabel?.font = self.scrapSortButton.isSelected ? .h5 : .b3
                
                if button.isSelected {
                    self.delegate?.didTapSortButton(ordering: ordering)
                }
            }
            .store(in: &cancellables)
        
        return button
    }
}
// MARK: - Layout

extension TitleCollectionViewCell {
    private func setLayout() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(titleStackView, divideView, dateSortButton, scrapSortButton)
        
        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        divideView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.top).offset(-34)
            $0.centerX.equalToSuperview().inset(16)
            $0.width.equalTo(358)
            $0.height.equalTo(1)
        }
        
        dateSortButton.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(54)
            $0.leading.equalTo(titleStackView.snp.trailing).offset(57)
        }
        
        scrapSortButton.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(54)
            $0.leading.equalTo(dateSortButton.snp.trailing).offset(8)
        }
    }
}
