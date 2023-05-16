//
//  InfoView.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/05/16.
//

import UIKit

import Then

final class InfoView: UIView {

    // MARK: - initialization
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.register()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
