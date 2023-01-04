//
//  CustomBottomSheetVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/04.
//

import UIKit
import Combine

final class CustomBottomSheetVC: UIViewController {
    
    // MARK: - Properties
    
    var completeButtonTapped: Driver<Void> {
        completeButton.publisher(for: .touchUpInside)
            .map { _ in }
            .asDriver()
    }
    
    // MARK: - UI Components
    
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .w1
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let contentsLabel = UILabel().then {
        $0.text = "수고하셨습니다! 러닝을 완료했어요!"
        $0.font = .h5
        $0.textColor = .g2
    }
    
    private let mainImageView = UIImageView().then {
        $0.image = ImageLiterals.imgTelescope
    }
    
    private let completeButton = CustomButton(title: "기록 보러가기")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

extension CustomBottomSheetVC {
    
    /// 바텀 시트의 라벨에 들어갈 텍스트 설정
    @discardableResult
    func setContentsText(text: String) -> Self {
        self.contentsLabel.text = text
        return self
    }
    
    /// 하단 버튼의 텍스트 변경
    @discardableResult
    public func setBottomButtonTitle(_ title: NSAttributedString) -> Self {
        self.completeButton.changeTitle(attributedString: title)
        return self
    }
}

// MARK: - UI & Layout

extension CustomBottomSheetVC {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    private func setLayout() {
        view.addSubviews(bottomSheetView)
        bottomSheetView.addSubviews(contentsLabel, mainImageView, completeButton)
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(330)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(26)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentsLabel.snp.bottom).offset(8)
            make.width.equalTo(223)
            make.height.equalTo(180)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
