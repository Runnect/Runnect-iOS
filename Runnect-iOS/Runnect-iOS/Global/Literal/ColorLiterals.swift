//
//  ColorLiterals.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

extension UIColor {
    static var korailPrimaryColor: UIColor {
        return UIColor(hex: "#2C80FF")
    }
    
    static var korailSubColor: UIColor {
        return UIColor(hex: "#FF842C")
    }
    
    static var korailGray1: UIColor {
        return UIColor(hex: "#F2F6FF")
    }
    
    static var korailGray2: UIColor {
        return UIColor(hex: "#8A8A8A")
    }
    
    static var korailBlack: UIColor {
        return UIColor(hex: "#000000")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
