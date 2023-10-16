//
//  CustomBottomSheetVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/04.
//

import UIKit
import Combine

@frozen
enum SheetType {
    case Image // 가운에 이미지가 있는 시트
    case TextField // 가운데 텍스트필드가 있는 시트
}

final class CustomBottomSheetVC: UIViewController {
    
    // MARK: - Properties
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.7)
    }
    private let titleNameMaxLength = 20
    private var BottomsheetType: SheetType!
    
    var backgroundTapAction: (() -> Void)?
    
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
        $0.text = "코스 이름"
        $0.font = .h5
        $0.textColor = .g1
    }
    
    private let completeButton = CustomButton(title: "완료").setColor(bgColor: .m1, disableColor: .g3).setEnabled(false)
    
    private let mainImageView = UIImageView().then {
        $0.image = ImageLiterals.imgSpaceship
    }
    
    private lazy var bottomSheetTextField = UITextField().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        $0.attributedPlaceholder = NSAttributedString(string: "코스의 이름을 입력해 주세요", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g3, .paragraphStyle: paragraphStyle])
        $0.font = .h5
        $0.textColor = .g1
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.g3.cgColor
        $0.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
    }
    
    // MARK: - initializtion
    init(type: SheetType) {
        super.init(nibName: nil, bundle: nil)
        self.BottomsheetType = type
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout(BottomsheetType)
        self.setDelegate()
        self.setTapGesture()
        self.setAddTarget()
        
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
            make.top.equalToSuperview().inset(30)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentsLabel.snp.bottom).offset(24)
            make.width.equalTo(267)
            make.height.equalTo(158)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
