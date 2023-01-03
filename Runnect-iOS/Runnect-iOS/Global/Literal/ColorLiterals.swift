//
//  ColorLiterals.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

extension UIColor {
    static var w1: UIColor {
        return UIColor(hex: "#ffffff")
    }
    
    static var g1: UIColor {
        return UIColor(hex: "#171717")
    }
    
    static var g2: UIColor {
        return UIColor(hex: "#8B8B8B")
    }
    
    static var g3: UIColor {
        return UIColor(hex: "#C1C1C1")
    }
    
    static var g4: UIColor {
        return UIColor(hex: "#ECECEC")
    }
    
    static var g5: UIColor {
        return UIColor(hex: "#F3F3F3")
    }
    
    static var m1: UIColor {
        return UIColor(hex: "#593EEC")
    }
    
    static var m2: UIColor {
        return UIColor(hex: "#7E71FF")
    }
    
    static var m3: UIColor {
        return UIColor(hex: "#F2F3FF")
    }
    
    static var m4: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var m5: UIColor {
        return UIColor(hex: "#D5D4FF")
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
