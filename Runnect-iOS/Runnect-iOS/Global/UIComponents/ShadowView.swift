//
//  ShadowView.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/05/30.
//

import UIKit

final class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = true
        self.backgroundColor = .black
        self.dropShadow()
    }
    
    init() {
        super.init(frame: .zero)
        self.isOpaque = true
        self.backgroundColor = .black
        self.dropShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 10 / 2.0
    }
}
