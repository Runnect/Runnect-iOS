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
    
    var backgroundTapAction: (() -> Void)?
    var completeButtonTapAction: ((String) -> Void)?
    
    private let titleNameMaxLength = 20
    private let bottomHeight: CGFloat = 206
    private let backgroundView = UIView().then { $0.backgroundColor = .g1.withAlphaComponent(0.65) }
    
    private var cancelBag = CancelBag()
    private var bottomSheetType: SheetType!
    
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
        self.showBottomSheet()
        if bottomSheetType == .textField {
            self.setGesture()
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
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setGesture() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        backgroundView.addGestureRecognizer(dimmedTap)
        backgroundView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
}

// MARK: - @objc Function

extension CustomBottomSheetVC {
    @objc private func keyboardWillShow(_ sender: Notification) {         // 키보드의 높이만큼 화면을 올려줍니다.
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {         // 키보드의 높이만큼 화면을 내려줍니다.
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y += keyboardHeight
        }
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
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }) // 하나 이상의 클로저 인수를 전달할때, 후행 클로저 구문을 사용하면 안된다는 경고로 일부 수정
        
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: bottomSheetView)
        let velocity = recognizer.velocity(in: bottomSheetView)
        
        switch recognizer.state {
        case .began:
            backgroundView.alpha = 0 // 시작할때 드래그 시작할때 alpha 값 0
        case .changed:
            if velocity.y > 0 {             // 아래로만 Pan 가능한 로직
                backgroundView.alpha = 0
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
                })
            }
        case .ended:
            // translation.y 값이 75보다 작으면(작게 이동 시) 뷰의 위치를 다시 원상복구하겠다. = 즉, 다시 y=0인 지점으로 리셋
            if translation.y < 75 {
                backgroundView.alpha = 0.65
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.transform = .identity
                })
            } else { // translation.y 75 이상이면 해당 화면 dismiss 직접 사용해보니 적절한 값이 75라고 판단
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
