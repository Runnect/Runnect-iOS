//
//  CourseEditVC.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/05/06.
//

import UIKit

import SnapKit
import Then
import Moya

class CourseEditVC: UIViewController {
    
    // MARK: - Properties
    
    private let PublicCourseProvider = Providers.publicCourseProvider

    private let courseTitleMaxLength = 20
    private let activityTextMaxLength = 150
    var publicCourseId: Int?
    
    var currentTitle: String?
    var currentDescription: String?
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("")
    private let buttonContainerView = UIView()
    private let editButton = CustomButton(title: "완료").setEnabled(false)
    
    private lazy var scrollView = UIScrollView()
    private let mapImageView = UIImageView()
    private lazy var courseTitleTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "글 제목",
            attributes: [.font: UIFont.h4, .foregroundColor: UIColor.g3]
        )
        $0.font = .h4
        $0.textColor = .g1
        $0.addLeftPadding(width: 2)
    }
    private let dividerView = UIView().then {
        $0.backgroundColor = .g5
    }
    private let distanceInfoView = CourseDetailInfoView(title: "거리", description: "0.0km")
    private let departureInfoView = CourseDetailInfoView(title: "출발지", description: "")
    private let placeholder = "코스에 대한 소개를 적어주세요.(난이도/풍경/지형)"
    
    private let activityTextView = UITextView().then {
        $0.font = .b3
        $0.backgroundColor = .m3
        $0.tintColor = .m1
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setNavigationBar()
        setUI()
        setLayout()
        setAddTarget()
        setKeyboardNotification()
        setTapGesture()
        addKeyboardObserver()
        textViewDidChange(self.activityTextView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Methods

extension CourseEditVC {
    private func setDelegate() {
        self.courseTitleTextField.delegate = self
        self.activityTextView.delegate = self
    }
    
    private func setAddTarget() {
        self.courseTitleTextField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        self.editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
    
    private func setCurrentInfo() {
        self.courseTitleTextField.text = self.currentTitle
        self.activityTextView.text = self.currentDescription
    }
    
    // data 그대로 load하기
    func loadData(model: UploadedCourseDetailResponseDto) {
        mapImageView.setImage(with: model.publicCourse.image)
        self.currentTitle = model.publicCourse.title
        distanceInfoView.setDescriptionText(description: "\(model.publicCourse.distance ?? 0.0)km")
        let departure = "\(model.publicCourse.departure.region) \(model.publicCourse.departure.city)"
        departureInfoView.setDescriptionText(description: departure)
        
        self.currentDescription = model.publicCourse.description
        setCurrentInfo()
    }
    
    // 키보드가 올라오면 scrollView 위치 조정
    private func setKeyboardNotification() {
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
    
    // 화면 터치 시 키보드 내리기
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func addKeyboardObserver() {
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
    
    private func textDidChanged(_ textFieldtext: String, _ textViewtext: String) {
        // 둘 중 하나라도 비어있으면 버튼 비활성화
        if textFieldtext.isEmpty || textViewtext.isEmpty {
            editButton.isEnabled = false
            return
        }
        
        // 둘 중 하나라도 수정되어있을 경우
        if textFieldtext != self.currentTitle || textViewtext != self.currentDescription {
            self.editButton.isEnabled = true
            self.navibar.resetLeftButtonAction({ [weak self] in
                self?.presentToQuitEditAlertVC()
            }, .titleWithLeftButton)
        } else {
            self.editButton.isEnabled = false
        }
    }
}
// MARK: - @objc Function

extension CourseEditVC {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        if activityTextView.isFirstResponder {
            let contentViewHeight = scrollView.contentSize.height
            let textViewHeight = activityTextView.frame.height
            let textViewOffsetY = contentViewHeight - (contentInset.bottom + textViewHeight)
            let position = CGPoint(x: 0, y: textViewOffsetY + 100)
            scrollView.setContentOffset(position, animated: true)
            return
        }
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func editButtonDidTap() {
        editCourse()
        
        // 수정이 완료되면 팝업 뜨지 않음
        self.navibar.resetLeftButtonAction({ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }, .titleWithLeftButton)
    }

    @objc func presentToQuitEditAlertVC() {
        let quitEditAlertVC = RNAlertVC(description: "게시글 수정을 종료할까요?\n종료 시 수정 내용이 반영되지 않아요.")
        
        quitEditAlertVC.rightButtonTapAction = { [weak self] in
            quitEditAlertVC.dismiss(animated: false)
            self?.navigationController?.popViewController(animated: true)
        }
        
        quitEditAlertVC.modalPresentationStyle = .overFullScreen
        self.present(quitEditAlertVC, animated: false, completion: nil)
    }
}

// MARK: - Layout Helpers

extension CourseEditVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        scrollView.backgroundColor = .clear
        buttonContainerView.backgroundColor = .w1
        mapImageView.backgroundColor = .systemGray4
    }
    
    private func setLayout() {
        view.addSubview(buttonContainerView)
        view.bringSubviewToFront(editButton)
        buttonContainerView.addSubview(editButton)
        
        buttonContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(86)
            make.bottom.equalToSuperview()
        }
        editButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(34)
        }
        
        setScrollViewLayout()
    }
    
    private func setScrollViewLayout() {
        view.addSubview(scrollView)
        [mapImageView,
         courseTitleTextField,
         dividerView,
         distanceInfoView,
         departureInfoView,
         activityTextView].forEach {
            scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(editButton.snp.top).inset(-25)
        }
        
        mapImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(mapImageView.snp.width).multipliedBy(0.75)
        }
        
        courseTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(28)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(35)
        }
                
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(courseTitleTextField.snp.bottom).offset(0)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(2)
        }
        
        distanceInfoView.snp.makeConstraints { make in
            make.top.equalTo(courseTitleTextField.snp.bottom).offset(22)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(16)
        }
        departureInfoView.snp.makeConstraints { make in
            make.top.equalTo(distanceInfoView.snp.bottom).offset(6)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(16)
        }
        activityTextView.snp.makeConstraints { make in
            make.top.equalTo(departureInfoView.snp.bottom).offset(34)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(187)
        }
    }
}

// MARK: - UITextFieldDelegate

extension CourseEditVC: UITextFieldDelegate {
    @objc private func textFieldTextDidChange() {
        guard let text = courseTitleTextField.text else { return }
        
        textDidChanged(text, self.activityTextView.text)
        
        if text.count > courseTitleMaxLength {
            let index = text.index(text.startIndex, offsetBy: courseTitleMaxLength)
            let newString = text[text.startIndex..<index]
            self.courseTitleTextField.text = String(newString)
        }
    }
}

// MARK: - UITextViewDelegate

extension CourseEditVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            activityTextView.textColor = .g3
            activityTextView.text = placeholder
            
        } else if textView.text == placeholder {
            activityTextView.textColor = .g1
            activityTextView.text = nil
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = activityTextView.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        // 커서 위치 저장
        let selectedRange = textView.selectedRange
        
        let attributedString = NSMutableAttributedString(string: textView.text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

        textView.attributedText = attributedString
        textView.font = .b3
        textView.textColor = .g1
        
        // 커서 위치 다시 설정
        textView.selectedRange = selectedRange

        guard let courseTitleTextFieldText = self.courseTitleTextField.text else { return }
        textDidChanged(courseTitleTextFieldText, text)
        
        if text.count > self.activityTextMaxLength {
            self.activityTextView.deleteBackward()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == placeholder {
            activityTextView.textColor = .g3
            activityTextView.text = placeholder
        }
    }
}

// MARK: - Network

extension CourseEditVC {
    private func editCourse() {
        guard let titletext = courseTitleTextField.text else { return }
        guard let descriptiontext = activityTextView.text else { return }
        guard let publicCourseId = publicCourseId else { return }
        let requsetDto = EditCourseRequestDto(title: titletext, description: descriptiontext)
        
        LoadingIndicator.showLoading()
        PublicCourseProvider.request(.updatePublicCourse(publicCourseId: publicCourseId, editCourseRequestDto: requsetDto)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    self.navigationController?.popViewController(animated: true) /// 추가한 부분 수정 필요
                    showToast(message: "게시글 수정이 완료되었어요")
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
}
