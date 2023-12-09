//
//  BaseView.swift
//  Runnect-iOS
//
//  Created by Sojin Lee on 2023/09/25.
//

import UIKit
import SnapKit

protocol BaseViewProtocol {
    func setDelegate()
    func setUI()
    func setLayout()
}

class BaseView: UIView, BaseViewProtocol {
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDelegate()
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    func setDelegate() { }
    
    func setUI() { }
    
    func setLayout() { }
}
