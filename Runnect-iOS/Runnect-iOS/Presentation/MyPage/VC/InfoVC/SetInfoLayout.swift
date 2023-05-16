//
//  SetInfoLayout.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/05/16.
//

import Foundation
import UIKit

class SetInfoLayout {
    static func makeBlackTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .g1
        label.font = .h3
        return label
    }
    
    static func makeGreyTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .g2
        label.font = .b4
        return label
    }
    
    static func makeBlackSmallTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .g1
        label.font = .h5
        return label
    }
    
    static func makeGreySmailTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .g2
        label.font = .b8
        return label
    }
    
}
