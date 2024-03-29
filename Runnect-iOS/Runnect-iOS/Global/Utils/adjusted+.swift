//
//  adjusted+.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

/**
 - Description:
 스크린 너비 390를 기준으로 디자인이 나왔을 때 현재 기기의 스크린 사이즈에 비례하는 수치를 Return한다.
 
 - Note:
 기기별 대응에 사용하면 된다.
 ex) (size: 20.adjusted)
 */

extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 390
        return self * ratio
    }
    
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 844
        return self * ratio
    }
}

extension Double {
    var adjusted: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 390)
        return self * ratio
    }
    
    var adjustedH: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height / 844)
        return self * ratio
    }
}
