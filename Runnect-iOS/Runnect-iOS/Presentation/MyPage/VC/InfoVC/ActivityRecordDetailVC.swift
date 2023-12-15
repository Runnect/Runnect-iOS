//
//  ActivityRecordDetailVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/05/10.
//

import UIKit

import SnapKit
import Then
import Moya
import DropDown

final class ActivityRecordDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let recordProvider = Providers.recordProvider
    
    private var recordId: Int?
    
    private let courseTitleMaxLength = 20
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton)
    
    private let moreButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icMore, for: .normal)
        $0.tintColor = .g1
    }
    
    private lazy var middleScorollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    
    private let mapImageView = UIImageView()
    
    private let courseTitleLabel = UILabel().then {
        $0.textColor = .g1
        $0.font = .h4
    }
    
    private lazy var courseTitleTextField = UITextField().then {
        
        $0.attributedPlaceholder = NSAttributedString(
            string: "글 제목",
            attributes: [.font: UIFont.h4, .foregroundColor: UIColor.g3]
        )
        $0.font = .h4
        $0.textColor = .g1
        $0.addLeftPadding(width: 2)
        $0.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
    }
    
    private let recordDateInfoView = CourseDetailInfoView(title: "날짜", description: String())
    
    private let recordDepartureInfoView = CourseDetailInfoView(title: "출발지", description: String())
    
    private lazy var recordInfoStackView = UIStackView(arrangedSubviews: [recordDateInfoView, recordDepartureInfoView]).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.distribution = .fillEqually
    }
    
    private let firstHorizontalDivideLine = UIView()
    
    private let secondHorizontalDivideLine = UIView()
    
    private lazy var recordDistanceLabel = SetInfoLayout.makeGreySmailTitleLabel().then {
        $0.text = "거리"
    }
    
    private lazy var recordRunningTimeLabel = SetInfoLayout.makeGreySmailTitleLabel().then {
        $0.text = "이동 시간"
    }
    
    private lazy var recordAveragePaceLabel = SetInfoLayout.makeGreySmailTitleLabel().then {
        $0.text = "평균 페이스"
    }
    
    private lazy var recordDistanceValueLabel = SetInfoLayout.makeBlackTitleLabel()
    
    private lazy var recordRunningTimeValueLabel = SetInfoLayout.makeBlackTitleLabel()
    
    private lazy var recordAveragePaceValueLabel = SetInfoLayout.makeBlackTitleLabel()
    
    private lazy var recordDistanceStackView = setDetailInfoStakcView(title: recordDistanceLabel, value: recordDistanceValueLabel)
    
    private lazy var recordRunningTimeStackView = setDetailInfoStakcView(title: recordRunningTimeLabel, value: recordRunningTimeValueLabel)
    
    private lazy var recordAveragePaceStackView = setDetailInfoStakcView(title: recordAveragePaceLabel, value: recordAveragePaceValueLabel)
    
    private let firstVerticalDivideLine = UIView()
    private let secondVerticalDivideLine = UIView()
    
    private lazy var recordSubInfoStackView = UIStackView(arrangedSubviews: [recordDistanceStackView, firstVerticalDivideLine, recordRunningTimeStackView, secondVerticalDivideLine, recordAveragePaceStackView]).then {
        $0.axis = .horizontal
        $0.spacing = 3
        $0.distribution = .fill
    }
    
    private lazy var finishEditButton = CustomButton(title: "완료").then {
        $0.isHidden = true
        $0.isEnabled = false
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseTitleTextField.delegate = self
        hideTabBar(wantsToHide: true)
        setNavigationBar()
        setUI()
        setLayout()
        setAddTarget()
        self.view = view
        self.setKeyboardNotification()
        self.setTapGesture()
    }
}

// MARK: - @objc Function

extension ActivityRecordDetailVC {
    @objc func moreButtonDidTap() {
        
        let hideLastCellSeparatorBoxSize = 79
        let items = ["수정하기", "삭제하기"]
        let imageArray: [UIImage] = [ImageLiterals.icModify, ImageLiterals.icRemove]
        
        let menu = DropDown().then {
            $0.anchorView = moreButton
            $0.backgroundColor = .w1
            $0.bottomOffset = CGPoint(x: -136, y: moreButton.bounds.height - 10)
            $0.width = 170
            $0.cellHeight = 40
            $0.cornerRadius = 12
            $0.dismissMode = .onTap
            $0.separatorColor = UIColor(hex: "#EBEBEB")
            $0.dataSource = items
            $0.textFont = .b3
        }
        
        menu.customCellConfiguration = { (index: Index, _: String, cell: DropDownCell) -> Void in
            let lastDividerLineRemove = UIView(frame: CGRect(origin: CGPoint(x: 0, y: hideLastCellSeparatorBoxSize), size: CGSize(width: 170, height: 10)))
            lastDividerLineRemove.backgroundColor = .white
            cell.separatorInset = .zero
            cell.dropDownImage.image = imageArray[index]
            cell.addSubview(lastDividerLineRemove)
        }
        
        dropDownTouchAction(menu: menu)
        
        menu.show()
    }
    
    @objc private func textFieldTextDidChange() {
        guard let text = courseTitleTextField.text else { return }
        
        self.finishEditButton.isEnabled = !text.isEmpty
        
        if text == self.courseTitleLabel.text {
            self.finishEditButton.isEnabled = false
        } else {
            // 수정이 된 상태라면 팝업을 띄워주기
            self.navibar.resetLeftButtonAction({ [weak self] in
                self?.presentToQuitEditAlertVC()
            }, .titleWithLeftButton)
        }
        if text.count > courseTitleMaxLength {
            let index = text.index(text.startIndex, offsetBy: courseTitleMaxLength)
            let newString = text[text.startIndex..<index]
            self.courseTitleTextField.text = String(newString)
        }
    }
    
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
    
    @objc private func finishEditButtonDidTap() {
        editRecordTitle()
        
        // 키보드가 올라와 있다면 내려가는 코드 추가
        view.endEditing(true)
        
        // 수정이 완료되면 팝업 뜨지 않음
        self.navibar.resetLeftButtonAction({ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }, .titleWithLeftButton)
        
        self.navibar.isHidden = false
        
        middleScorollView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    @objc private func presentToQuitEditAlertVC() {
        let quitEditAlertVC = RNAlertVC(description: "러닝 기록 수정을 종료할까요?\n종료 시 수정 내용이 반영되지 않아요.")
        
        quitEditAlertVC.rightButtonTapAction = { [weak self] in
            quitEditAlertVC.dismiss(animated: false)
            self?.navigationController?.popViewController(animated: true)
        }
        
        quitEditAlertVC.modalPresentationStyle = .overFullScreen
        self.present(quitEditAlertVC, animated: false, completion: nil)
    }
}

// MARK: - Methods

extension ActivityRecordDetailVC {
    func setData(model: ActivityRecord) {
        self.recordId = model.id
        self.mapImageView.setImage(with: model.image)
        self.courseTitleLabel.text = model.title
        
        let location = "\(model.departure.region) \(model.departure.city)"
        self.recordDepartureInfoView.setDescriptionText(description: location)
        
        // 날짜 바꾸기
        let recordDate = model.createdAt.prefix(10)
        let resultDate = RNTimeFormatter.changeDateSplit(date: String(recordDate))
        self.recordDateInfoView.setDescriptionText(description: resultDate)
        
        // 이동 시간 바꾸기
        let recordRunningTime = model.time.suffix(7)
        self.recordRunningTimeValueLabel.text = String(recordRunningTime)
        
        // 평균 페이스 바꾸기
        let array = spiltRecordAveragePace(model: model)
        setUpRecordAveragePaceValueLabel(array: array, label: recordAveragePaceValueLabel)
        setUpRecordDistanceValueLabel(model: model, label: recordDistanceValueLabel)
    }
    
    private func setAddTarget() {
        self.moreButton.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        self.finishEditButton.addTarget(self, action: #selector(finishEditButtonDidTap), for: .touchUpInside)
    }
    
    func setDetailInfoStakcView(title: UIView, value: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [title, value])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }
    
    private func spiltRecordAveragePace(model: ActivityRecord) -> [String] {
        let recordAveragePace = model.pace
        let array = recordAveragePace.split(separator: ":").map { String($0) }
        return array
    }
    
    private func setUpRecordAveragePaceValueLabel(array: [String], label: UILabel) {
        let numberArray = array.compactMap { Int($0) }   // 페이스에서 첫번째 인덱스 두번째 값만 가져오기 위해
        let attributedString = NSMutableAttributedString(string: String(numberArray[1]) + "’", attributes: [.font: UIFont.h3, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: String(array[2]) + "”", attributes: [.font: UIFont.h3, .foregroundColor: UIColor.g1]))
        label.attributedText = attributedString
    }
    
    private func setUpRecordDistanceValueLabel(model: ActivityRecord, label: UILabel) {
        let attributedString = NSMutableAttributedString(string: String(model.distance) + " ", attributes: [.font: UIFont.h3, .foregroundColor: UIColor.g1])
        attributedString.append(NSAttributedString(string: "km", attributes: [.font: UIFont.b4, .foregroundColor: UIColor.g2]))
        label.attributedText = attributedString
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
    
    func popUpVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension ActivityRecordDetailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.courseTitleTextField {
            if finishEditButton.isEnabled == true {
                self.finishEditButtonDidTap()
            }
        }
        return true
    }
}

// MARK: - Layout Helpers

extension ActivityRecordDetailVC {
    private func setUI() {
        view.backgroundColor = .w1
        middleScorollView.backgroundColor = .w1
        mapImageView.backgroundColor = .g3
        firstHorizontalDivideLine.backgroundColor = .g5
        secondHorizontalDivideLine.backgroundColor = .g5
        firstVerticalDivideLine.backgroundColor = .g2
        secondVerticalDivideLine.backgroundColor = .g2
    }
    
    private func setNavigationBar() {
        view.addSubview(navibar)
        view.addSubview(moreButton)
        
        navibar.snp.makeConstraints {  make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.centerY.equalTo(navibar)
        }
    }
    
    private func setLayout() {
        view.addSubviews(middleScorollView)
        
        middleScorollView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        middleScorollView.addSubviews(mapImageView, courseTitleLabel, firstHorizontalDivideLine, recordInfoStackView, secondHorizontalDivideLine)
        
        mapImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(middleScorollView.snp.width).multipliedBy(1.13)
        }
        
        courseTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(31)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        firstHorizontalDivideLine.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(2)
            make.top.equalTo(courseTitleLabel.snp.bottom).offset(7)
        }
        
        recordInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(firstHorizontalDivideLine.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        firstVerticalDivideLine.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        secondVerticalDivideLine.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        secondHorizontalDivideLine.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(7)
            make.top.equalTo(recordInfoStackView.snp.bottom).offset(36)
        }
        
        setRecordSubInfoStackView()
    }
    
    private func setRecordSubInfoStackView() {
        middleScorollView.addSubview(recordSubInfoStackView)
        
        let screenWidth = UIScreen.main.bounds.width
        let containerViewWidth = screenWidth - 32
        let stackViewWidth = Int(containerViewWidth - 2) / 3
        
        recordDistanceStackView.snp.makeConstraints { make in
            make.width.equalTo(stackViewWidth)
        }
        
        recordRunningTimeStackView.snp.makeConstraints { make in
            make.width.equalTo(stackViewWidth)
        }
        
        recordAveragePaceStackView.snp.makeConstraints { make in
            make.width.equalTo(stackViewWidth)
        }
        
        recordSubInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(secondHorizontalDivideLine.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func setEditMode() {
        self.navibar.isHidden = false // true
        
        mapImageView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(middleScorollView.snp.width)
        }
        
        self.courseTitleLabel.isHidden = true
        
        self.courseTitleTextField.text = self.courseTitleLabel.text
        
        middleScorollView.addSubview(courseTitleTextField)
        
        courseTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(35)
        }
        
        self.finishEditButton.isHidden = false
        
        firstHorizontalDivideLine.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(2)
            make.top.equalTo(courseTitleTextField.snp.bottom).offset(5)
        }
        
        recordInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(firstHorizontalDivideLine.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        secondHorizontalDivideLine.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(7)
            make.top.equalTo(recordInfoStackView.snp.bottom).offset(24)
        }
        
        recordSubInfoStackView.snp.remakeConstraints { make in
            make.top.equalTo(secondHorizontalDivideLine.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
        }
        
        middleScorollView.addSubview(finishEditButton)
        
        finishEditButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(recordSubInfoStackView.snp.bottom).offset(50)
            make.height.equalTo(44)
        }
    }
}

// MARK: - Network

extension ActivityRecordDetailVC {
    private func deleteRecord() {
        guard let recordId = self.recordId else { return }
        LoadingIndicator.showLoading()
        recordProvider.request(.deleteRecord(recordIdList: [recordId])) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                print("result:", result)
                let status = result.statusCode
                if 200..<300 ~= status {
                    print("삭제 성공")
                    self.navigationController?.popViewController(animated: false)
                    let activityRecordInfoVC = ActivityRecordInfoVC()
                    activityRecordInfoVC.getActivityRecordInfo()
                    activityRecordInfoVC.reloadActivityRecordInfoVC()
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
    
    private func editRecordTitle() {
        guard let recordId = self.recordId else { return }
        guard let editRecordTitle = self.courseTitleTextField.text else { return }
        LoadingIndicator.showLoading()
        recordProvider.request(.updateRecordTitle(recordId: recordId, recordTitle: editRecordTitle)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                print("result:", result)
                let status = result.statusCode
                if 200..<300 ~= status {
                    print("제목 수정 성공")
                    self.showToast(message: "제목 수정이 완료되었어요")
                    self.finishEditButton.isEnabled = false
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
// MARK: - DropDown

extension ActivityRecordDetailVC {
    private func dropDownTouchAction(menu: DropDown) {
        
        DropDown.appearance().textColor = .g1
        DropDown.appearance().selectionBackgroundColor = .w1
        DropDown.appearance().shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        DropDown.appearance().shadowOpacity = 1
        DropDown.appearance().shadowRadius = 10
        
        menu.selectionAction = { [unowned self] (_, item) in
            menu.clearSelection()
            
            switch item {
            case "수정하기":
                self.setEditMode()
            case "삭제하기":
                let deleteAlertVC = RNAlertVC(description: "러닝 기록을 정말로 삭제하시겠어요?").setButtonTitle("취소", "삭제하기")
                deleteAlertVC.modalPresentationStyle = .overFullScreen
                deleteAlertVC.rightButtonTapAction = {
                    deleteAlertVC.dismiss(animated: false)
                    self.deleteRecord()
                }
                self.present(deleteAlertVC, animated: false)
            default:
                self.showToast(message: "없는 명령어 입니다.")
            }
        }
    }
}
