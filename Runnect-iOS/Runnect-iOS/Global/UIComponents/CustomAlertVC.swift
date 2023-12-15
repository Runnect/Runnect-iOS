//
//  CustomAlertVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/04.
//

import UIKit
import Combine

final class CustomAlertVC: UIViewController {
    
    // MARK: - Properties
    
    var leftButtonTapped: Driver<Void> {
        leftButton.publisher(for: .touchUpInside)
            .map { _ in }
            .asDriver()
    }
    
    var rightButtonTapped: Driver<Void> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in }
            .asDriver()
    }
    
    var leftButtonTapAction: (() -> Void)?
    var rightButtonTapAction: (() -> Void)?
    
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let alertView = UIView()
    private let alertImageView = UIImageView().then {
        $0.image = ImageLiterals.imgPaper
    }
    private let contentsLabel: UILabel = UILabel().then {
        $0.text = "코스를 만들었어요!\n지정한 코스는 보관함에서 볼 수 있어요."
        $0.font = .b4
        $0.textColor = .g2
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let leftButton = CustomButton(title: "보관함 가기")
        .setColor(bgColor: .m3, disableColor: .m3, textColor: .m1)
    
    private let rightButton = CustomButton(title: "바로 달리기")
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [leftButton, rightButton])
        .then {
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViews()
    }
}

// MARK: - Methods

extension CustomAlertVC {
    /// 이미지 변경
    public func setImage(_ image: UIImage, size: CGSize) {
        self.alertImageView.image = image
        self.alertImageView.snp.updateConstraints { make in
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
    }
    
    /// conentsLabel의 텍스트 변경
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        self.contentsLabel.text = title
        return self
    }
    
    /// 좌측 버튼의 텍스트 변경
    @discardableResult
    public func setLeftButtonTitle(_ title: NSAttributedString) -> Self {
        self.leftButton.changeTitle(attributedString: title)
        return self
    }
    
    /// 우측 버튼의 텍스트 변경
    @discardableResult
    public func setRightButtonTitle(_ title: NSAttributedString) -> Self {
        self.rightButton.changeTitle(attributedString: title)
        return self
    }
    
    private func bindViews() {
        self.leftButtonTapped.sink { _ in
            self.leftButtonTapAction?()
        }.store(in: cancelBag)
        
        self.rightButtonTapped.sink { _ in
            self.rightButtonTapAction?()
        }.store(in: cancelBag)
    }
}

// MARK: - UI & Layout

extension CustomAlertVC {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        alertView.backgroundColor = .w1
        alertView.layer.cornerRadius = 20
    }
    
    private func setLayout() {
        view.addSubviews(alertView)
        
        alertView.addSubviews(alertImageView, contentsLabel, buttonStackView)
        
        alertView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(31)
        }
        
        alertImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(38)
            make.centerX.equalToSuperview()
            make.width.equalTo(189)
            make.height.equalTo(169)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(alertImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(25)
        }
    }
}
