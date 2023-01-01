//
//  FontLiterals.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

extension UIFont {
    @nonobjc class var h1: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 24)
    }
    
    @nonobjc class var h2: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 22)
    }
    
    @nonobjc class var h2_2: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 22)
    }
    
    @nonobjc class var h3: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 20)
    }
    
    @nonobjc class var h4: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 18)
    }
    
    @nonobjc class var h5: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 15)
    }
    
    @nonobjc class var b1: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 17)
    }
    
    @nonobjc class var b2: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 15)
    }
    
    @nonobjc class var b3: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 15)
    }
    
    @nonobjc class var b4: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 14)
    }
    
    @nonobjc class var b5: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 13)
    }
    
    @nonobjc class var b6: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 13)
    }
    
    @nonobjc class var b7: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 12)
    }
    
    @nonobjc class var b8: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 12)
    }
    
    @nonobjc class var b9: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 10)
    }
}

enum FontName: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
