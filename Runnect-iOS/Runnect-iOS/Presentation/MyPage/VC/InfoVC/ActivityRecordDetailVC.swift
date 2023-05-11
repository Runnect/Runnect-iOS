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

final class ActivityRecordDetailVC: UIViewController {

    // MARK: - Properties

    private let recordProvider = Providers.recordProvider
        
    private var recordId: Int?
        
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
        $0.text = "제목"
        $0.textColor = .g1
        $0.font = .h4
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
    
    private lazy var recordDistanceLabel = setGreyTitle().then {
        $0.text = "거리"
    }

    private lazy var recordRunningTimeLabel = setGreyTitle().then {
        $0.text = "이동 시간"
    }
    
    private lazy var recordAveragePaceLabel = setGreyTitle().then {
        $0.text = "평균 페이스"
    }

    private lazy var recordDistanceValueLabel = setBlackTitle()
    
    private lazy var recordRunningTimeValueLabel = setBlackTitle()
    
    private lazy var recordAveragePaceValueLabel = setBlackTitle()
    
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideTabBar(wantsToHide: true)
        setNavigationBar()
        setUI()
        setLayout()
        setAddTarget()
    }
}

// MARK: - @objc Function

extension ActivityRecordDetailVC {
    @objc func moreButtonDidTap() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정하기", style: .default, handler: {(_: UIAlertAction!) in
            //self.navigationController?.pushViewController(courseEditVC, animated: false)
        })
        let deleteVC = RNAlertVC(description: "러닝 기록을 정말로 삭제하시겠어요?").setButtonTitle("취소", "삭제하기")
        deleteVC.modalPresentationStyle = .overFullScreen
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: {(_: UIAlertAction!) in
            self.present(deleteVC, animated: false, completion: nil)})
        
        deleteVC.rightButtonTapAction = { [weak self] in
            deleteVC.dismiss(animated: false)
            self?.deleteRecord()
        }
        
        [ editAction, deleteAction ].forEach { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Methods

extension ActivityRecordDetailVC {
    func setRecordId(recordId: Int?) {
        self.recordId = recordId
    }
    
    func setData(model: ActivityRecord) {
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
    
    private func setBlackTitle() -> UILabel {
        let label = UILabel()
        label.textColor = .g1
        label.font = .h3
        return label
    }
    
    private func setGreyTitle() -> UILabel {
        let label = UILabel()
        label.textColor = .g2
        label.font = .b4
        return label
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
}

// MARK: - Network

extension ActivityRecordDetailVC {
    private func deleteRecord() {
        guard let recordId = self.recordId else { return }
        print(recordId)
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
