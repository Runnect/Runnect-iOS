//
//  UISwitch+.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

extension UISwitch {
    
    func totalSize(width: CGFloat, height: CGFloat) {
        
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
    
    func thumbSize(scaleX: CGFloat, scaleY: CGFloat) {
        if let thumb = self.subviews[0].subviews[1].subviews[2] as? UIImageView {
            thumb.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }
        
        self.subviews[0].subviews[0].layer.cornerRadius = 0
    }
    
    func backgroundCornerRadius(cornerRadius: CGFloat) {
        // deselected
        self.subviews[0].subviews[0].layer.cornerRadius = cornerRadius
        // selected
        self.subviews[0].subviews[1].layer.cornerRadius = cornerRadius
    }
}
