//
//  Toast.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/31.
//

import UIKit

import SnapKit

public extension UIViewController {
    func showToast(message: String) {
        Toast.show(message: message, view: self.view, safeAreaBottomInset: self.safeAreaBottomInset())
    }
    
    func showNetworkFailureToast() {
        showToast(message: "네트워크 통신 실패")
    }
}

public class Toast {
    public static func show(message: String, view: UIView, safeAreaBottomInset: CGFloat = 0) {
        
        let toastContainer = UIView()
        let toastLabel = UILabel()
        
        toastContainer.backgroundColor = UIColor.g2.withAlphaComponent(0.8)
        toastContainer.alpha = 1.0
        toastContainer.layer.cornerRadius = 20
        toastContainer.clipsToBounds = true
        toastContainer.isUserInteractionEnabled = false
        
        toastLabel.textColor = .m4
        toastLabel.font = .b4
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.sizeToFit()
        
        toastContainer.addSubview(toastLabel)
        view.addSubview(toastContainer)
        
        let toastConatinerWidth = toastLabel.intrinsicContentSize.width + 40.0
        
        toastContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(safeAreaBottomInset+160)
            $0.width.equalTo(toastConatinerWidth)
            $0.height.equalTo(44)
        }
        
        toastLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
