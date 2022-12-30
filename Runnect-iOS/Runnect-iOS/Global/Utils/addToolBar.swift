//
//  addToolBar.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

extension UIViewController {
    
    func addToolbar(textfields: [UITextField]) {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnDoneBar = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.dismissKeyBoard))
        toolBarKeyboard.items = [flexSpace, btnDoneBar]
        textfields.forEach {
            $0.inputAccessoryView = toolBarKeyboard
        }
    }
    
    func addToolBar(textView: UITextView) {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnDoneBar = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.dismissKeyBoard))
        toolBarKeyboard.items = [flexSpace, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.red
        textView.inputAccessoryView = toolBarKeyboard
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
    }
}
