//
//  UploadViewController.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/05.
//

import UIKit

import SnapKit
import Then
import Moya

class CourseUploadVC: UIViewController {
    
    // MARK: - Properties
//    private var runningModel: RunningModel?
    private let PublicCourseProvider = MoyaProvider<PublicCourseRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    private var courseModel: Course?
    private let courseTitleMaxLength = 20
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("코스 업로드")
    private let buttonContainerView = UIView()
    private let uploadButton = CustomButton(title: "업로드하기").setEnabled(false)
    
    private lazy var scrollView = UIScrollView()
    private let mapImageView = UIImageView().then {
        $0.image = UIImage(named: "")
    }
    private let courseTitleTextField = UITextField().then {
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
    
    let activityTextView = UITextView().then {
        $0.font = .b4
        $0.backgroundColor = .m3
        $0.tintColor = .m1
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        setupTextView()
        setAddTarget()
        setKeyboardNotification()
        setTapGesture()
        addKeyboardObserver()
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

extension CourseUploadVC {
    
    func setData(courseModel: Course) {
        self.courseModel = courseModel
        self.mapImageView.setImage(with: courseModel.image)
        
        guard let distance = courseModel.distance else { return }
        self.distanceInfoView.setDescriptionText(description: "\(String(distance))km")
        self.departureInfoView.setDescriptionText(description: "\(courseModel.departure.region) \(courseModel.departure.city)")
    }
    
    private func setAddTarget() {
        self.courseTitleTextField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        self.uploadButton.addTarget(self, action: #selector(uploadButtonDidTap), for: .touchUpInside)
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
}
// MARK: - @objc Function

extension CourseUploadVC {
    @objc private func textFieldTextDidChange() {
        guard let text = courseTitleTextField.text else { return }
        
        if text.count > courseTitleMaxLength {
            let index = text.index(text.startIndex, offsetBy: courseTitleMaxLength)
            let newString = text[text.startIndex..<index]
            self.courseTitleTextField.text = String(newString)
        }
        
        if !text.isEmpty && activityTextView.text != self.placeholder {
            uploadButton.setEnabled(true)
        } else {
            uploadButton.setEnabled(false)
        }
    }
    
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
    
    @objc func uploadButtonDidTap() {
        self.uploadCourse()
    }
}

// MARK: - naviVar Layout

extension CourseUploadVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        navibar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    // MARK: - setUI
    
    private func setUI() {
        view.backgroundColor = .w1
        scrollView.backgroundColor = .clear
        buttonContainerView.backgroundColor = .w1
        mapImageView.backgroundColor = .systemGray4
        
    }
    
    // MARK: - Layout Helpers
    
    private func setLayout() {
        view.addSubview(buttonContainerView)
        view.bringSubviewToFront(uploadButton)
        buttonContainerView.addSubview(uploadButton)
        
        buttonContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(86)
            make.bottom.equalToSuperview()
        }
        uploadButton.snp.makeConstraints { make in
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
            $0.bottom.equalTo(uploadButton.snp.top).inset(-25)
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
    
    func setupTextView() {
        activityTextView.delegate = self
        activityTextView.text = placeholder
        activityTextView.textColor = .g3
    }
}

extension CourseUploadVC: UITextViewDelegate {
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
        if !courseTitleTextField.isEmpty && !activityTextView.text.isEmpty {
            uploadButton.setEnabled(true)
        } else {
            uploadButton.setEnabled(false)
        }
        
        if activityTextView.text.count > 150 {
            activityTextView.deleteBackward()
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

extension CourseUploadVC {
    private func uploadCourse() {
        guard let courseId = courseModel?.id else { return }
        guard let titletext = courseTitleTextField.text else { return }
        guard let descriptiontext = activityTextView.text else { return }
        let requsetDto = CourseUploadingRequestDto(courseId: courseId, title: titletext, description: descriptiontext)
        
        LoadingIndicator.showLoading()
        PublicCourseProvider.request(.courseUploadingData(param: requsetDto)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    self.navigationController?.popToRootViewController(animated: true)
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
