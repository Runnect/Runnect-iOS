//
//  UITabBar+.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

extension UITabBar {
    
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
