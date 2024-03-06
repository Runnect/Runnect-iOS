//
//  StatsInfoView.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/05.
//

import UIKit

import SnapKit
import Then

final class StatsInfoView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = .b4
        $0.textColor = .g2
    }
    
    private let statsLabel = UILabel().then {
        $0.font = .h3
        $0.textColor = .g1
    }
    
    private lazy var statsContainerStackView = UIStackView(
        arrangedSubviews: [titleLabel, statsLabel]
    ).then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 9
    }
    
    // MARK: - initialization
    
    init(title: String, stats: String) {
        super.init(frame: .zero)
        self.setUI(title: title, stats: stats)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension StatsInfoView {
    /// statsLabel의 text를 attributedString으로 변경 (기본 값은 Km)
    @discardableResult
    func setAttributedStats(stats: String, unit: String = " Km") -> Self {
        let attributedString = NSMutableAttributedString(
            string: stats,
            attributes: [.font: UIFont.h3, .foregroundColor: UIColor.g1]
        )
        
        attributedString.append(
            NSAttributedString(
                string: unit,
                attributes: [.font: UIFont.b4, .foregroundColor: UIColor.g2]
            )
        )
        
        self.statsLabel.attributedText = attributedString
        return self
    }
    
    @discardableResult
    func setStats(stats: String) -> Self {
        self.statsLabel.text = stats
        return self
    }
}

// MARK: - UI & Layout

extension StatsInfoView {
    private func setUI(title: String, stats: String) {
        self.backgroundColor = .w1
        self.titleLabel.text = title
        self.statsLabel.text = stats
    }
    
    private func setLayout() {
        self.addSubviews(statsContainerStackView)
        
        statsContainerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
