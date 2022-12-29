//
//  UIStackView+.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

extension UIStackView {
     func addArrangedSubviews(_ views: UIView...) {
         for view in views {
             self.addArrangedSubview(view)
         }
     }
}
