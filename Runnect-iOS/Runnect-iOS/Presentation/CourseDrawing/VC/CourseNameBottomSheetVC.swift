//
//  CourseNameBottomSheetVC.swift
//  Runnect-iOS
//
//  Created by Sojin Lee on 2023/10/10.
//

import UIKit

import Combine
import SnapKit
import Then

final class CourseNameBottomSheetVC: UIViewController, UITextFieldDelegate {
    // MARK: - UI
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.65)
    }
    
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .g4
        $0.roundCorners(cornerRadius: 3, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner])
    }
    
    private let courseNameLabel = UILabel().then {
        $0.text = "코스 이름"
        $0.font = .h5
    }
    
    private let textfield = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.placeholder = "코스의 이름을 입력해 주세요"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.g3.cgColor
        $0.textAlignment = .center
        $0.font = .b2
    }
    
    private let completeButton = CustomButton(title: "완료").setColor(bgColor: .m1, disableColor: .g3).then {
        $0.isEnabled = false
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.setDelegate()
        self.setAddTarget()
        self.addKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showBottomSheet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        disappearBottomSheet()
    }
}

extension CourseNameBottomSheetVC {
    private func setLayout() {
        bottomSheetView.addSubviews(lineView,courseNameLabel, textfield, completeButton)
        self.view.addSubviews(backgroundView, bottomSheetView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        lineView.snp.makeConstraints {
            $0.width.equalTo(41.5)
            $0.height.equalTo(4)
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
        }
        
        courseNameLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        textfield.snp.makeConstraints {
            $0.width.equalTo(358)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(courseNameLabel.snp.bottom).offset(18)
        }
        
        completeButton.snp.makeConstraints {
            $0.width.equalTo(358)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textfield.snp.bottom).offset(10)
        }
    }
    
    // MARK: - 바텀시트 열릴 때
    private func showBottomSheet() {
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(204)
        }
        
        UIView.animate(
            withDuration: 0.5,
            animations: self.view.layoutIfNeeded
        )
    }
    
    // MARK: - 바텀시트 닫힐 때
    private func disappearBottomSheet() {
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        UIView.animate(
            withDuration: 0.5,
            animations: self.view.layoutIfNeeded
        )
    }
    
    private func setAddTarget() {
        self.textfield.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        self.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    
    private func setDelegate() {
        textfield.delegate = self
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )

        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
      }
}

// MARK: - @obj function
extension CourseNameBottomSheetVC {
    @objc private func completeButtonDidTap() {
        print("버튼 눌렸음")
    }
    
    @objc private func textFieldTextDidChange() {
        guard let text = textfield.text else { return }
        
        completeButton.isEnabled = !text.isEmpty
        textfield.layer.borderColor = !text.isEmpty ? UIColor.m1.cgColor : UIColor.g3.cgColor
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            bottomSheetView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(204)
                $0.bottom.equalToSuperview().inset(keyboardHeight)
            }
            
            UIView.animate(
                withDuration: 0.3,
                animations: self.view.layoutIfNeeded
            )
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(204)
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: self.view.layoutIfNeeded
        )
    }
}
