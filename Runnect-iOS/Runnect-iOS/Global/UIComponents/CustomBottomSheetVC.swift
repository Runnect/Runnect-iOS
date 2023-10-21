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
        $0.backgroundColor = .black.withAlphaComponent(0.65)
    }
    private let titleNameMaxLength = 20
    private var BottomsheetType: SheetType!
    
    var backgroundTapAction: (() -> Void)?
    
    var completeButtonTapped: Driver<Void> {
        completeButton.publisher(for: .touchUpInside)
            .map { _ in }
            .asDriver()
    }
    // 바텀 시트 높이
    let bottomHeight: CGFloat = 241
        
    // bottomSheet가 view의 상단에서 떨어진 거리
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
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
        $0.backgroundColor = .g3
        $0.layer.cornerRadius = 3
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
        if BottomsheetType == .TextField {
            showBottomSheet()
            setupGestureRecognizer()
        }
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
    
    /// 이미지 교체
    @discardableResult
    public func setImage(_ image: UIImage) -> Self {
        self.mainImageView.image = image
        return self
    }
    
    private func setDelegate() {
        bottomSheetTextField.delegate = self
    }
    
    private func dismissBottomSheet() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func setAddTarget() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
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
        case .TextField:
            setTextFieldLayout()
        case .Image:
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
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        bottomSheetView.addSubviews(contentsLabel, bottomSheetTextField, dismissIndicatorView, completeButton)
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(bottomHeight)
        }
        
        NSLayoutConstraint.activate([bottomSheetViewTopConstraint])
        
        dismissIndicatorView.snp.makeConstraints { make in
            make.width.equalTo(102)
            make.height.equalTo(7)
            make.top.equalTo(bottomSheetView.snp.top).inset(12)
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
    
    private func showBottomSheet() {

        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.65
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        backgroundView.addGestureRecognizer(dimmedTap)
        backgroundView.isUserInteractionEnabled = true
        
        // 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
}

// MARK: - @objc Function

extension CustomBottomSheetVC {
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -241
    }
        
    @objc private func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc private func endEditing() { /// return 누를시 키보드 종료
        bottomSheetTextField.resignFirstResponder()
    }
    
    @objc private func handleBackgroundTap() {
        dismissBottomSheet()
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
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // UISwipeGestureRecognizer 연결 함수 부분
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
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
