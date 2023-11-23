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
    
    private let mainLabel: UILabel = {
        let label = UILabel().then {
            $0.text = "이런 코스 어때요?"
            $0.font = UIFont.h3
            $0.textColor = UIColor.g1
        }
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel().then {
            $0.text = "나에게 최적화된 코스를 찾아보세요"
            $0.font = UIFont.b6
            $0.textColor = UIColor.g2
        }
        return label
    }()
    
    private lazy var dateSortButton = createSortButton(title: "최신순", ordering: "date")
    private lazy var scrapSortButton = createSortButton(title: "스크랩순", ordering: "scrap")
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
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
                $0.setTitleColor(.m1, for: .normal)
                $0.setTitleColor(.g2, for: .disabled)
            }
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
            button.tapPublisher
                .sink { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didTapSortButton(ordering: ordering)
                }
                .store(in: &cancellables)
            return button
        }
    
    @objc private func sortButtonTapped(sender: UIButton) {
        guard let ordering = sender == dateSortButton ? "date" : "scrap" else {
            return
        }
        delegate?.didTapSortButton(ordering: ordering)
    }
}

// MARK: - Layout

extension TitleCollectionViewCell {
    func layout() {
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
