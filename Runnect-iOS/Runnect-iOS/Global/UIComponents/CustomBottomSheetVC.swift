//
//  CustomBottomSheetVC.swift
//  Runnect-iOS
//
//  Created by 이명진 on 11/6/23.
//

import UIKit
import Combine
import CombineCocoa

@frozen
enum SheetType {
    case image // 가운에 이미지가 있는 시트
    case textField // 가운데 텍스트필드가 있는 시트
}

final class CustomBottomSheetVC: UIViewController {
    // MARK: - Properties
    private let backgroundView = UIView().then {
        $0.backgroundColor = .g1.withAlphaComponent(0.65)
    }
    private let titleNameMaxLength = 20
    private var bottomSheetType: SheetType!
    var backgroundTapAction: (() -> Void)?
    var completeButtonTapAction: ((String) -> Void)?
    
    // 바텀 시트 높이
    let bottomHeight: CGFloat = 206
    private var cancelBag = CancelBag()
    
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
    private let dismissIndicatorView = UIView().then {
        $0.backgroundColor = .g4
        $0.layer.cornerRadius = 3
    }
    private let completeButton = CustomButton(title: "완료").setColor(bgColor: .m1, disableColor: .g3).setEnabled(false)
    private let mainImageView = UIImageView().then {
        $0.image = ImageLiterals.imgSpaceship
    }
    private lazy var bottomSheetTextField = UITextField().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "코스의 이름을 입력해 주세요",
            attributes: [.font: UIFont.h5, .foregroundColor: UIColor.g3, .paragraphStyle: paragraphStyle]
        )
        $0.font = .h5
        $0.textColor = .g1
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.g3.cgColor
        $0.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
    }
    
    // MARK: - Initialization
    init(type: SheetType) {
        super.init(nibName: nil, bundle: nil)
        self.bottomSheetType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout(bottomSheetType)
        self.setDelegate()
        self.setBinding()
        if bottomSheetType == .textField {
            showBottomSheet()
            setupGestureRecognizer()
            self.setAddTarget()
        }
    }
    
    // MARK: - Methods
    @discardableResult
    func setContentsText(text: String) -> Self {
        contentsLabel.text = text
        return self
    }
    
    @discardableResult
    func setBottomButtonTitle(_ title: NSAttributedString) -> Self {
        completeButton.changeTitle(attributedString: title)
        return self
    }
    
    @discardableResult
    func setImage(_ image: UIImage) -> Self {
        mainImageView.image = image
        return self
    }
    
    private func setDelegate() {
        bottomSheetTextField.delegate = self
    }
    
    private func setAddTarget() {
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

// MARK: - UI & Layout
extension CustomBottomSheetVC {
    private func setUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setLayout(_ type: SheetType) {
        switch type {
        case .textField:
            setTextFieldLayout()
        case .image:
            setImageLayout()
        }
    }
    
    private func setImageLayout() {
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
    
    private func setTextFieldLayout() {
        view.addSubviews(bottomSheetView)
        
        let topConst = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        
        bottomSheetView.addSubviews(contentsLabel, bottomSheetTextField, dismissIndicatorView, completeButton)
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(topConst)
            make.height.equalTo(bottomHeight)
        }
        
        dismissIndicatorView.snp.makeConstraints { make in
            make.width.equalTo(42)
            make.height.equalTo(4)
            make.top.equalTo(bottomSheetView.snp.top).inset(16)
            make.centerX.equalToSuperview()
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(34)
        }
        
        bottomSheetTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentsLabel.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(bottomSheetTextField.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setBinding() {
        self.completeButton.tapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            guard let text = self.bottomSheetTextField.text else { return }
            self.completeButtonTapAction?(text)
        }.store(in: cancelBag)
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        let topConst = (safeAreaHeight + bottomPadding) - bottomHeight
        
        bottomSheetView.snp.remakeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(topConst)
            make.height.equalTo(bottomHeight)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupGestureRecognizer() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        backgroundView.addGestureRecognizer(dimmedTap)
        backgroundView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
}

// MARK: - @objc Function
extension CustomBottomSheetVC {
    @objc private func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            
            self.view.frame.origin.y -= (keyboardHeight - view.safeAreaInsets.bottom)
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc private func textFieldTextDidChange() {
        guard let text = bottomSheetTextField.text else { return }
        
        completeButton.isEnabled = !text.isEmpty
        changeTextFieldLayerColor(!text.isEmpty)
        
        if text.count > titleNameMaxLength {
            let index = text.index(text.startIndex, offsetBy: titleNameMaxLength)
            let newString = text[text.startIndex..<index]
            self.bottomSheetTextField.text = String(newString)
            self.showToast(message: "20자가 넘어갑니다")
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        let topConst = (safeAreaHeight + bottomPadding)
        
        bottomSheetView.snp.remakeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(topConst)
            make.height.equalTo(bottomHeight)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
             self.view.layoutIfNeeded()
         }, completion: { _ in
             if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
             }
         }) // 하나 이상의 클로저 인수를 전달할때, 후행 클로저 구문을 사용하면 안된다는 경고로 (_) 로 수정
        
    }
    
    // 클래스 내에 저장할 변수 추가
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: bottomSheetView)
        let velocity = recognizer.velocity(in: bottomSheetView)
        
        switch recognizer.state {
        case .began:
            // 제스처 시작 지점의 좌표를 기록
            let startPoint = recognizer.location(in: bottomSheetView)
            print("startPoint = \(startPoint.y)")
        case .changed:
            // 상하로 스와이프 할 때 위로 스와이프가 안되게 해주기 위해서 조건 설정
            if velocity.y > 0 {
                backgroundView.alpha = 0
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
                })
            }
        case .ended:
            print("translation.y = \(translation.y)")
            // 해당 뷰의 y값이 80보다 작으면(작게 이동 시) 뷰의 위치를 다시 원상복구하겠다. = 즉, 다시 y=0인 지점으로 리셋
            if translation.y < 75 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.transform = .identity
                })
                backgroundView.alpha = 0.65
                // 뷰의 값이 75 이상이면 해당 화면 dismiss (MIU 내규에 따름)
            } else {
                self.backgroundView.alpha = 0
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate
extension CustomBottomSheetVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func changeTextFieldLayerColor(_ isEditing: Bool) {
        bottomSheetTextField.layer.borderColor = isEditing ? UIColor.m1.cgColor : UIColor.g3.cgColor
    }
}
