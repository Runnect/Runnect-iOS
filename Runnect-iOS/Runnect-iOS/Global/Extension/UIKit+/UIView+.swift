//
//  UIView+.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

extension UIView {
    
    // UIView 여러 개 인자로 받아서 한 번에 addSubview
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func addSubviewFromNib(view: UIView) {
        guard let view = Bundle.main.loadNibNamed(view.className, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = bounds
        view.clipsToBounds = true
        addSubview(view)
    }
    
    func setGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.init(white: 1, alpha: 0).cgColor, UIColor.init(white: 1, alpha: 1).cgColor]
        gradient.locations = [0.0, 0.8, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.2)
        gradient.endPoint = CGPoint(x: 1.0, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
    
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    /// view에 tap gesture를 연결해주는 함수
    func gesture(_ gestureType: GestureType = .tap()) ->
        GesturePublisher {
            .init(view: self, gestureType: gestureType)
        }
}

class XibView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewFromNib(view: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviewFromNib(view: self)
    }
}
