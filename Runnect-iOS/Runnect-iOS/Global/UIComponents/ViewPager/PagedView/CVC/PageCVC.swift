//
//  PageCVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/05.
//

import UIKit

import SnapKit

final class PageCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    public var view: UIView? {
        didSet {
            self.setLayout()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI & Layout
    
    private func setLayout() {
        guard let view = view else { return }
        
        self.contentView.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
}
