//
//  NicknameEditorVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/05.
//

import UIKit
import SnapKit
import Then

class NicknameEditorVC: UIViewController {

    // MARK: - UI Components
    
    private let editorContentView = UIView().then {
        $0.layer.cornerRadius = 10
    }
    
    private let nickNameEditLabel = UILabel().then {
        $0.text = "닉네임 수정"
        $0.textColor = .g1
        $0.font = .h5
    }
    
    private let nickNameTextField = UITextField().then {
        $0.text = nil
        $0.textColor = .g1
        $0.font = .b6
        $0.attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력하세요"
        )
    }
    
    private let horizontalDivideLine = UIView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.8)
        setUI()
        setLayout()
    }
}

extension NicknameEditorVC {
    
    // MARK: - Layout Helpers
    
    private func setUI() {
        editorContentView.backgroundColor = .w1
        horizontalDivideLine.backgroundColor = .g3
    }
    
    private func setLayout() {
        view.addSubview(editorContentView)
        
        editorContentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(111)
        }
        
        editorContentView.addSubviews(nickNameEditLabel, nickNameTextField, horizontalDivideLine)
        
        nickNameEditLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(24)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameEditLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        horizontalDivideLine.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(nickNameTextField.snp.width)
            make.height.equalTo(0.5)
        }
    }
}
